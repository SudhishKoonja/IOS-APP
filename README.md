# EduMaurice

EduMaurice is a SwiftUI iPhone app for Mauritian secondary-school students. It keeps a flexible timetable, shows nearby schools on a map, and makes extracurricular events easy to find and join.

## Included features

- Timetable with a separately configurable number of periods for each weekday
- Local, private timetable persistence using `UserDefaults`
- Ministry Updates tab for official school notices commonly shared through Facebook
- Event board with registration status and a "My registrations" view
- Student-life hub for bus planning, exam dates, homework, clubs, and wellbeing

## Run locally

Open `EduMaurice.xcodeproj` in Xcode 16 or later, select an iOS Simulator, and run. The project targets iOS 17.

## Ministry updates integration

The Updates tab deliberately does not scrape Facebook. Before release, configure it against the Ministry's verified page and an approved Meta/API or moderation integration; Facebook posts remain the authoritative source.

## Live youth-activity feed

Do not attempt to scrape every social post. Build a small server-side source registry instead: ingest pages only where the organiser permits automated access, respect `robots.txt`, cache results, preserve the original link/date, and require a human review before publishing to students. Start with the Ministry of Youth and Sports, the Mauritius Sports Council, the Mauritius Olympic Committee and participating youth organisations. For Facebook and Instagram, use an organiser-authorised Meta integration or let organisers submit events through a verified form—not browser scraping.

The implemented activity pipeline has two files:

- `data/candidates.json` is regenerated daily by GitHub Actions from permitted public pages. It is a private review queue and is never shown in the app.
- `data/events.json` is the verified public feed loaded by the app. After confirming the organiser, date, age range and registration link, copy an approved candidate here using the existing JSON shape.

The current source registry covers Mauritius Chess Federation/Chess-Results, National Youth Parliament, Ministry of Youth & Sports, National Youth Council, Mauritius Olympic Committee, JCI Mauritius and ESU Mauritius. The collector obeys `robots.txt`; inaccessible or disallowed sources are skipped.

## Signed IPA builds

The workflow at `.github/workflows/build-signed-ipa.yml` archives the app and exports a signed IPA on every manually triggered workflow or `v*` tag. Add these GitHub Actions secrets before using it:

- `BUILD_CERTIFICATE_BASE64` — base64-encoded Apple Distribution `.p12`
- `P12_PASSWORD` — certificate password
- `BUILD_PROVISION_PROFILE_BASE64` — base64-encoded App Store provisioning profile
- `KEYCHAIN_PASSWORD` — temporary CI keychain password
- `TEAM_ID` — Apple Developer Team ID

Set the bundle identifier in `project.pbxproj` to one registered under that team before release. The IPA is uploaded as a 14-day workflow artifact.

## Unsigned build (no Apple account)

Run **Build unsigned IPA** from the Actions tab. It compiles an unsigned, device-targeted `.ipa` and uploads it as an artifact. It cannot be installed on a physical iPhone until it is signed with an Apple-issued certificate and provisioning profile.
