import Foundation

final class TimetableStore: ObservableObject {
    @Published private(set) var schedules: [SchoolDay: [Period]] = [:] { didSet { save() } }
    @Published private(set) var periodCounts: [SchoolDay: Int] = [:] { didSet { save() } }
    private let storageKey = "edu-maurice-timetable-v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(SavedTimetable.self, from: data) {
            schedules = saved.schedules
            periodCounts = saved.periodCounts
        } else {
            SchoolDay.allCases.forEach { day in setPeriodCount(6, for: day) }
        }
    }

    func periods(for day: SchoolDay) -> [Period] { schedules[day] ?? [] }

    func setPeriodCount(_ count: Int, for day: SchoolDay) {
        let safeCount = min(max(count, 1), 12)
        var periods = schedules[day] ?? []
        if periods.count < safeCount { periods += (periods.count + 1...safeCount).map { Period.empty(number: $0) } }
        schedules[day] = Array(periods.prefix(safeCount))
        periodCounts[day] = safeCount
    }

    func update(_ period: Period, for day: SchoolDay) {
        guard let index = schedules[day]?.firstIndex(where: { $0.id == period.id }) else { return }
        schedules[day]?[index] = period
    }

    private func save() {
        let saved = SavedTimetable(schedules: schedules, periodCounts: periodCounts)
        if let data = try? JSONEncoder().encode(saved) { UserDefaults.standard.set(data, forKey: storageKey) }
    }
}

private struct SavedTimetable: Codable {
    let schedules: [SchoolDay: [Period]]
    let periodCounts: [SchoolDay: Int]
}
