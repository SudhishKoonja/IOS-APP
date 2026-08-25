"""Collect review candidates from permitted public youth-activity pages.

This collector respects robots.txt and never accesses Instagram or Facebook.
Candidates are not published to the app until a maintainer verifies and copies
them into data/events.json.
"""

from __future__ import annotations

import hashlib
import json
import re
import urllib.parse
import urllib.request
import urllib.robotparser
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path

SOURCES = [
    ("Mauritius Chess Federation", "Chess", "https://chess-results.com/fed.aspx?fed=MRI&lan=1", r"\b2026\b"),
    ("National Youth Parliament", "Debate", "https://mauritiusassembly.govmu.org/mauritiusassembly/", r"national youth parliament|\bNYP\b"),
    ("Ministry of Youth & Sports", "Youth", "https://mys.govmu.org/News/SitePages/AllItems.aspx", None),
    ("National Youth Council", "Youth", "https://nyc.govmu.org/", None),
    ("Mauritius Olympic Committee", "Sport", "https://www.mauritiusolympic.org/category/events/", None),
    ("JCI Mauritius", "Public speaking", "https://jci.cc/award-winner/public-speaking-club/", r"public speaking|youth|competition|workshop"),
    ("ESU Mauritius", "Public speaking", "https://www.esu.org/international-esu/esu-mauritius/", r"public speaking|competition|student|youth"),
]

KEYWORDS = re.compile(
    r"\b(youth|jeune|zenes|chess|échecs|tournament|championship|competition|"
    r"parliament|public speaking|debate|workshop|programme|registration|register|"
    r"volunteer|camp|activity|activities|event|sport)\b",
    re.IGNORECASE,
)


class LinkParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: list[tuple[str, str]] = []
        self._href: str | None = None
        self._text: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.lower() == "a":
            self._href = dict(attrs).get("href")
            self._text = []

    def handle_data(self, data: str) -> None:
        if self._href is not None:
            self._text.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag.lower() == "a" and self._href:
            text = re.sub(r"\s+", " ", " ".join(self._text)).strip()
            if text:
                self.links.append((text, self._href))
            self._href = None
            self._text = []


def allowed(url: str) -> bool:
    parts = urllib.parse.urlsplit(url)
    robots_url = f"{parts.scheme}://{parts.netloc}/robots.txt"
    parser = urllib.robotparser.RobotFileParser()
    parser.set_url(robots_url)
    try:
        parser.read()
        return parser.can_fetch("EduMauriceActivityCollector/1.0", url)
    except OSError:
        return False


def fetch(url: str) -> str:
    request = urllib.request.Request(
        url,
        headers={"User-Agent": "EduMauriceActivityCollector/1.0 (+https://github.com/SudhishKoonja/IOS-APP)"},
    )
    with urllib.request.urlopen(request, timeout=20) as response:
        charset = response.headers.get_content_charset() or "utf-8"
        return response.read(2_000_000).decode(charset, errors="replace")


def collect() -> list[dict[str, object]]:
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    output = Path(__file__).resolve().parents[1] / "data" / "candidates.json"
    try:
        existing = {item["id"]: item for item in json.loads(output.read_text(encoding="utf-8"))}
    except (OSError, json.JSONDecodeError, KeyError, TypeError):
        existing = {}
    found: dict[str, dict[str, object]] = {}
    successful_sources: set[str] = set()
    for source_name, category, source_url, required_pattern in SOURCES:
        if not allowed(source_url):
            continue
        try:
            parser = LinkParser()
            parser.feed(fetch(source_url))
        except (OSError, UnicodeError):
            continue
        successful_sources.add(source_name)
        accepted = 0
        for title, href in parser.links:
            if len(title) < 8 or len(title) > 180 or not KEYWORDS.search(title):
                continue
            if required_pattern and not re.search(required_pattern, title, re.IGNORECASE):
                continue
            link = urllib.parse.urljoin(source_url, href)
            if urllib.parse.urlsplit(link).scheme not in {"http", "https"}:
                continue
            candidate_id = hashlib.sha256(f"{source_name}|{link}".encode()).hexdigest()[:20]
            candidate = {
                "id": candidate_id,
                "title": title,
                "category": category,
                "sourceName": source_name,
                "sourceURL": link,
                "discoveredAt": existing.get(candidate_id, {}).get("discoveredAt", now),
                "reviewStatus": "needs-review",
            }
            found[candidate_id] = candidate
            accepted += 1
            if accepted >= 40:
                break
    for candidate_id, candidate in existing.items():
        if candidate.get("sourceName") not in successful_sources:
            found[candidate_id] = candidate
    return sorted(found.values(), key=lambda item: (str(item["sourceName"]), str(item["title"])))


if __name__ == "__main__":
    output = Path(__file__).resolve().parents[1] / "data" / "candidates.json"
    output.write_text(json.dumps(collect(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
