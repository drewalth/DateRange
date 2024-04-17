// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

// MARK: - DateRange

public struct DateRange {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func createDateRange(for range: DateRangeValue, now: Date = Date.now) throws -> (start: Date, end: Date) {
    let calendar = Calendar.current

    switch range {
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

  public func dateIsWithinRange(_ date: Date, range: (start: Date, end: Date)) -> Bool {
    date >= range.start && date <= range.end
  }

}

// MARK: - DateRangeValue

public enum DateRangeValue {
  case lastSevenDays
  case lastThirtyDays
  case lastNinetyDays
  case lastMonth
  case thisMonth
  case lastWeek
}

extension Calendar {
  public func startOfDay(for date: Date) throws -> Date {
    guard let value = self.date(bySettingHour: 0, minute: 0, second: 0, of: date) else {
      throw DateRangeError.failedToGetStartOfDay
    }
    return value
  }

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
