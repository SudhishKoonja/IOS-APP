import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var registeredOnly = false
    private var events: [SchoolEvent] { registeredOnly ? EventDirectory.events.filter(store.isRegistered) : EventDirectory.events }
    var body: some View { NavigationStack { List {
        Section { Toggle("My registrations only", isOn: $registeredOnly) }
        ForEach(events) { event in EventCard(event: event) }
    }.navigationTitle("Explore events") } }
}

private struct EventCard: View {
    @EnvironmentObject private var store: EventStore
    let event: SchoolEvent
    var body: some View { VStack(alignment: .leading, spacing: 7) {
        HStack { Text(event.category.uppercased()).font(.caption.bold()).foregroundStyle(.teal); Spacer(); Text(event.date, style: .date).font(.caption).foregroundStyle(.secondary) }
        Text(event.title).font(.headline); Text(event.description).font(.subheadline).foregroundStyle(.secondary); Label(event.location, systemImage: "mappin.and.ellipse").font(.caption)
        Button(store.isRegistered(event) ? "Registered ✓" : "Register") { store.toggleRegistration(for: event) }.buttonStyle(.borderedProminent).tint(store.isRegistered(event) ? .green : .teal)
    }.padding(.vertical, 5) }
}
