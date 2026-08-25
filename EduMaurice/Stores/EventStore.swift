import Foundation

@MainActor
final class EventStore: ObservableObject {
    @Published private(set) var registeredIDs: Set<String> = [] { didSet { save() } }
    @Published private(set) var events: [SchoolEvent] = EventDirectory.events
    @Published private(set) var isLoading = false
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var refreshMessage: String?
    private let storageKey = "edu-maurice-event-registrations-v1"
    private let feedURL = URL(string: "https://raw.githubusercontent.com/SudhishKoonja/IOS-APP/main/data/events.json")!

    init() {
        registeredIDs = Set(UserDefaults.standard.stringArray(forKey: storageKey) ?? [])
    }

    func toggleRegistration(for event: SchoolEvent) {
        if registeredIDs.contains(event.id) { registeredIDs.remove(event.id) } else { registeredIDs.insert(event.id) }
    }
    func isRegistered(_ event: SchoolEvent) -> Bool { registeredIDs.contains(event.id) }

    func refresh() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            var request = URLRequest(url: feedURL)
            request.cachePolicy = .reloadRevalidatingCacheData
            request.timeoutInterval = 15
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([SchoolEvent].self, from: data)
            events = decoded.sorted { $0.date < $1.date }
            lastUpdated = .now
            refreshMessage = decoded.isEmpty ? "The verified feed is currently empty." : nil
        } catch {
            refreshMessage = "Showing saved starter activities. Live feed unavailable."
        }
    }

    private func save() { UserDefaults.standard.set(Array(registeredIDs), forKey: storageKey) }
}
