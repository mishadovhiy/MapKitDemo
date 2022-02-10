//
//  Calendar.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 09.02.2022.
//

import UIKit

extension TableCellCollectionView {
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range(
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
      else {
        // 3
        throw CalendarDataError.metadataGeneration
    }

    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  // 1
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // 2
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }

    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay

    // 3
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // 4
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // 5
        let dayOffset =
          isWithinDisplayedMonth ?
          day - offsetInInitialRow :
          -(offsetInInitialRow - day)

        // 6
        return generateDay(
          offsetBy: dayOffset,
          for: firstDayOfMonth,
          isWithinDisplayedMonth: isWithinDisplayedMonth)
      }

    days += generateStartOfNextMonth(using: firstDayOfMonth)

    return days
  }

  // 7
  func generateDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate)
      ?? baseDate

    return Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate ?? Date()),
      isWithinDisplayedMonth: isWithinDisplayedMonth
    )
  }

  // 1
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
    // 2
    guard
      let lastDayInMonth = calendar.date(
        byAdding: DateComponents(month: 1, day: -1),
        to: firstDayOfDisplayedMonth)
      else {
        return []
    }

    // 3
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }

    // 4
    let days: [Day] = (1...additionalDays)
      .map {
        generateDay(
        offsetBy: $0,
        for: lastDayInMonth,
        isWithinDisplayedMonth: false)
      }

    return days
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
    
    
    
    struct Day {
      // 1
      let date: Date
      // 2
      let number: String
      // 3
      let isSelected: Bool
      // 4
      let isWithinDisplayedMonth: Bool
    }
    
    struct MonthMetadata {
      let numberOfDays: Int
      let firstDay: Date
      let firstDayWeekday: Int
    }
}
