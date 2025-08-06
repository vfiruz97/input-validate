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
🔍 **Debug logging** - Comprehensive logging for debugging validation process and performance analysis

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

// ✨ NEW: Concise syntax (recommended)
final rules = {
  'name':   [required(), string()],
  'age':    [required(), number(), min(18)],
  'email':  [required(), email()],
};

// 🔄 Or use verbose syntax (backward compatible)
final verboseRules = {
  'name':   [RequiredRule(), IsStringRule()],
  'age':    [RequiredRule(), IsNumberRule(), MinRule(18)],
  'email':  [RequiredRule(), EmailRule()],
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
// Concise syntax
final rules = {
  'user.name': [required(), string()],
  'user.profile.age': [required(), number(), min(18)],
  'settings.theme': [required(), inSet({'light', 'dark'})],
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
// Concise syntax for array validation
final rules = {
  'users.*.name': [required(), string()],
  'users.*.email': [required(), email()],
  'users.*.roles': [required(), list()],
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

## Validation Syntax Options

InputValidate offers two syntax styles for defining validation rules:

### 🌟 Concise Syntax (Recommended)

The new concise syntax provides cleaner, more readable validation rules:

```dart
final rules = {
  'name': [required(), string(), min(2), max(50)],
  'age': [required(), number(), min(18), max(120)],
  'email': [required(), string(), email()],
  'status': [required(), string(), inSet({'active', 'inactive'})],
  'tags': [required(), list(), min(1), max(5)],
  'profile.bio': [nullable(), string(), max(500)],
};
```

**Available shorthand functions:**

- **Type validation:** `required()`, `string()`, `number()`, `boolean()`, `list()`, `map()`, `email()`, `nullable()`
- **Constraints:** `min(value)`, `max(value)`, `inSet(values)`
- **Aliases:** `isString()`, `isNumber()`, `isBoolean()`, `isList()`, `isMap()`, `allowedValues(values)`

### 🔄 Verbose Syntax (Backward Compatible)

The original class-based syntax remains fully supported:

```dart
final rules = {
  'name': [RequiredRule(), IsStringRule(), MinRule(2), MaxRule(50)],
  'age': [RequiredRule(), IsNumberRule(), MinRule(18), MaxRule(120)],
  'email': [RequiredRule(), IsStringRule(), EmailRule()],
  'status': [RequiredRule(), IsStringRule(), InRule({'active', 'inactive'})],
  'tags': [RequiredRule(), IsListRule(), MinRule(1), MaxRule(5)],
  'profile.bio': [NullableRule(), IsStringRule(), MaxRule(500)],
};
```

**Mixing both syntaxes is supported:**

```dart
final rules = {
  'name': [required(), IsStringRule()], // Mixed syntax works fine
  'age': [RequiredRule(), number(), min(18)], // Any combination
};
```

## Available Validation Rules

### Type Rules

- `RequiredRule()` / `required()` - Field must be present and not null/empty
- `IsStringRule()` / `string()` - Value must be a string
- `IsNumberRule()` / `number()` - Value must be a number (int or double)
- `IsBooleanRule()` / `boolean()` - Value must be a boolean
- `IsListRule()` / `list()` - Value must be a list
- `IsMapRule()` / `map()` - Value must be a map

### Constraint Rules

- `MinRule(value)` / `min(value)` - Minimum value for numbers or minimum length for strings/lists
- `MaxRule(value)` / `max(value)` - Maximum value for numbers or maximum length for strings/lists
- `InRule(allowedValues)` / `inSet(allowedValues)` - Value must be in the allowed set

### Format Rules

- `EmailRule()` / `email()` - Value must be a valid email address

### Special Rules

- `NullableRule()` / `nullable()` - Allows null values and skips other validation rules when value is null

### Working with Nullable Fields

The `NullableRule` provides special behavior for handling optional fields. When a field value is `null` and `NullableRule` is present in the validation rules, all other validation rules for that field are skipped.

```dart
final rules = {
  // Required field - null not allowed
  'user.name': [RequiredRule(), IsStringRule()],

  // Optional field - can be null or valid string
  'user.email': [
    NullableRule(),     // Allow null values
    IsStringRule(),     // Only applied if value is not null
    EmailRule(),        // Only applied if value is not null
  ],

  // Optional field with constraints
  'user.bio': [
    NullableRule(),     // Allow null values
    IsStringRule(),     // Only applied if value is not null
    MinRule(10),        // Only applied if value is not null
    MaxRule(500),       // Only applied if value is not null
  ],
};

final input = {
  'user': {
    'name': 'John Doe',
    'email': null,      // ✅ Passes validation (NullableRule allows null)
    'bio': null,        // ✅ Passes validation (NullableRule allows null)
  }
};

final result = await InputValidate.validate(input, rules);
// Returns: {'user': {'name': 'John Doe', 'email': null, 'bio': null}}
```

**Important:** If both `RequiredRule` and `NullableRule` are present, `RequiredRule` takes precedence and null values will fail validation.

```dart
final rules = {
  'field': [RequiredRule(), NullableRule(), IsStringRule()], // ❌ RequiredRule prevents null
};
```

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

## Debug Logging

The package includes comprehensive debug logging to help you understand the validation process and troubleshoot issues. All logs use Dart's built-in `log()` function from `dart:developer`.

### Viewing Debug Logs

In development, you can view debug logs.

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
  FutureOr<bool> passes(dynamic value) {
    if (value is! String || value.length < 8) return false;

    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value);
  }
}

// Usage
final rules = {
  'password': [RequiredRule(), CustomPasswordRule()],
};
```

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

## 👤 Author

**Firuz Vorisov**  
[github.com/vfiruz97](https://github.com/vfiruz97)

Feel free to open issues or contribute via PR!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE).
