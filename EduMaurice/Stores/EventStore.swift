import Foundation

final class EventStore: ObservableObject {
    @Published private(set) var registeredIDs: Set<String> = [] { didSet { save() } }
    private let storageKey = "edu-maurice-event-registrations-v1"

    init() {
        registeredIDs = Set(UserDefaults.standard.stringArray(forKey: storageKey) ?? [])
    }

    func toggleRegistration(for event: SchoolEvent) {
        if registeredIDs.contains(event.id) { registeredIDs.remove(event.id) } else { registeredIDs.insert(event.id) }
    }
    func isRegistered(_ event: SchoolEvent) -> Bool { registeredIDs.contains(event.id) }
    private func save() { UserDefaults.standard.set(Array(registeredIDs), forKey: storageKey) }
}
