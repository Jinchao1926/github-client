import 'package:json_annotation/json_annotation.dart';

part '{{file_name}}.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class {{class_name}} {
  const {{class_name}}({
    required this.id,
  });

  final String id;

  factory {{class_name}}.fromJson(Map<String, dynamic> json) =>
      _${{class_name}}FromJson(json);

  Map<String, dynamic> toJson() => _${{class_name}}ToJson(this);
}
