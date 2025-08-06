/// Shorthand functions for validation rules to provide more concise syntax.
///
/// This file contains function-style shortcuts for all validation rules,
/// allowing developers to write cleaner, more readable validation code.
///
/// Example usage:
/// ```dart
/// // Instead of verbose syntax:
/// 'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(80)]
///
/// // Use concise syntax:
/// 'name': [required(), string(), min(2), max(80)]
/// ```
library;

import 'rules/constraint_rules.dart';
import 'rules/format_rules.dart';
import 'rules/special_rules.dart';
import 'rules/type_rules.dart';

// ============================================================================
// TYPE VALIDATION RULES (no parameters)
// ============================================================================

/// Creates a [RequiredRule] to ensure the field is not null or empty.
///
/// Example:
/// ```dart
/// 'name': [required(), string()]
/// ```
RequiredRule Function() required = RequiredRule.new;

/// Creates an [IsStringRule] to validate that the value is a string.
///
/// Example:
/// ```dart
/// 'name': [required(), string(), min(2)]
/// ```
IsStringRule Function() string = IsStringRule.new;

/// Creates an [IsNumberRule] to validate that the value is a number.
///
/// Example:
/// ```dart
/// 'age': [required(), number(), min(18)]
/// ```
IsNumberRule Function() number = IsNumberRule.new;

/// Creates an [IsBooleanRule] to validate that the value is a boolean.
///
/// Example:
/// ```dart
/// 'isActive': [required(), boolean()]
/// ```
IsBooleanRule Function() boolean = IsBooleanRule.new;

/// Creates an [IsListRule] to validate that the value is a list.
///
/// Example:
/// ```dart
/// 'tags': [required(), list(), min(1)]
/// ```
IsListRule Function() list = IsListRule.new;

/// Creates an [IsMapRule] to validate that the value is a map.
///
/// Example:
/// ```dart
/// 'settings': [required(), map()]
/// ```
IsMapRule Function() map = IsMapRule.new;

/// Creates an [EmailRule] to validate email format.
///
/// Example:
/// ```dart
/// 'email': [required(), string(), email()]
/// ```
EmailRule Function() email = EmailRule.new;

/// Creates a [NullableRule] to allow null values and skip other validations when null.
///
/// Example:
/// ```dart
/// 'optionalField': [nullable(), string(), min(2)]
/// ```
NullableRule Function() nullable = NullableRule.new;

// ============================================================================
// CONSTRAINT VALIDATION RULES (with parameters)
// ============================================================================

/// Creates a [MinRule] to validate minimum value or length.
///
/// - For numbers: validates minimum value
/// - For strings: validates minimum length
/// - For lists: validates minimum length
///
/// Example:
/// ```dart
/// 'age': [required(), number(), min(18)]
/// 'name': [required(), string(), min(2)]
/// 'tags': [required(), list(), min(1)]
/// ```
MinRule Function(num value) min = MinRule.new;

/// Creates a [MaxRule] to validate maximum value or length.
///
/// - For numbers: validates maximum value
/// - For strings: validates maximum length
/// - For lists: validates maximum length
///
/// Example:
/// ```dart
/// 'age': [required(), number(), max(120)]
/// 'name': [required(), string(), max(50)]
/// 'tags': [required(), list(), max(10)]
/// ```
MaxRule Function(num value) max = MaxRule.new;

/// Creates an [InRule] to validate that the value is in the allowed set.
///
/// Example:
/// ```dart
/// 'status': [required(), string(), inSet({'active', 'inactive', 'pending'})]
/// 'priority': [required(), number(), inSet({1, 2, 3, 4, 5})]
/// ```
InRule Function(Set<dynamic> values) inSet = InRule.new;

// ============================================================================
// BACKWARD COMPATIBILITY ALIASES
// ============================================================================

/// Alias for [inSet] - creates an [InRule] to validate allowed values.
///
/// Example:
/// ```dart
/// 'role': [required(), string(), allowedValues({'admin', 'user', 'guest'})]
/// ```
InRule Function(Set<dynamic> values) allowedValues = InRule.new;

/// Alias for [string] - creates an [IsStringRule].
///
/// Example:
/// ```dart
/// 'name': [required(), isString(), min(2)]
/// ```
IsStringRule Function() isString = IsStringRule.new;

/// Alias for [number] - creates an [IsNumberRule].
///
/// Example:
/// ```dart
/// 'age': [required(), isNumber(), min(0)]
/// ```
IsNumberRule Function() isNumber = IsNumberRule.new;

/// Alias for [boolean] - creates an [IsBooleanRule].
///
/// Example:
/// ```dart
/// 'isActive': [required(), isBoolean()]
/// ```
IsBooleanRule Function() isBoolean = IsBooleanRule.new;

/// Alias for [list] - creates an [IsListRule].
///
/// Example:
/// ```dart
/// 'items': [required(), isList(), min(1)]
/// ```
IsListRule Function() isList = IsListRule.new;

/// Alias for [map] - creates an [IsMapRule].
///
/// Example:
/// ```dart
/// 'config': [required(), isMap()]
/// ```
IsMapRule Function() isMap = IsMapRule.new;
