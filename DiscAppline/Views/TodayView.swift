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

    var body: some View {
        NavigationStack {
            List {
                headerSection
                focusCard

                Section("Today's Routines") {
                    ForEach(routines) { routine in
                        routineRow(routine)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                routineToEdit = routine
                            }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddRoutine = true
                    } label: {
                        Image(systemName: "plus")
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

            Text("Build discipline, one routine at a time.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    private var focusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Up")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(routines.first?.title ?? "No routines yet")
                .font(.title2)
                .bold()

            Text(routines.first.map { formattedTime($0.time) } ?? "Add your first routine")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func routineRow(_ routine: Routine) -> some View {
        HStack(spacing: 12) {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(routine.title)
                    .font(.headline)

                Text("\(routine.category) • \(formattedTime(routine.time))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
