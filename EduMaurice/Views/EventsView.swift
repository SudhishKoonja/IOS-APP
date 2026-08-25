import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var registeredOnly = false
    @State private var selectedCategory = "All"
    @State private var showingSources = false
    @State private var searchText = ""

    private var categories: [String] {
        ["All"] + Array(Set(store.events.map(\.category))).sorted()
    }

    private var filteredEvents: [SchoolEvent] {
        store.events.filter { event in
            (!registeredOnly || store.isRegistered(event)) &&
            (selectedCategory == "All" || event.category == selectedCategory) &&
            (searchText.isEmpty || [event.title, event.location, event.description, event.sourceName]
                .contains { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    hero
                    categoryPicker
                    if let message = store.refreshMessage {
                        Label(message, systemImage: "info.circle")
                            .font(.caption).foregroundStyle(.secondary).padding(.horizontal, 4)
                    }
                    if filteredEvents.isEmpty {
                        ContentUnavailableView(
                            registeredOnly ? "No saved activities" : "No matching activities",
                            systemImage: "ticket",
                            description: Text(registeredOnly ? "Save an activity and it will appear here." : "Try another category or search.")
                        )
                        .frame(maxWidth: .infinity).padding(.vertical, 48)
                    } else {
                        ForEach(filteredEvents) { event in EventCard(event: event).glassCard() }
                    }
                }
                .padding()
            }
            .background(GlassBackground())
            .navigationTitle("Activities")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Chess, debate, volunteering…")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingSources = true } label: { Image(systemName: "checkmark.seal") }
                        .accessibilityLabel("Verified sources")
                }
            }
            .refreshable { await store.refresh() }
            .task { if store.lastUpdated == nil { await store.refresh() } }
            .sheet(isPresented: $showingSources) { ActivitySourcesView() }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Find your next thing.").font(.title2.bold())
                    Text("Verified youth opportunities across Mauritius.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                if store.isLoading { ProgressView().tint(.teal) }
            }
            Toggle("Saved activities only", isOn: $registeredOnly)
                .tint(.teal).padding(.top, 5)
        }
        .padding().glassCard()
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(category) { selectedCategory = category }
                        .font(.subheadline.weight(.semibold))
                        .buttonStyle(.borderedProminent)
                        .tint(selectedCategory == category ? .teal : .gray.opacity(0.28))
                }
            }
        }
    }
}

private struct EventCard: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.openURL) private var openURL
    let event: SchoolEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text(event.category.uppercased()).font(.caption.bold()).foregroundStyle(.teal)
                if event.isVerified { Label("Verified", systemImage: "checkmark.seal.fill").font(.caption2.bold()).foregroundStyle(.blue) }
                Spacer()
                Text(event.date, style: .date).font(.caption).foregroundStyle(.secondary)
            }
            Text(event.title).font(.headline)
            Text(event.description).font(.subheadline).foregroundStyle(.secondary)
            Label(event.location, systemImage: "mappin.and.ellipse").font(.caption)
            if let ageRange = event.ageRange { Label(ageRange, systemImage: "person.2").font(.caption) }
            Button { openURL(event.sourceURL) } label: {
                Label(event.sourceName, systemImage: "link").font(.caption).lineLimit(1)
            }
            .buttonStyle(.plain).foregroundStyle(.teal)
            HStack {
                Button(store.isRegistered(event) ? "Saved ✓" : "Save") { store.toggleRegistration(for: event) }
                    .buttonStyle(.bordered).tint(store.isRegistered(event) ? .green : .teal)
                if let registrationURL = event.registrationURL {
                    Link(destination: registrationURL) { Label("View details", systemImage: "arrow.up.right") }
                        .buttonStyle(.borderedProminent).tint(.teal)
                }
            }
        }
        .padding()
    }
}

private struct ActivitySourcesView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(ActivitySourceDirectory.sources) { source in
                Link(destination: source.url) {
                    Label {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(source.name).font(.headline).foregroundStyle(.primary)
                            Text(source.focus).font(.subheadline).foregroundStyle(.secondary)
                        }
                    } icon: { Image(systemName: source.systemImage).foregroundStyle(.teal) }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Verified sources").navigationBarTitleDisplayMode(.inline)
            .toolbar { Button("Done") { dismiss() } }
        }
    }
}
