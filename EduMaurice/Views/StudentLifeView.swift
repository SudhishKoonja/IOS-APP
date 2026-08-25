import SwiftUI

struct StudentLifeView: View {
    private let tools = [
        ("Bus & commute", "Save your route, bus times and pickup reminder.", "bus"),
        ("Exam countdown", "Track assessments, SC/HSC dates and revision plans.", "books.vertical"),
        ("Homework planner", "Break assignments into doable daily tasks.", "checklist"),
        ("Clubs & volunteering", "Discover clubs, leadership and community projects.", "hands.sparkles"),
        ("Wellbeing check-in", "Private mood and study-load check-ins with support links.", "heart"),
        ("School notices", "One place for closure, weather and activity notices.", "bell")
    ]
    var body: some View { NavigationStack { List {
        Section { Text("A calmer school week, from the morning bus to after-school clubs.").font(.subheadline).foregroundStyle(.secondary) }
        Section("Coming next") { ForEach(tools, id: \.0) { tool in Label { VStack(alignment: .leading) { Text(tool.0).font(.headline); Text(tool.1).font(.subheadline).foregroundStyle(.secondary) } } icon: { Image(systemName: tool.2).foregroundStyle(.teal) }.padding(.vertical, 4) } }
        Section("Made for Mauritius") { Text("Support English, French and Mauritian Creole; show local public holidays; and let schools publish verified notices without exposing student data.").font(.footnote) }
    }.navigationTitle("Student life") } }
}
