import SwiftUI

struct MinistryUpdatesView: View {
    private let updates = [
        ("School notices", "Follow official Ministry announcements, closures and term dates in one calm feed.", "bell.badge.fill", Color.orange),
        ("Weather & safety", "See verified updates before leaving for school during heavy rain or cyclone alerts.", "cloud.rain.fill", Color.blue),
        ("Exams & admissions", "Keep an eye on examination, scholarship and admission notices.", "graduationcap.fill", Color.purple)
    ]
    @State private var showingFacebook = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Official updates,\nmade readable.").font(.largeTitle.bold())
                        Text("A student-friendly window into Ministry announcements shared on Facebook.").foregroundStyle(.secondary)
                        Button { showingFacebook = true } label: { Label("Open Ministry Facebook", systemImage: "arrow.up.right.square.fill") }.buttonStyle(.borderedProminent).tint(.teal)
                    }.padding().glassCard()
                    Text("What we’ll keep you informed about").font(.headline).padding(.horizontal, 4)
                    ForEach(updates, id: \.0) { update in
                        HStack(spacing: 14) { Image(systemName: update.2).font(.title2).foregroundStyle(update.3).frame(width: 38); VStack(alignment: .leading, spacing: 3) { Text(update.0).font(.headline); Text(update.1).font(.subheadline).foregroundStyle(.secondary) } }.padding().glassCard()
                    }
                    Text("The Ministry’s Facebook posts remain the source of truth. In production, connect their approved feed/API or a permissioned moderation service—do not scrape Facebook posts.").font(.footnote).foregroundStyle(.secondary).padding(.horizontal, 8)
                }.padding()
            }.background(GlassBackground())
            .navigationTitle("Ministry updates").navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFacebook) { MinistryLinkView() }
        }
    }
}

private struct MinistryLinkView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View { NavigationStack { ContentUnavailableView("Connect the official page", systemImage: "network", description: Text("Configure the Ministry of Education’s verified Facebook page URL in your deployment. This starter avoids embedding an unverified link.")) .navigationTitle("Official source").toolbar { Button("Done") { dismiss() } } } }
}
