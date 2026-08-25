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
        SchoolEvent(id: "mcf-live-calendar", title: "Mauritius chess tournaments", date: .now.addingTimeInterval(86400 * 4), location: "Across Mauritius", category: "Chess", capacity: nil, description: "Open the live Mauritius Chess Federation tournament list for youth, inter-college, rapid and open competitions.", sourceName: "Mauritius Chess Federation · Chess-Results", sourceURL: URL(string: "https://chess-results.com/fed.aspx?fed=MRI&lan=1")!, registrationURL: URL(string: "https://chess-results.com/fed.aspx?fed=MRI&lan=1"), ageRange: "Varies by tournament", isVerified: true)
    ]
}

enum ActivitySourceDirectory {
    static let sources: [ActivitySource] = [
        ActivitySource(id: "mcf", name: "Mauritius Chess Federation", focus: "Chess tournaments and inter-college competitions", url: URL(string: "https://chess-results.com/fed.aspx?fed=MRI&lan=1")!, systemImage: "checkerboard.rectangle"),
        ActivitySource(id: "nyp", name: "National Youth Parliament", focus: "Debate, citizenship, leadership and public speaking", url: URL(string: "https://mauritiusassembly.govmu.org/mauritiusassembly/")!, systemImage: "building.columns"),
        ActivitySource(id: "mys", name: "Ministry of Youth & Sports", focus: "Youth hubs, holiday programmes, arts and sports", url: URL(string: "https://mys.govmu.org/")!, systemImage: "figure.run"),
        ActivitySource(id: "nyc", name: "National Youth Council", focus: "Regional youth programmes and volunteering", url: URL(string: "https://nyc.govmu.org/")!, systemImage: "person.3"),
        ActivitySource(id: "moc", name: "Mauritius Olympic Committee", focus: "Olympic and grassroots sporting activities", url: URL(string: "https://www.mauritiusolympic.org/category/events/")!, systemImage: "medal"),
        ActivitySource(id: "jci", name: "JCI Mauritius", focus: "Leadership and public-speaking programmes", url: URL(string: "https://jci.cc/award-winner/public-speaking-club/")!, systemImage: "person.wave.2"),
        ActivitySource(id: "esu", name: "ESU Mauritius", focus: "School public speaking and international competitions", url: URL(string: "https://www.esu.org/international-esu/esu-mauritius/")!, systemImage: "mic")
    ]
}
