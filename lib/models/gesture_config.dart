class GestureConfig {
  int fingerCount;
  int tapCount;

  GestureConfig({required this.fingerCount, required this.tapCount});

  Map<String, dynamic> toJson() => {
    'fingerCount': fingerCount,
    'tapCount': tapCount,
  };

  factory GestureConfig.fromJson(Map<String, dynamic> json) => GestureConfig(
    fingerCount: json['fingerCount'] ?? 2,
    tapCount: json['tapCount'] ?? 2,
  );
}
