//
//  TodayView.swift
//  DiscAppline
//
//  Created by Aram Gokce on 7/1/26.
//
import SwiftUI
import SwiftData

struct TodayView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Routine.time) private var routines: [Routine]

    @State private var isShowingAddRoutine = false
    @State private var routineToEdit: Routine?

    private let backgroundColor = Color(red: 0.88, green: 0.79, blue: 0.66)
    private let cardColor = Color(red: 0.96, green: 0.89, blue: 0.78)
    private let primaryColor = Color(red: 0.58, green: 0.38, blue: 0.20)
    private let completedColor = Color(red: 0.48, green: 0.58, blue: 0.38)
    private let textColor = Color(red: 0.29, green: 0.20, blue: 0.13)
    private let softTextColor = Color(red: 0.47, green: 0.34, blue: 0.23)

    private var nextRoutine: Routine? {
        routines.first { !$0.isCompleted }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                List {
                    headerSection
                        .listRowBackground(backgroundColor)

                    focusCard
                        .listRowBackground(backgroundColor)

                    Section("Today's Routines") {
                        ForEach(routines) { routine in
                            routineRow(routine)
                                .listRowBackground(cardColor)
                        }
                    }
                    .foregroundStyle(textColor)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddRoutine = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                }
            }
            .sheet(isPresented: $isShowingAddRoutine) {
                AddRoutineView()
            }
            .sheet(item: $routineToEdit) { routine in
                AddRoutineView(routineToEdit: routine)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(greeting)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(textColor)

            Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.headline)
                .foregroundStyle(primaryColor)

            Text("Build discipline, one routine at a time.")
                .font(.subheadline)
                .foregroundStyle(softTextColor)
        }
        .padding(.vertical, 8)
    }

    private var focusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Up")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(primaryColor)

            Text(nextRoutine?.title ?? "All done")
                .font(.title2)
                .bold()
                .foregroundStyle(textColor)

            Text(nextRoutine.map { formattedTime($0.time) } ?? "Nice work for today")
                .font(.subheadline)
                .foregroundStyle(softTextColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .brown.opacity(0.18), radius: 12, x: 0, y: 6)
    }

    private func routineRow(_ routine: Routine) -> some View {
        HStack(spacing: 12) {
            Button {
                routine.isCompleted.toggle()
            } label: {
                Image(systemName: routine.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(routine.isCompleted ? completedColor : primaryColor)
            }
            .buttonStyle(.borderless)

            Image(systemName: categoryIcon(for: routine))
                .font(.title3)
                .foregroundStyle(primaryColor)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.title)
                    .font(.headline)
                    .foregroundStyle(routine.isCompleted ? softTextColor : textColor)
                    .strikethrough(routine.isCompleted, color: softTextColor)

                Text("\(routine.category) • \(formattedTime(routine.time))")
                    .font(.caption)
                    .foregroundStyle(softTextColor)
            }

            Spacer()

            Button {
                routineToEdit = routine
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(primaryColor)
            }
            .buttonStyle(.borderless)

            Button(role: .destructive) {
                modelContext.delete(routine)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
    }

    private func categoryIcon(for routine: Routine) -> String {
        RoutineCategory(rawValue: routine.category)?.icon ?? "circle.fill"
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good Morning ☀️"
        case 12..<17:
            return "Good Afternoon 🌤"
        case 17..<22:
            return "Good Evening 🌙"
        default:
            return "Good Night 🌙"
        }
    }

    private func formattedTime(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: Routine.self, inMemory: true)
}
