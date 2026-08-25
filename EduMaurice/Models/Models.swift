import Foundation
import CoreLocation

enum SchoolDay: String, CaseIterable, Identifiable, Codable {
    case monday, tuesday, wednesday, thursday, friday
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var shortTitle: String { String(title.prefix(3)) }
}

struct Period: Identifiable, Codable, Hashable {
    var id = UUID()
    var subject: String
    var room: String
    var teacher: String
    var startTime: Date
    var endTime: Date

    static func empty(number: Int) -> Period {
        let calendar = Calendar.current
        let start = calendar.date(bySettingHour: 7 + number, minute: 30, second: 0, of: .now) ?? .now
        return Period(subject: "Period \(number)", room: "", teacher: "", startTime: start, endTime: start.addingTimeInterval(45 * 60))
    }
}

struct School: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let district: String
    let category: String
    let coordinate: CLLocationCoordinate2D
}

struct SchoolEvent: Identifiable, Hashable {
    let id: String
    let title: String
    let date: Date
    let location: String
    let category: String
    let capacity: Int
    let description: String
}
