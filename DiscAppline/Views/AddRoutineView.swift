//
//  Untitled.swift
//  DiscAppline
//
//  Created by Aram Gokce on 7/1/26.
//
import SwiftUI
import SwiftData

struct AddRoutineView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let routineToEdit: Routine?

    @State private var title: String
    @State private var selectedCategory: RoutineCategory
    @State private var selectedTime: Date
    @State private var isReminderEnabled: Bool
    @State private var selectedRepeatType: RoutineRepeatType
    @State private var selectedDays: [RoutineWeekday]
    @State private var notes: String

    init(routineToEdit: Routine? = nil) {
        self.routineToEdit = routineToEdit

        _title = State(initialValue: routineToEdit?.title ?? "")
        _selectedCategory = State(initialValue: RoutineCategory(rawValue: routineToEdit?.category ?? "") ?? .health)
        _selectedTime = State(initialValue: routineToEdit?.time ?? Date())
        _isReminderEnabled = State(initialValue: routineToEdit?.isReminderEnabled ?? true)
        _selectedRepeatType = State(initialValue: RoutineRepeatType(rawValue: routineToEdit?.repeatType ?? "") ?? .everyDay)
        _selectedDays = State(initialValue: routineToEdit?.selectedDays.compactMap { RoutineWeekday(rawValue: $0) } ?? [])
        _notes = State(initialValue: routineToEdit?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Routine") {
                    TextField("Title", text: $title)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RoutineCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }

                Section("Reminder") {
                    Toggle("Reminder Enabled", isOn: $isReminderEnabled)
                }

                Section("Repeat") {
                    Picker("How Often", selection: $selectedRepeatType) {
                        ForEach(RoutineRepeatType.allCases) { repeatType in
                            Text(repeatType.rawValue).tag(repeatType)
                        }
                    }

                    if selectedRepeatType == .custom {
                        weekdaySelector
                    }
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(routineToEdit == nil ? "Add Routine" : "Edit Routine")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveRoutine()
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                }
            }
        }
    }

    private var weekdaySelector: some View {
        HStack {
            ForEach(RoutineWeekday.allCases) { day in
                Button {
                    toggleDay(day)
                } label: {
                    Text(day.shortName)
                        .font(.headline)
                        .frame(width: 34, height: 34)
                        .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundStyle(selectedDays.contains(day) ? .white : .primary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 6)
    }

    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        (selectedRepeatType == .custom && selectedDays.isEmpty)
    }

    private func saveRoutine() {
        if let routineToEdit {
            routineToEdit.title = title
            routineToEdit.category = selectedCategory.rawValue
            routineToEdit.time = selectedTime
            routineToEdit.isReminderEnabled = isReminderEnabled
            routineToEdit.repeatType = selectedRepeatType.rawValue
            routineToEdit.selectedDays = selectedDays.map { $0.rawValue }
            routineToEdit.notes = notes
        } else {
            let routine = Routine(
                title: title,
                category: selectedCategory.rawValue,
                time: selectedTime,
                isReminderEnabled: isReminderEnabled,
                repeatType: selectedRepeatType.rawValue,
                selectedDays: selectedDays.map { $0.rawValue },
                notes: notes
            )

            modelContext.insert(routine)
        }
    }

    private func toggleDay(_ day: RoutineWeekday) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

#Preview {
    AddRoutineView()
        .modelContainer(for: Routine.self, inMemory: true)
}
