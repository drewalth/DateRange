# DateRange

This is a simple date range library for Swift. It allows you to easily create, manipulate, and compare date ranges.

## Usage

### Creating a Date Range

```swift
// Assuming the current date and time is January 1, 2021, 12:00 PM.

let (start, end) = DateRange().createDateRange(for: .lastMonth)

print(start.formatted()) // 12/1/2020, 12:00 AM
print(end.formatted()) // 12/31/2020, 11:59 PM

```

### Checking if a Date is in a Date Range

```swift
let isWithinRange = try DateRange().dateIsWithinRange(someDateValue, range: .predefined(.lastNinetyDays))

// or with a custom range

let isWithinRange = try DateRange().dateIsWithinRange(someDateValue, range: .custom((
  start: someStartDate,
  end: someEndDate)))
```
