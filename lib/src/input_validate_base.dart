import 'dart:async';
import 'dart:developer' as dev;

import 'exceptions/validation_exception.dart';
import 'rules/validation_rule.dart';

/// Main class for validating input data against a set of validation rules.
///
/// Provides static methods to validate nested map data structures using
/// dot notation field paths with wildcard support.
class InputValidate {
  // Private constructor to prevent instantiation
  InputValidate._();

  /// Validates input data against the provided rules.
  ///
  /// Returns a map containing only the validated fields, stripping any
  /// unvalidated data from the input.
  ///
  /// Throws [ValidationException] if any validation rule fails.
  ///
  /// Example:
  /// ```dart
  /// final rules = {
  ///   'name': [RequiredRule(), StringRule()],
  ///   'email': [RequiredRule(), EmailRule()],
  /// };
  ///
  /// final input = {'name': 'John', 'email': 'john@example.com', 'extra': 'data'};
  /// final validated = await InputValidate.validate(input, rules);
  /// // Returns: {'name': 'John', 'email': 'john@example.com'}
  /// ```
  static Future<Map<String, dynamic>> validate(
    Map<String, dynamic> input,
    Map<String, List<ValidationRule>> rules,
  ) async {
    dev.log('Starting validation with ${rules.length} rule sets');

    final errors = <String, List<String>>{};
    final validatedPaths = <String>{};

    // Process each rule set
    for (final entry in rules.entries) {
      final fieldPath = entry.key;
      final fieldRules = entry.value;

      dev.log('Validating field: $fieldPath');

      // For now, only handle simple paths (no wildcards)
      if (fieldPath.contains('*')) {
        dev.log('Skipping wildcard path: $fieldPath (will be implemented in Phase 3)');
        continue;
      }

      try {
        await _validateField(fieldPath, input, fieldRules, errors);
        validatedPaths.add(fieldPath);
      } catch (e) {
        dev.log('Error validating field $fieldPath: $e');
        // Error already added to errors map in _validateField
      }
    }

    // If there are validation errors, throw exception
    if (errors.isNotEmpty) {
      throw MultipleValidationException.fromErrors(errors);
    }

    // Extract and return only validated data
    return _extractValidatedData(input, validatedPaths);
  }

  /// Validates a single field against its rules.
  static Future<void> _validateField(
    String fieldPath,
    Map<String, dynamic> input,
    List<ValidationRule> rules,
    Map<String, List<String>> errors,
  ) async {
    final value = _getValueAtPath(input, fieldPath);

    for (final rule in rules) {
      try {
        final passes = await rule.passes(value);
        if (!passes) {
          errors.putIfAbsent(fieldPath, () => []).add(rule.message);
          dev.log('Validation failed for $fieldPath: ${rule.message}');
        }
      } catch (e) {
        errors.putIfAbsent(fieldPath, () => []).add('Validation error: $e');
        dev.log('Exception during validation of $fieldPath: $e');
      }
    }
  }

  /// Extracts a value from the input map using dot notation path.
  static dynamic _getValueAtPath(Map<String, dynamic> input, String path) {
    final segments = path.split('.');
    dynamic current = input;

    for (final segment in segments) {
      if (current is Map<String, dynamic>) {
        current = current[segment];
      } else {
        return null; // Path doesn't exist
      }
    }

    return current;
  }

  /// Extracts only validated data from the input, preserving nested structure.
  static Map<String, dynamic> _extractValidatedData(
    Map<String, dynamic> input,
    Set<String> validatedPaths,
  ) {
    final result = <String, dynamic>{};

    for (final path in validatedPaths) {
      final value = _getValueAtPath(input, path);
      // Include the field even if it's null, as it was validated
      _setValueAtPath(result, path, value);
    }

    return result;
  }

  /// Sets a value in the result map using dot notation path.
  static void _setValueAtPath(
    Map<String, dynamic> result,
    String path,
    dynamic value,
  ) {
    final segments = path.split('.');
    Map<String, dynamic> current = result;

    // Navigate to the parent of the target field
    for (int i = 0; i < segments.length - 1; i++) {
      final segment = segments[i];
      current[segment] ??= <String, dynamic>{};
      current = current[segment] as Map<String, dynamic>;
    }

    // Set the final value
    current[segments.last] = value;
  }
}
