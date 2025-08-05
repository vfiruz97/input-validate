import 'dart:async';
import 'dart:developer' as dev;

import 'exceptions/validation_exception.dart';
import 'field_path.dart';
import 'rules/validation_rule.dart';

/// Main class for validating input data against a set of validation rules.
///
/// Provides static methods to validate nested map data structures using
/// dot notation field paths with wildcard support.
class InputValidate {
  // Private constructor to prevent instantiation
  InputValidate._();

  // Cache for parsed field paths to improve performance
  static final Map<String, List<FieldPath>> _pathCache = <String, List<FieldPath>>{};

  /// Gets parsed field path segments from cache or parses and caches them.
  static List<FieldPath> _getCachedFieldPath(String path) {
    return _pathCache.putIfAbsent(path, () => FieldPath.parse(path));
  }

  /// Checks if validation failures include a RequiredRule failure.
  static bool _hasRequiredRuleFailure(List<ValidationRule> rules, List<String> errors) {
    // Check if any rule is a RequiredRule and has the RequiredRule error message
    for (final rule in rules) {
      if (rule.runtimeType.toString() == 'RequiredRule') {
        for (final error in errors) {
          if (error.contains('required') || error == rule.message) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Validates input data against the provided rules.
  ///
  /// Returns a map containing only the validated fields, stripping any
  /// unvalidated data from the input.
  ///
  /// Throws [ValidationException] if any validation rule fails.
  ///
  /// If [enableParallelValidation] is true (default), field validations
  /// will run in parallel for better performance.
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
    Map<String, List<ValidationRule>> rules, {
    bool enableParallelValidation = true,
  }) async {
    dev.log('Starting validation with ${rules.length} rule sets');

    final errors = <String, List<String>>{};
    final validatedPaths = <String>{};

    // Expand wildcard rules to concrete paths
    final expandedRules = _expandWildcardPaths(rules, input);

    // Track array paths that should be included even if empty
    final arrayPaths = <String>{};
    for (final rulePath in rules.keys) {
      if (rulePath.contains('*')) {
        _collectArrayPaths(rulePath, input, '', arrayPaths);
      }
    }

    if (enableParallelValidation) {
      // Process all rule sets in parallel for better performance
      final validationFutures = expandedRules.entries.map((entry) async {
        final fieldPath = entry.key;
        final fieldRules = entry.value;

        dev.log('Validating field: $fieldPath');

        try {
          final fieldErrors = await _validateField(fieldPath, input, fieldRules);
          return (fieldPath, fieldErrors);
        } catch (e) {
          dev.log('Error validating field $fieldPath: $e');
          return (fieldPath, ['Validation error: $e']);
        }
      }).toList();

      // Wait for all validations to complete
      final validationResults = await Future.wait(validationFutures);

      // Collect successfully validated paths and aggregate errors
      for (final (fieldPath, fieldErrors) in validationResults) {
        if (fieldErrors == null) {
          validatedPaths.add(fieldPath);
        } else {
          errors[fieldPath] = fieldErrors;
        }
      }
    } else {
      // Sequential validation with early termination on RequiredRule failures
      for (final entry in expandedRules.entries) {
        final fieldPath = entry.key;
        final fieldRules = entry.value;

        dev.log('Validating field: $fieldPath');

        try {
          final fieldErrors = await _validateField(fieldPath, input, fieldRules);
          if (fieldErrors == null) {
            validatedPaths.add(fieldPath);
          } else {
            errors[fieldPath] = fieldErrors;
            // Early termination for critical validation failures
            if (_hasRequiredRuleFailure(fieldRules, fieldErrors)) {
              dev.log('Early termination due to RequiredRule failure on $fieldPath');
              break;
            }
          }
        } catch (e) {
          dev.log('Error validating field $fieldPath: $e');
          errors[fieldPath] = ['Validation error: $e'];
        }
      }
    }

    // Add array paths to validated paths
    validatedPaths.addAll(arrayPaths);

    // If there are validation errors, throw exception
    if (errors.isNotEmpty) {
      throw MultipleValidationException.fromErrors(errors);
    }

    // Extract and return only validated data
    return _extractValidatedData(input, validatedPaths);
  }

  /// Collects array paths that should be included in results.
  static void _collectArrayPaths(
    String rulePath,
    Map<String, dynamic> input,
    String currentPath,
    Set<String> arrayPaths,
  ) {
    final pathSegments = _getCachedFieldPath(rulePath);
    _findArrayPaths(pathSegments, input, '', arrayPaths);
  }

  /// Recursively finds array paths in the input data.
  static void _findArrayPaths(
    List<FieldPath> pathSegments,
    dynamic currentData,
    String currentPath,
    Set<String> arrayPaths,
  ) {
    if (pathSegments.isEmpty) return;

    final segment = pathSegments.first;
    final remainingSegments = pathSegments.sublist(1);

    if (segment.isWildcard) {
      // Add this array path
      final arrayPath = currentPath.isEmpty ? '' : currentPath.substring(1);
      if (arrayPath.isNotEmpty && currentData is List) {
        arrayPaths.add(arrayPath);
      }

      // Continue with array elements
      if (currentData is List) {
        for (int i = 0; i < currentData.length; i++) {
          final newPath = '$currentPath.$i';
          _findArrayPaths(remainingSegments, currentData[i], newPath, arrayPaths);
        }
      }
    } else {
      // Handle regular segment
      final newPath = '$currentPath.${segment.name}';

      dynamic nextData;
      if (currentData is Map<String, dynamic>) {
        nextData = currentData[segment.name];
      }

      _findArrayPaths(remainingSegments, nextData, newPath, arrayPaths);
    }
  }

  /// Validates a single field against its rules and returns any errors.
  static Future<List<String>?> _validateField(
    String fieldPath,
    Map<String, dynamic> input,
    List<ValidationRule> rules,
  ) async {
    final value = _getValueAtPath(input, fieldPath);
    final fieldErrors = <String>[];

    for (final rule in rules) {
      try {
        final passes = await rule.passes(value);
        if (!passes) {
          fieldErrors.add(rule.message);
          dev.log('Validation failed for $fieldPath: ${rule.message}');
        }
      } catch (e) {
        fieldErrors.add('Validation error: $e');
        dev.log('Exception during validation of $fieldPath: $e');
      }
    }

    return fieldErrors.isEmpty ? null : fieldErrors;
  }

  /// Extracts a value from the input map using dot notation path.
  static dynamic _getValueAtPath(Map<String, dynamic> input, String path) {
    final segments = path.split('.');
    dynamic current = input;

    for (final segment in segments) {
      if (current is Map<String, dynamic>) {
        current = current[segment];
      } else if (current is List) {
        final index = int.tryParse(segment);
        if (index != null && index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return null; // Index out of bounds or invalid
        }
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

    // Filter out array paths - they will be included when their elements are processed
    final fieldPaths = validatedPaths.where((path) => !_isArrayPath(path, input)).toSet();
    final arrayPaths = validatedPaths.where((path) => _isArrayPath(path, input)).toSet();

    // Process regular field paths
    for (final path in fieldPaths) {
      final value = _getValueAtPath(input, path);
      // Include the field even if it's null, as it was validated
      _setValueAtPath(result, path, value);
    }

    // Process array paths to ensure empty arrays are included
    for (final arrayPath in arrayPaths) {
      final arrayValue = _getValueAtPath(input, arrayPath);
      if (arrayValue is List && arrayValue.isEmpty) {
        _setValueAtPath(result, arrayPath, []);
      }
    }

    return result;
  }

  /// Checks if a path refers to an array in the input data.
  static bool _isArrayPath(String path, Map<String, dynamic> input) {
    final value = _getValueAtPath(input, path);
    return value is List;
  }

  /// Sets a value in the result map using dot notation path.
  static void _setValueAtPath(
    Map<String, dynamic> result,
    String path,
    dynamic value,
  ) {
    final segments = path.split('.');
    dynamic current = result;

    // Navigate to the parent of the target field
    for (int i = 0; i < segments.length - 1; i++) {
      final segment = segments[i];

      if (current is Map<String, dynamic>) {
        // Check if next segment is a numeric index (indicating we need an array)
        final nextSegment = i + 1 < segments.length ? segments[i + 1] : null;
        final needsArray = nextSegment != null && int.tryParse(nextSegment) != null;

        if (needsArray) {
          current[segment] ??= <dynamic>[];
        } else {
          current[segment] ??= <String, dynamic>{};
        }
        current = current[segment];
      } else if (current is List) {
        final index = int.parse(segment);
        // Ensure list is large enough
        while (current.length <= index) {
          current.add(<String, dynamic>{});
        }
        current = current[index];
      }
    }

    // Set the final value
    final lastSegment = segments.last;
    if (current is Map<String, dynamic>) {
      current[lastSegment] = value;
    } else if (current is List) {
      final index = int.parse(lastSegment);
      while (current.length <= index) {
        current.add(null);
      }
      current[index] = value;
    }
  }

  /// Expands wildcard paths to concrete paths based on input data.
  static Map<String, List<ValidationRule>> _expandWildcardPaths(
    Map<String, List<ValidationRule>> rules,
    Map<String, dynamic> input,
  ) {
    final expandedRules = <String, List<ValidationRule>>{};

    for (final entry in rules.entries) {
      final rulePath = entry.key;
      final rulesList = entry.value;

      // If no wildcards, add as-is
      if (!rulePath.contains('*')) {
        expandedRules[rulePath] = rulesList;
        continue;
      }

      // Parse the path to identify wildcard positions
      final pathSegments = _getCachedFieldPath(rulePath);
      final expandedPaths = _generateConcretePaths(pathSegments, input, '');

      // Add all expanded paths with the same rules
      for (final concretePath in expandedPaths) {
        expandedRules[concretePath] = rulesList;
      }
    }

    return expandedRules;
  }

  /// Recursively generates concrete paths from wildcard patterns.
  static List<String> _generateConcretePaths(
    List<FieldPath> pathSegments,
    dynamic currentData,
    String currentPath,
  ) {
    if (pathSegments.isEmpty) {
      return [currentPath.isEmpty ? '' : currentPath.substring(1)]; // Remove leading dot
    }

    final segment = pathSegments.first;
    final remainingSegments = pathSegments.sublist(1);
    final paths = <String>[];

    if (segment.isWildcard) {
      // Handle wildcard expansion
      if (currentData is List) {
        for (int i = 0; i < currentData.length; i++) {
          final newPath = '$currentPath.$i';
          final nestedPaths = _generateConcretePaths(
            remainingSegments,
            currentData[i],
            newPath,
          );
          paths.addAll(nestedPaths);
        }
      } else {
        // If current data is not a list, wildcard doesn't apply
        // This handles cases where the array doesn't exist
        dev.log('Wildcard applied to non-list data at path: $currentPath');
      }
    } else {
      // Handle regular segment
      final newPath = '$currentPath.${segment.name}';

      dynamic nextData;
      if (currentData is Map<String, dynamic>) {
        nextData = currentData[segment.name];
      }

      final nestedPaths = _generateConcretePaths(
        remainingSegments,
        nextData,
        newPath,
      );
      paths.addAll(nestedPaths);
    }

    return paths;
  }
}
