/// A Dart package for validating nested map data structures.
///
/// Provides a comprehensive validation system inspired by Laravel's request
/// validation, supporting deeply nested maps with wildcard path notation.
library;

// Exception types
export 'src/exceptions/validation_exception.dart';
export 'src/field_path.dart';
// Core validation components
export 'src/input_validate_base.dart';
export 'src/rules/constraint_rules.dart';
export 'src/rules/format_rules.dart';
export 'src/rules/special_rules.dart';
export 'src/rules/type_rules.dart';
// Validation rules
export 'src/rules/validation_rule.dart';
