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

## Signed IPA builds

The workflow at `.github/workflows/build-signed-ipa.yml` archives the app and exports a signed IPA on every manually triggered workflow or `v*` tag. Add these GitHub Actions secrets before using it:

- `BUILD_CERTIFICATE_BASE64` — base64-encoded Apple Distribution `.p12`
- `P12_PASSWORD` — certificate password
- `BUILD_PROVISION_PROFILE_BASE64` — base64-encoded App Store provisioning profile
- `KEYCHAIN_PASSWORD` — temporary CI keychain password
- `TEAM_ID` — Apple Developer Team ID

Set the bundle identifier in `project.pbxproj` to one registered under that team before release. The IPA is uploaded as a 14-day workflow artifact.
