import XCTest
@testable import DateRange

final class DateRangeTests: XCTestCase {
  var fixedDate: Date!


  override func setUp() {
    super.setUp()
    // Setup a fixed date, e.g., January 1, 2021, 12:00 PM
    var components = DateComponents()
    components.year = 2021
    components.month = 1
    components.day = 1
    components.hour = 12
    components.minute = 0
    components.second = 0
    components.timeZone = TimeZone(secondsFromGMT: 0) // UTC for simplicity
    fixedDate = Calendar.current.date(from: components)!
  }


  func testLastMonthRange() throws {
    let dateRange = DateRange()
    let (start, end) = try dateRange.createDateRange(for: .lastMonth, now: fixedDate)

    XCTAssertEqual(start.formatted(), "12/1/2020, 12:00 AM")
    XCTAssertEqual(end.formatted(), "12/31/2020, 11:59 PM")
  }

  func testThisMonthRange() throws {
    let dateRange = DateRange()
    let (start, end) = try dateRange.createDateRange(for: .thisMonth, now: fixedDate)

    XCTAssertEqual(start.formatted(), "1/1/2021, 12:00 AM")
    XCTAssertEqual(end.formatted(), "1/31/2021, 11:59 PM")
  }

  func testLastWeekRange() throws {
    let dateRange = DateRange()
    let (start, end) = try dateRange.createDateRange(for: .lastWeek, now: fixedDate)

    XCTAssertEqual(start.formatted(), "12/20/2020, 12:00 AM")
    XCTAssertEqual(end.formatted(), "12/26/2020, 11:59 PM")
  }

  func testDateIsWithinRange_outOfRange() throws {
    let dateRange = DateRange()
    let date = fixedDate!

    let testRange: DateRange.WithinRangeProvided = .custom((
      start: fixedDate.addingTimeInterval(-1000),
      end: fixedDate.addingTimeInterval(-500)))

    XCTAssertFalse(try dateRange.dateIsWithinRange(date, range: testRange))
  }

  func testDateIsWithinRange_inRange() throws {
    let dateRange = DateRange()
    let date = fixedDate!
    let testRange: DateRange.WithinRangeProvided = .predefined(.lastMonth)

    XCTAssertFalse(try dateRange.dateIsWithinRange(date, range: testRange))
  }

  func testTodayRange() throws {
    let dateRange = DateRange()
    let (start, end) = try dateRange.createDateRange(for: .today, now: fixedDate)

    XCTAssertEqual(start.formatted(), "1/1/2021, 12:00 AM")
    XCTAssertEqual(end.formatted(), "1/1/2021, 11:59 PM")
  }

}
