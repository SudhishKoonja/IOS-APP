import SwiftUI

struct MinistryUpdatesView: View {
    private let updates = [
        ("School notices", "Follow official Ministry announcements, closures and term dates in one calm feed.", "bell.badge.fill", Color.orange),
        ("Weather & safety", "See verified updates before leaving for school during heavy rain or cyclone alerts.", "cloud.rain.fill", Color.blue),
        ("Exams & admissions", "Keep an eye on examination, scholarship and admission notices.", "graduationcap.fill", Color.purple)
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Official updates,\nmade readable.").font(.largeTitle.bold())
                        Text("Check the issuing authority before acting on a closure or safety notice.").foregroundStyle(.secondary)
                        HStack {
                            Link(destination: URL(string: "https://gis.govmu.org/gis/")!) { Label("GIS News", systemImage: "newspaper") }
                            Link(destination: URL(string: "https://education.govmu.org/")!) { Label("Education", systemImage: "arrow.up.right") }
                        }
                        .buttonStyle(.borderedProminent).tint(.teal)
                    }.padding().glassCard()
                    Text("What we’ll keep you informed about").font(.headline).padding(.horizontal, 4)
                    ForEach(updates, id: \.0) { update in
                        HStack(spacing: 14) { Image(systemName: update.2).font(.title2).foregroundStyle(update.3).frame(width: 38); VStack(alignment: .leading, spacing: 3) { Text(update.0).font(.headline); Text(update.1).font(.subheadline).foregroundStyle(.secondary) } }.padding().glassCard()
                    }
                    Text("EduMaurice does not decide whether school is open. Always confirm urgent notices with GIS Mauritius or the Ministry of Education; the issuing authority remains the source of truth.").font(.footnote).foregroundStyle(.secondary).padding(.horizontal, 8)
                }.padding()
            }.background(GlassBackground())
            .navigationTitle("Ministry updates").navigationBarTitleDisplayMode(.inline)
        }
    }
}
