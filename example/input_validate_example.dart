import 'package:input_validate/input_validate.dart';

/// Comprehensive examples demonstrating the Input Validate package capabilities.
///
/// This package provides Laravel-style validation for nested map data structures
/// with support for wildcard paths, parallel validation, and comprehensive
/// error reporting.
void main() async {
  print('🎯 Input Validate Package Examples\n');

  // Basic validation example
  await basicValidationExample();

  // Nested object validation
  await nestedObjectValidationExample();

  // Array validation with wildcards
  await arrayValidationExample();

  // Nested wildcard validation
  await nestedWildcardExample();

  // Mixed validation patterns
  await mixedValidationExample();

  // Performance optimization examples
  await performanceOptimizationExample();

  // Error handling examples
  await errorHandlingExample();

  // Custom rule creation example
  await customRuleExample();

  print('\n✅ All examples completed successfully!');
}

/// Example 1: Basic field validation
Future<void> basicValidationExample() async {
  print('📝 Example 1: Basic Field Validation');

  final rules = {
    'name': [RequiredRule(), StringRule()],
    'age': [RequiredRule(), NumberRule(), MinRule(0), MaxRule(120)],
    'email': [RequiredRule(), EmailRule()],
    'isActive': [RequiredRule(), BooleanRule()],
  };

  final input = {
    'name': 'John Doe',
    'age': 30,
    'email': 'john.doe@example.com',
    'isActive': true,
    'extraField': 'This will be stripped', // Unvalidated fields are removed
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated data: $validated');
    print('   Notice: extraField was stripped from output\n');
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Example 2: Nested object validation
Future<void> nestedObjectValidationExample() async {
  print('📝 Example 2: Nested Object Validation');

  final rules = {
    'user.name': [RequiredRule(), StringRule()],
    'user.email': [RequiredRule(), EmailRule()],
    'user.profile.bio': [NullableRule(StringRule())],
    'user.profile.age': [RequiredRule(), NumberRule(), MinRule(18)],
    'settings.theme': [
      RequiredRule(),
      InRule({'light', 'dark'})
    ],
    'settings.notifications': [RequiredRule(), BooleanRule()],
  };

  final input = {
    'user': {
      'name': 'Alice Smith',
      'email': 'alice@example.com',
      'profile': {
        'bio': 'Software developer passionate about Dart',
        'age': 28,
        'secretField': 'will be removed',
      },
      'password': 'hidden', // Not validated, will be stripped
    },
    'settings': {
      'theme': 'dark',
      'notifications': true,
    },
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated nested data:');
    _printNestedMap(validated, indent: '   ');
    print("");
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Example 3: Array validation with wildcards
Future<void> arrayValidationExample() async {
  print('📝 Example 3: Array Validation with Wildcards');

  final rules = {
    'users.*.name': [RequiredRule(), StringRule()],
    'users.*.email': [RequiredRule(), EmailRule()],
    'users.*.age': [RequiredRule(), NumberRule(), MinRule(0)],
    'users.*.roles': [RequiredRule(), ListRule()],
  };

  final input = {
    'users': [
      {
        'name': 'Bob Wilson',
        'email': 'bob@example.com',
        'age': 32,
        'roles': ['admin', 'user'],
        'password': 'secret', // Will be stripped
      },
      {
        'name': 'Carol Davis',
        'email': 'carol@example.com',
        'age': 27,
        'roles': ['user'],
        'internalId': 12345, // Will be stripped
      },
    ],
    'metadata': 'ignored', // Not validated, will be stripped
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated array data:');
    _printNestedMap(validated, indent: '   ');
    print("");
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Example 4: Nested wildcard validation
Future<void> nestedWildcardExample() async {
  print('📝 Example 4: Nested Wildcard Validation');

  final rules = {
    'departments.*.name': [RequiredRule(), StringRule()],
    'departments.*.employees.*.name': [RequiredRule(), StringRule()],
    'departments.*.employees.*.position': [RequiredRule(), StringRule()],
    'departments.*.employees.*.salary': [RequiredRule(), NumberRule(), MinRule(0)],
  };

  final input = {
    'departments': [
      {
        'name': 'Engineering',
        'employees': [
          {
            'name': 'David Chen',
            'position': 'Senior Developer',
            'salary': 95000,
            'startDate': '2020-01-15', // Will be stripped
          },
          {
            'name': 'Emma Johnson',
            'position': 'Tech Lead',
            'salary': 110000,
          },
        ],
        'budget': 500000, // Will be stripped
      },
      {
        'name': 'Marketing',
        'employees': [
          {
            'name': 'Frank Miller',
            'position': 'Marketing Manager',
            'salary': 75000,
          },
        ],
      },
    ],
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated nested wildcard data:');
    _printNestedMap(validated, indent: '   ');
    print("");
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Example 5: Mixed validation patterns
Future<void> mixedValidationExample() async {
  print('📝 Example 5: Mixed Validation Patterns');

  final rules = {
    'title': [RequiredRule(), StringRule(), MinRule(5)],
    'author.name': [RequiredRule(), StringRule()],
    'author.email': [RequiredRule(), EmailRule()],
    'tags.*.name': [RequiredRule(), StringRule()],
    'tags.*.color': [
      NullableRule(InRule({'red', 'blue', 'green', 'yellow'}))
    ],
    'metadata.version': [RequiredRule(), NumberRule()],
    'metadata.published': [RequiredRule(), BooleanRule()],
  };

  final input = {
    'title': 'Dart Programming Guide',
    'author': {
      'name': 'Grace Hopper',
      'email': 'grace@example.com',
      'bio': 'Programming pioneer', // Will be stripped
    },
    'tags': [
      {'name': 'programming', 'color': 'blue'},
      {'name': 'dart', 'color': null},
      {'name': 'tutorial', 'color': 'green'},
    ],
    'metadata': {
      'version': 2,
      'published': true,
      'createdAt': '2023-01-01', // Will be stripped
    },
    'draft': false, // Will be stripped
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated mixed pattern data:');
    _printNestedMap(validated, indent: '   ');
    print("");
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Example 6: Performance optimization features
Future<void> performanceOptimizationExample() async {
  print('📝 Example 6: Performance Optimization Features');

  final rules = {
    'field1': [RequiredRule(), StringRule()],
    'field2': [RequiredRule(), NumberRule()],
    'field3': [RequiredRule(), BooleanRule()],
    'field4': [RequiredRule(), EmailRule()],
  };

  final input = {
    'field1': 'test',
    'field2': 42,
    'field3': true,
    'field4': 'test@example.com',
  };

  // Parallel validation (default, faster for multiple independent fields)
  print('⚡ Using parallel validation (default):');
  final stopwatch1 = Stopwatch()..start();
  final result1 = await InputValidate.validate(input, rules, enableParallelValidation: true);
  stopwatch1.stop();
  print('   Result: $result1');
  print('   Time: ${stopwatch1.elapsedMicroseconds}μs');

  // Sequential validation (with early termination for required failures)
  print('⏳ Using sequential validation:');
  final stopwatch2 = Stopwatch()..start();
  final result2 = await InputValidate.validate(input, rules, enableParallelValidation: false);
  stopwatch2.stop();
  print('   Result: $result2');
  print('   Time: ${stopwatch2.elapsedMicroseconds}μs');
  print("");
}

/// Example 7: Error handling and reporting
Future<void> errorHandlingExample() async {
  print('📝 Example 7: Error Handling and Reporting');

  final rules = {
    'name': [RequiredRule(), StringRule(), MinRule(2)],
    'email': [RequiredRule(), EmailRule()],
    'age': [RequiredRule(), NumberRule(), MinRule(18), MaxRule(65)],
    'users.*.name': [RequiredRule(), StringRule()],
    'users.*.email': [RequiredRule(), EmailRule()],
  };

  final invalidInput = {
    'name': '', // Fails RequiredRule
    'email': 'invalid-email-format', // Fails EmailRule
    'age': 15, // Fails MinRule
    'users': [
      {'name': 'Valid User', 'email': 'valid@example.com'},
      {'name': '', 'email': 'invalid'}, // Multiple failures in array
    ],
  };

  try {
    await InputValidate.validate(invalidInput, rules);
  } catch (e) {
    if (e is MultipleValidationException) {
      print('❌ Validation failed with ${e.failureCount} errors:');
      for (final entry in e.inputErrors!.entries) {
        print('   ${entry.key}: ${entry.value.join(', ')}');
      }
      print("");
    }
  }
}

/// Example 8: Creating custom validation rules
Future<void> customRuleExample() async {
  print('📝 Example 8: Custom Validation Rules');

  final rules = {
    'username': [RequiredRule(), StringRule(), CustomAlphanumericRule()],
    'password': [RequiredRule(), StringRule(), CustomPasswordStrengthRule()],
    'confirmPassword': [RequiredRule(), StringRule()],
  };

  final input = {
    'username': 'user123',
    'password': 'SecurePass123!',
    'confirmPassword': 'SecurePass123!',
  };

  try {
    final validated = await InputValidate.validate(input, rules);
    print('✅ Validated data with custom rules: $validated');
    print("");
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }
}

/// Helper function to print nested maps with indentation
void _printNestedMap(Map<String, dynamic> map, {String indent = ''}) {
  for (final entry in map.entries) {
    if (entry.value is Map<String, dynamic>) {
      print('$indent${entry.key}:');
      _printNestedMap(entry.value as Map<String, dynamic>, indent: '$indent  ');
    } else if (entry.value is List) {
      print('$indent${entry.key}: [');
      for (int i = 0; i < (entry.value as List).length; i++) {
        final item = (entry.value as List)[i];
        if (item is Map<String, dynamic>) {
          print('$indent  [$i]:');
          _printNestedMap(item, indent: '$indent    ');
        } else {
          print('$indent  [$i]: $item');
        }
      }
      print('$indent]');
    } else {
      print('$indent${entry.key}: ${entry.value}');
    }
  }
}

/// Custom rule: Only alphanumeric characters
class CustomAlphanumericRule implements ValidationRule {
  const CustomAlphanumericRule();

  @override
  String get message => 'The field must contain only alphanumeric characters.';

  @override
  bool passes(dynamic value) {
    if (value is! String) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }
}

/// Custom rule: Password strength validation
class CustomPasswordStrengthRule implements ValidationRule {
  const CustomPasswordStrengthRule();

  @override
  String get message =>
      'Password must be at least 8 characters with uppercase, lowercase, number, and special character.';

  @override
  bool passes(dynamic value) {
    if (value is! String) return false;
    if (value.length < 8) return false;

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    return hasUppercase && hasLowercase && hasNumber && hasSpecial;
  }
}
