enum DateRangeType {
  last7days,
  last30days,
  last6months,
  lastYear;

  String getTitle({
    String? last7daysTitle,
    String? last30daysTitle,
    String? last6monthsTitle,
    String? lastYearTitle,
  }) {
    switch (this) {
      case DateRangeType.last7days:
        return last7daysTitle ?? 'Last 7 days';
      case DateRangeType.last30days:
        return last30daysTitle ?? 'Last 30 days';
      case DateRangeType.last6months:
        return last6monthsTitle ?? 'Last 6 months';
      case DateRangeType.lastYear:
        return lastYearTitle ?? 'Last year';
    }
  }
}
