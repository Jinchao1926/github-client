# json_model

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

Generates a `json_serializable` model in `lib/models`.

## Variables

- `class_name`: Dart class name such as `GithubUser`
- `file_name`: Snake case file name such as `github_user`

## Output

Creates `lib/models/{{file_name}}.dart` with:

- `part '{{file_name}}.g.dart';`
- `@JsonSerializable(fieldRename: FieldRename.snake)`
- `fromJson`
- `toJson`
