import SwiftUI

struct TimetableView: View {
    @EnvironmentObject private var timetable: TimetableStore
    @State private var selectedDay: SchoolDay = .monday
    @State private var isConfiguring = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(SchoolDay.allCases) { Text($0.title).tag($0) }
                    }.pickerStyle(.segmented)
                }
                Section("\(selectedDay.title)'s classes") {
                    ForEach(timetable.periods(for: selectedDay).indices, id: \.self) { index in
                        PeriodRow(period: timetable.periods(for: selectedDay)[index], number: index + 1) { timetable.update($0, for: selectedDay) }
                    }
                }
                Section {
                    Text("Your timetable stays on this device. Add subjects, rooms and teachers to make each day yours.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("My timetable")
            .toolbar { Button("Periods") { isConfiguring = true } }
            .sheet(isPresented: $isConfiguring) { PeriodSettingsView() }
        }
    }
}

private struct PeriodRow: View {
    @State var period: Period
    let number: Int
    let onSave: (Period) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Text("\(number)").font(.caption.bold()).foregroundStyle(.teal); TextField("Subject", text: $period.subject).font(.headline) }
            HStack { TextField("Teacher", text: $period.teacher); TextField("Room", text: $period.room).multilineTextAlignment(.trailing) }.font(.subheadline).foregroundStyle(.secondary)
        }.onChange(of: period) { _, value in onSave(value) }
    }
}

private struct PeriodSettingsView: View {
    @EnvironmentObject private var timetable: TimetableStore
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack { Form { ForEach(SchoolDay.allCases) { day in
            Stepper("\(day.title): \(timetable.periodCounts[day] ?? 6) periods", value: Binding(get: { timetable.periodCounts[day] ?? 6 }, set: { timetable.setPeriodCount($0, for: day) }), in: 1...12)
        } }.navigationTitle("Periods per day").toolbar { Button("Done") { dismiss() } } }
    }
}
