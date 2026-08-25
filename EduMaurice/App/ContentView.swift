import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimetableView()
                .tabItem { Label("Timetable", systemImage: "calendar") }
            MinistryUpdatesView()
                .tabItem { Label("Updates", systemImage: "megaphone") }
            EventsView()
                .tabItem { Label("Events", systemImage: "figure.2.and.child.holdinghands") }
            StudentLifeView()
                .tabItem { Label("Life", systemImage: "sparkles") }
        }
        .tint(.teal)
    }
}
