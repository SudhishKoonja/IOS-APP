import SwiftUI

@main
struct EduMauriceApp: App {
    @StateObject private var timetable = TimetableStore()
    @StateObject private var events = EventStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timetable)
                .environmentObject(events)
        }
    }
}
