# Input Validate

A powerful Dart package for validating nested map data structures with Laravel-style validation rules and wildcard path support. Perfect for validating JSON data, form inputs, API payloads, and complex nested objects.

## Features

✨ **Laravel-style validation** - Familiar validation syntax inspired by Laravel's request validation  
🎯 **Wildcard path support** - Validate arrays and nested structures with `users.*.email` notation  
🚀 **Performance optimized** - Parallel validation and caching for high-performance applications  
🔄 **Async rule support** - Full support for asynchronous validation rules  
📊 **Comprehensive error reporting** - Detailed field-specific error messages with path information  
🎨 **Type-safe** - Built with Dart's strong type system for reliability  
💎 **Only validated data** - Returns only the fields that passed validation, stripping unvalidated data

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  input_validate: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### Basic Validation

```dart
import 'package:input_validate/input_validate.dart';

final rules = {
  'name': [RequiredRule(), IsStringRule()],
  'age': [RequiredRule(), IsNumberRule(), MinRule(18)],
  'email': [RequiredRule(), EmailRule()],
};

final input = {
  'name': 'John Doe',
  'age': 25,
  'email': 'john@example.com',
  'password': 'secret', // This will be stripped from output
};

try {
  final validated = await InputValidate.validate(input, rules);
  print(validated);
  // Output: {name: John Doe, age: 25, email: john@example.com}
  // Notice: password field is stripped because it wasn't validated
} catch (e) {
  if (e is MultipleValidationException) {
    print('Validation errors: ${e.inputErrors}');
  }
}
```

### Nested Object Validation

```dart
final rules = {
  'user.name': [RequiredRule(), IsStringRule()],
  'user.profile.age': [RequiredRule(), IsNumberRule(), MinRule(18)],
  'settings.theme': [RequiredRule(), InRule({'light', 'dark'})],
};

final input = {
  'user': {
    'name': 'Alice',
    'profile': {'age': 28},
  },
  'settings': {'theme': 'dark'},
};

final validated = await InputValidate.validate(input, rules);
// Returns only the validated nested structure
```

### Array Validation with Wildcards

```dart
final rules = {
  'users.*.name': [RequiredRule(), IsStringRule()],
  'users.*.email': [RequiredRule(), EmailRule()],
  'users.*.roles': [RequiredRule(), IsListRule()],
};

final input = {
  'users': [
    {
      'name': 'Bob',
      'email': 'bob@example.com',
      'roles': ['admin'],
      'password': 'secret', // Will be stripped
    },
    {
      'name': 'Carol',
      'email': 'carol@example.com',
      'roles': ['user'],
    },
  ],
};

final validated = await InputValidate.validate(input, rules);
// Returns users array with only validated fields
```

### Nested Wildcard Validation

```dart
final rules = {
  'departments.*.name': [RequiredRule(), IsStringRule()],
  'departments.*.employees.*.name': [RequiredRule(), IsStringRule()],
  'departments.*.employees.*.salary': [RequiredRule(), IsNumberRule()],
};

// Validates deeply nested arrays and objects
```

## Available Validation Rules

### Type Rules

- `RequiredRule()` - Field must be present and not null/empty
- `IsStringRule()` - Value must be a string
- `IsNumberRule()` - Value must be a number (int or double)
- `IsBooleanRule()` - Value must be a boolean
- `IsListRule()` - Value must be a list
- `IsMapRule()` - Value must be a map

### Constraint Rules

- `MinRule(value)` - Minimum value for numbers or minimum length for strings/lists
- `MaxRule(value)` - Maximum value for numbers or maximum length for strings/lists
- `InRule(allowedValues)` - Value must be in the allowed set

### Format Rules

- `EmailRule()` - Value must be a valid email address

### Special Rules

- `NullableRule(rule)` - Wraps another rule to allow null values

## Performance Optimization

### Parallel Validation (Default)

```dart
// Runs field validations in parallel for better performance
final result = await InputValidate.validate(
  input,
  rules,
  enableParallelValidation: true, // Default
);
```

### Sequential Validation with Early Termination

```dart
// Validates fields sequentially with early termination on RequiredRule failures
final result = await InputValidate.validate(
  input,
  rules,
  enableParallelValidation: false,
);
```

### Field Path Caching

The package automatically caches parsed field paths for improved performance on repeated validations.

## Error Handling

```dart
try {
  final validated = await InputValidate.validate(input, rules);
} catch (e) {
  if (e is MultipleValidationException) {
    print('Failed fields: ${e.failureCount}');

    // Access detailed error information
    for (final entry in e.inputErrors!.entries) {
      final fieldPath = entry.key;
      final errors = entry.value;
      print('$fieldPath: ${errors.join(', ')}');
    }
  }
}
```

### Example Error Output

```
name: This field is required
email: This field must be a valid email address
users.1.age: This field must be at least 18
users.2.email: This field must be a valid email address
```

## Creating Custom Rules

```dart
class CustomPasswordRule implements ValidationRule {
  @override
  String get message => 'Password must contain uppercase, lowercase, number, and special character.';

  @override
  bool passes(dynamic value) {
    if (value is! String || value.length < 8) return false;

    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value);
  }
}

// Usage
final rules = {
  'password': [RequiredRule(), CustomPasswordRule()],
};
```

## Advanced Examples

For comprehensive examples including nested wildcards, performance comparisons, and custom rules, see the [example file](example/input_validate_example.dart).

## Key Benefits

🎯 **Data Security** - Only validated fields are returned, preventing data leaks  
⚡ **Performance** - Parallel validation and intelligent caching  
🔍 **Debugging** - Detailed error messages with exact field paths  
🛡️ **Type Safety** - Leverages Dart's type system for reliability  
📈 **Scalability** - Efficient handling of large, complex data structures

## Wildcard Path Patterns

| Pattern                  | Description      | Example                       |
| ------------------------ | ---------------- | ----------------------------- |
| `field`                  | Simple field     | `name`, `email`               |
| `object.field`           | Nested field     | `user.name`, `settings.theme` |
| `array.*.field`          | Array elements   | `users.*.email`               |
| `object.array.*.field`   | Nested array     | `dept.users.*.name`           |
| `array.*.object.field`   | Array of objects | `users.*.profile.age`         |
| `array.*.nested.*.field` | Deeply nested    | `groups.*.users.*.email`      |

## Migration from Other Validators

### From Laravel Validation

```php
// Laravel PHP
$rules = [
    'name' => 'required|string',
    'users.*.email' => 'required|email',
];
```

```dart
// Input Validate Dart
final rules = {
  'name': [RequiredRule(), IsStringRule()],
  'users.*.email': [RequiredRule(), EmailRule()],
};
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
