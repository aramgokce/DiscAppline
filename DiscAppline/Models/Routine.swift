//
//  Routine.swift
//  DiscAppline
//
//  Created by Aram Gokce on 7/1/26.
//
import Foundation
import SwiftData

@Model
final class Routine {
    var title: String
    var category: String
    var time: Date
    var isReminderEnabled: Bool
    var repeatType: String
    var selectedDays: [String]
    var notes: String
    var isCompleted: Bool

    init(
        title: String,
        category: String,
        time: Date,
        isReminderEnabled: Bool,
        repeatType: String,
        selectedDays: [String],
        notes: String,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.category = category
        self.time = time
        self.isReminderEnabled = isReminderEnabled
        self.repeatType = repeatType
        self.selectedDays = selectedDays
        self.notes = notes
        self.isCompleted = isCompleted
    }
}

enum RoutineCategory: String, CaseIterable, Identifiable {
    case health = "Health"
    case growth = "Growth"
    case work = "Work"
    case personal = "Personal"

    var id: String { rawValue }
}

enum RoutineRepeatType: String, CaseIterable, Identifiable {
    case oneTime = "One Time"
    case everyDay = "Every Day"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case custom = "Custom"

    var id: String { rawValue }
}

enum RoutineWeekday: String, CaseIterable, Identifiable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: String { fullName }

    var shortName: String {
        switch self {
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "T"
        case .friday: return "F"
        case .saturday: return "S"
        case .sunday: return "S"
        }
    }

    var fullName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
}
