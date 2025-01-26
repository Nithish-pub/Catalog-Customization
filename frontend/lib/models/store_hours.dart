import 'package:json_annotation/json_annotation.dart';

part 'store_hours.g.dart';

@JsonSerializable()
class StoreHours {
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  StoreHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  factory StoreHours.fromJson(Map<String, dynamic> json) =>
      _$StoreHoursFromJson(json);
  Map<String, dynamic> toJson() => _$StoreHoursToJson(this);
}

@JsonSerializable()
class StoreOperatingHours {
  final List<StoreHours> regularHours;
  final List<SpecialHours> specialHours;

  StoreOperatingHours({
    required this.regularHours,
    this.specialHours = const [],
  });

  factory StoreOperatingHours.fromJson(Map<String, dynamic> json) =>
      _$StoreOperatingHoursFromJson(json);
  Map<String, dynamic> toJson() => _$StoreOperatingHoursToJson(this);
}

@JsonSerializable()
class SpecialHours {
  final DateTime date;
  final String openTime;
  final String closeTime;
  final bool isClosed;
  final String? reason;

  SpecialHours({
    required this.date,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
    this.reason,
  });

  factory SpecialHours.fromJson(Map<String, dynamic> json) =>
      _$SpecialHoursFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialHoursToJson(this);
} 