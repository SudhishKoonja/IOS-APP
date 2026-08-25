import Foundation

enum SchoolDirectory {
    static let schools: [School] = [
        School(name: "Royal College Curepipe", district: "Plaines Wilhems", category: "State secondary", coordinate: .init(latitude: -20.3181, longitude: 57.5229)),
        School(name: "Queen Elizabeth College", district: "Plaines Wilhems", category: "State secondary", coordinate: .init(latitude: -20.3176, longitude: 57.5181)),
        School(name: "Dr. Maurice Curé State College", district: "Moka", category: "State secondary", coordinate: .init(latitude: -20.2213, longitude: 57.4866)),
        School(name: "College du Saint Esprit", district: "Moka", category: "Private secondary", coordinate: .init(latitude: -20.2233, longitude: 57.4956)),
        School(name: "Sookdeo Bissoondoyal State College", district: "Flacq", category: "State secondary", coordinate: .init(latitude: -20.1944, longitude: 57.7246)),
        School(name: "Port Louis SSS", district: "Port Louis", category: "State secondary", coordinate: .init(latitude: -20.1609, longitude: 57.5012))
    ]
}

enum EventDirectory {
    static let events: [SchoolEvent] = [
        SchoolEvent(id: "robotics-2026", title: "National Robotics Challenge", date: .now.addingTimeInterval(86400 * 12), location: "Ebène Recreational Park", category: "STEM", capacity: 80, description: "Build, code, and compete with students from around the island."),
        SchoolEvent(id: "athletics-2026", title: "Inter-College Athletics", date: .now.addingTimeInterval(86400 * 21), location: "Maryse Justin Stadium, Réduit", category: "Sport", capacity: 200, description: "Track, field and team events. Register through your school sports teacher."),
        SchoolEvent(id: "voices-2026", title: "Young Voices Showcase", date: .now.addingTimeInterval(86400 * 31), location: "Caudan Arts Centre", category: "Arts", capacity: 120, description: "Music, spoken word and theatre performances for secondary students.")
    ]
}
