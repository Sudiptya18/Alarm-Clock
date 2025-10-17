
class Alarm {
  final String id;
  final String title;
  final TimeOfDay time;
  final List<int> repeatDays; // 0 = Sunday, 1 = Monday, etc.
  final bool isEnabled;
  final bool hasMathChallenge;
  final String? ringtonePath;
  final int? ringtoneStartTime; // Start time in seconds for custom ringtone
  final bool isVibrateEnabled;
  final int volume;

  Alarm({
    required this.id,
    required this.title,
    required this.time,
    this.repeatDays = const [],
    this.isEnabled = true,
    this.hasMathChallenge = false,
    this.ringtonePath,
    this.ringtoneStartTime,
    this.isVibrateEnabled = true,
    this.volume = 100,
  });

  Alarm copyWith({
    String? id,
    String? title,
    TimeOfDay? time,
    List<int>? repeatDays,
    bool? isEnabled,
    bool? hasMathChallenge,
    String? ringtonePath,
    int? ringtoneStartTime,
    bool? isVibrateEnabled,
    int? volume,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      hasMathChallenge: hasMathChallenge ?? this.hasMathChallenge,
      ringtonePath: ringtonePath ?? this.ringtonePath,
      ringtoneStartTime: ringtoneStartTime ?? this.ringtoneStartTime,
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hour': time.hour,
      'minute': time.minute,
      'repeatDays': repeatDays,
      'isEnabled': isEnabled,
      'hasMathChallenge': hasMathChallenge,
      'ringtonePath': ringtonePath,
      'ringtoneStartTime': ringtoneStartTime,
      'isVibrateEnabled': isVibrateEnabled,
      'volume': volume,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      title: json['title'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      isEnabled: json['isEnabled'] ?? true,
      hasMathChallenge: json['hasMathChallenge'] ?? false,
      ringtonePath: json['ringtonePath'],
      ringtoneStartTime: json['ringtoneStartTime'],
      isVibrateEnabled: json['isVibrateEnabled'] ?? true,
      volume: json['volume'] ?? 100,
    );
  }

  String get timeString {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get repeatDaysString {
    if (repeatDays.isEmpty) return 'Once';
    
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    if (repeatDays.length == 7) return 'Every day';
    
    return repeatDays.map((day) => dayNames[day]).join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Alarm && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeOfDay && other.hour == hour && other.minute == minute;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}
