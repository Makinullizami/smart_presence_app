// Weekly Trend Model
class StatsTrendModel {
  final int week;
  final double rate;

  StatsTrendModel({required this.week, required this.rate});

  factory StatsTrendModel.fromJson(Map<String, dynamic> json) {
    return StatsTrendModel(
      week: json['week'] ?? 0,
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}

// Class Comparison Model
class StatsComparisonModel {
  final String className;
  final String classCode;
  final double attendanceRate;

  StatsComparisonModel({
    required this.className,
    required this.classCode,
    required this.attendanceRate,
  });

  factory StatsComparisonModel.fromJson(Map<String, dynamic> json) {
    return StatsComparisonModel(
      className: json['class_name'] ?? '',
      classCode: json['class_code'] ?? '',
      attendanceRate: (json['attendance_rate'] ?? 0).toDouble(),
    );
  }
}

// Student Distribution Model
class StatsDistributionModel {
  final int high;
  final int medium;
  final int low;

  StatsDistributionModel({
    required this.high,
    required this.medium,
    required this.low,
  });

  factory StatsDistributionModel.fromJson(Map<String, dynamic> json) {
    return StatsDistributionModel(
      high: json['high'] ?? 0,
      medium: json['medium'] ?? 0,
      low: json['low'] ?? 0,
    );
  }
}

// Punctuality Model
class StatsPunctualityModel {
  final int onTime;
  final int late;

  StatsPunctualityModel({required this.onTime, required this.late});

  factory StatsPunctualityModel.fromJson(Map<String, dynamic> json) {
    return StatsPunctualityModel(
      onTime: json['on_time'] ?? 0,
      late: json['late'] ?? 0,
    );
  }
}
