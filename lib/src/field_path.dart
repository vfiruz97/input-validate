/// Represents a field path segment in dot notation validation.
///
/// Handles parsing of field paths like 'users.*.name' where '*' represents
/// a wildcard that can match any array index.
class FieldPath {
  /// The name of this path segment.
  final String name;

  /// Creates a new field path segment with the given [name].
  const FieldPath(this.name);

  /// Returns true if this path segment is a wildcard (*).
  bool get isWildcard => name == '*';

  /// Parses a dot-separated path string into a list of [FieldPath] segments.
  ///
  /// Example:
  /// ```dart
  /// final paths = FieldPath.parse('users.*.name');
  /// // Returns: [FieldPath('users'), FieldPath('*'), FieldPath('name')]
  /// ```
  static List<FieldPath> parse(String path) {
    if (path.isEmpty) {
      throw ArgumentError('Field path cannot be empty');
    }

    return path.split('.').where((segment) => segment.isNotEmpty).map((segment) => FieldPath(segment)).toList();
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FieldPath && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
