// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

// MARK: - DateRange

/// A utility for creating date ranges.
public struct DateRange {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public enum WithinRangeProvided {
    case custom((start: Date, end: Date))
    case predefined(DateRangeValue)
  }

  /// Creates a date range for the specified range.
  /// - Parameters:
  ///  - range: The range to create a date range for.
  ///  - now: The current date.
  ///  - Throws: `DateRangeError`
  ///  - Returns: A tuple containing the start and end dates of the range.
  public static func createDateRange(for range: DateRangeValue, now: Date = Date.now) throws -> (start: Date, end: Date) {
    let calendar = Calendar.current

    switch range {
    case .today:
      let start = calendar.startOfDay(for: now)
      let end = try calendar.endOfDay(for: now)
      return (start, end)


    case .lastSevenDays:
      guard let start = calendar.date(byAdding: .day, value: -7, to: now) else {
        throw DateRangeError.failedToCreateDateRangeForLastSevenDays
      }
      return (start, now)
    case .lastThirtyDays:
      guard let start = calendar.date(byAdding: .day, value: -30, to: now) else {
        throw DateRangeError.failedToCreateDateRangeForLastThirtyDays
      }
      return (start, now)
    case .lastNinetyDays:
      guard let start = calendar.date(byAdding: .day, value: -90, to: now) else {
        throw DateRangeError.failedToCreateDateRangeForLastNinetyDays
      }
      return (start, now)
    case .lastMonth:
      guard let start = calendar.date(byAdding: .month, value: -1, to: try calendar.startOfMonth(for: now)) else {
        throw DateRangeError.failedToCreateDateRangeForLastMonth
      }
      let end = try calendar.endOfMonth(for: start)
      return (start, end)
    case .thisMonth:
      return (try calendar.startOfMonth(for: now), try calendar.endOfMonth(for: now))
    case .lastWeek:
      guard let start = calendar.date(byAdding: .weekOfYear, value: -1, to: try calendar.startOfWeek(for: now)) else {
        throw DateRangeError.failedToCreateDateRangeForLastWeek
      }
      let end = try calendar.endOfWeek(for: start)
      return (start, end)
    }
  }

  /// Determines if a date is within the specified range.
  public static func dateIsWithinRange(_ date: Date, range: WithinRangeProvided) throws -> Bool {
    switch range {
    case .custom(let dates):
      return date >= dates.start && date <= dates.end
    case .predefined(let value):
      let (start, end) = try createDateRange(for: value)
      return date >= start && date <= end
    }
  }

}

// MARK: - DateRangeValue

public enum DateRangeValue: String, CaseIterable {
  case today = "Today"
  case lastSevenDays = "Last 7 Days"
  case lastThirtyDays = "Last 30 Days"
  case lastNinetyDays = "Last 90 Days"
  case lastMonth = "Last Month"
  case thisMonth = "This Month"
  case lastWeek = "Last Week"
}

extension Calendar {
  public func endOfDay(for date: Date) throws -> Date {
    guard let value = self.date(bySettingHour: 23, minute: 59, second: 59, of: date) else {
      throw DateRangeError.failedToGetEndOfDay
    }
    return value
  }

  public func startOfMonth(for date: Date) throws -> Date {
    guard let value = self.date(from: dateComponents([.year, .month], from: date)) else {
      throw DateRangeError.failedToGetStartOfMonth
    }
    return value
  }

  public func endOfMonth(for date: Date) throws -> Date {
    let components = DateComponents(month: 1, second: -1)
    guard let value = self.date(byAdding: components, to: try startOfMonth(for: date)) else {
      throw DateRangeError.failedToGetEndOfMonth
    }
    return value
  }

  public func startOfWeek(for date: Date) throws -> Date {
    let components = dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date)
    guard let value = self.date(from: components) else {
      throw DateRangeError.failedToGetStartOfWeek
    }
    return value
  }

  public func endOfWeek(for date: Date) throws -> Date {
    let components = DateComponents(second: -1, weekOfYear: 1)
    guard let value = self.date(byAdding: components, to: try startOfWeek(for: date)) else {
      throw DateRangeError.failedToGetEndOfWeek
    }
    return value
  }
}

// MARK: - DateRangeError

public enum DateRangeError: Error, LocalizedError {
  case invalidDateRange
  case failedToGetStartOfDay
  case failedToGetEndOfDay
  case failedToGetStartOfMonth
  case failedToGetEndOfMonth
  case failedToGetStartOfWeek
  case failedToGetEndOfWeek

  case failedToCreateDateRangeForLastSevenDays
  case failedToCreateDateRangeForLastThirtyDays
  case failedToCreateDateRangeForLastNinetyDays
  case failedToCreateDateRangeForLastMonth
  case failedToCreateDateRangeForThisMonth
  case failedToCreateDateRangeForLastWeek

  // MARK: Public

  public var errorDescription: String? {
    switch self {
    case .invalidDateRange:
      "Invalid date range"
    case .failedToGetStartOfDay:
      "Failed to get start of day"
    case .failedToGetEndOfDay:
      "Failed to get end of day"
    case .failedToGetStartOfMonth:
      "Failed to get start of month"
    case .failedToGetEndOfMonth:
      "Failed to get end of month"
    case .failedToGetStartOfWeek:
      "Failed to get start of week"
    case .failedToGetEndOfWeek:
      "Failed to get end of week"
    case .failedToCreateDateRangeForLastSevenDays:
      "Failed to create date range for last seven days"
    case .failedToCreateDateRangeForLastThirtyDays:
      "Failed to create date range for last thirty days"
    case .failedToCreateDateRangeForLastNinetyDays:
      "Failed to create date range for last ninety days"
    case .failedToCreateDateRangeForLastMonth:
      "Failed to create date range for last month"
    case .failedToCreateDateRangeForThisMonth:
      "Failed to create date range for this month"
    case .failedToCreateDateRangeForLastWeek:
      "Failed to create date range for last week"
    }
  }
}
