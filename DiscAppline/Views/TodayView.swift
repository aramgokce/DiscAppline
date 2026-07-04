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
    private let textColor = Color(red: 0.29, green: 0.20, blue: 0.13)
    private let softTextColor = Color(red: 0.47, green: 0.34, blue: 0.23)

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
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    routineToEdit = routine
                                }
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
            Text("Good Evening")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(textColor)

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

            Text(routines.first?.title ?? "No routines yet")
                .font(.title2)
                .bold()
                .foregroundStyle(textColor)

            Text(routines.first.map { formattedTime($0.time) } ?? "Add your first routine")
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
            Circle()
                .stroke(primaryColor, lineWidth: 2)
                .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.title)
                    .font(.headline)
                    .foregroundStyle(textColor)

                Text("\(routine.category) • \(formattedTime(routine.time))")
                    .font(.caption)
                    .foregroundStyle(softTextColor)
            }

            Spacer()

            Button(role: .destructive) {
                modelContext.delete(routine)
            } label: {
                Image(systemName: "trash")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
    }

    private func formattedTime(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: Routine.self, inMemory: true)
}
