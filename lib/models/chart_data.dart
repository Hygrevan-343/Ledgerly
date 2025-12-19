class ChartData {
  final String label;
  final double value;
  final DateTime? date;
  final int? index;

  ChartData({
    required this.label,
    required this.value,
    this.date,
    this.index,
  });

  // Mock constructor for sample data
  ChartData.mock({
    required this.label,
    required this.value,
    this.date,
    this.index,
  });

  // Factory for creating line chart data points
  factory ChartData.forLineChart({
    required String month,
    required double amount,
    required int monthIndex,
  }) {
    return ChartData(
      label: month,
      value: amount,
      index: monthIndex,
      date: DateTime(2024, monthIndex + 1, 1),
    );
  }

  // Factory for creating spending trend data
  factory ChartData.spendingTrend({
    required DateTime date,
    required double amount,
  }) {
    return ChartData(
      label: _getMonthName(date.month),
      value: amount,
      date: date,
      index: date.month - 1,
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Get month abbreviation
  String get monthAbbr {
    if (date != null) {
      return _getMonthName(date!.month);
    }
    return label;
  }

  // Copy with method
  ChartData copyWith({
    String? label,
    double? value,
    DateTime? date,
    int? index,
  }) {
    return ChartData(
      label: label ?? this.label,
      value: value ?? this.value,
      date: date ?? this.date,
      index: index ?? this.index,
    );
  }
} 