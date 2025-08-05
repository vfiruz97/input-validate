import 'package:input_validate/input_validate.dart';

Future<void> main() async {
  print('=== Debug Logging Example ===');
  print('This example demonstrates the debug logging capabilities of the input validation package.');
  print('Check the developer console or logs to see detailed validation process information.\n');

  // Example 1: Simple validation with logging
  print('1. Simple field validation:');
  try {
    final rules = {
      'name': [RequiredRule(), IsStringRule()],
      'age': [RequiredRule(), IsNumberRule(), MinRule(18)],
      'email': [RequiredRule(), EmailRule()],
    };

    final input = {
      'name': 'John Doe',
      'age': 25,
      'email': 'john.doe@example.com',
      'extraField': 'This will be filtered out'
    };

    final validated = await InputValidate.validate(input, rules);
    print('✅ Validation successful');
    print('Validated data: $validated\n');
  } catch (e) {
    print('❌ Validation failed: $e\n');
  }

  // Example 2: Array validation with wildcard logging
  print('2. Array validation with wildcards:');
  try {
    final rules = {
      'users.*.name': [RequiredRule(), IsStringRule()],
      'users.*.email': [RequiredRule(), EmailRule()],
      'users.*.profile.active': [RequiredRule(), IsBooleanRule()],
    };

    final input = {
      'users': [
        {
          'name': 'Alice',
          'email': 'alice@example.com',
          'profile': {'active': true}
        },
        {
          'name': 'Bob',
          'email': 'bob@example.com',
          'profile': {'active': false}
        }
      ]
    };

    final validated = await InputValidate.validate(input, rules);
    print('✅ Array validation successful');
    print('Validated data: $validated\n');
  } catch (e) {
    print('❌ Array validation failed: $e\n');
  }

  // Example 3: Validation failure with detailed error logging
  print('3. Validation failure example:');
  try {
    final rules = {
      'name': [RequiredRule(), IsStringRule()],
      'age': [RequiredRule(), IsNumberRule(), MinRule(21)],
      'email': [RequiredRule(), EmailRule()],
    };

    final input = {
      'name': 123, // Invalid: should be string
      'age': 18,   // Invalid: under minimum age
      'email': 'invalid-email', // Invalid: bad format
    };

    final validated = await InputValidate.validate(input, rules);
    print('✅ Validation successful: $validated');
  } catch (e) {
    print('❌ Expected validation failure: $e\n');
  }

  // Example 4: Sequential vs Parallel validation logging
  print('4. Sequential validation mode:');
  try {
    final rules = {
      'field1': [RequiredRule()],
      'field2': [RequiredRule()],
      'field3': [RequiredRule()],
    };

    final input = <String, dynamic>{}; // Empty input to trigger failures

    // This will fail with sequential validation and early termination
    await InputValidate.validate(
      input, 
      rules, 
      enableParallelValidation: false
    );
  } catch (e) {
    print('❌ Sequential validation failed as expected: ${e.toString().split('\n').first}\n');
  }

  print('=== Debug Logging Example Complete ===');
  print('Check your development console for detailed validation logs!');
}
