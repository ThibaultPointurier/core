import 'package:mineral/api/common/snowflake.dart';

final class PartialApplication {
  final Snowflake id;
  final int flags;

  const PartialApplication({
    required this.id,
    required this.flags,
  });

  factory PartialApplication.fromJson(Map<String, dynamic> json) {
    return PartialApplication(
      id: Snowflake(json['id']),
      flags: json['flags'],
    );
  }
}
