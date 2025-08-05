import 'dart:async';

import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('FieldPath', () {
    test('parses simple path correctly', () {
      final paths = FieldPath.parse('name');
      expect(paths, hasLength(1));
      expect(paths[0].name, equals('name'));
      expect(paths[0].isWildcard, isFalse);
    });

    test('parses nested path correctly', () {
      final paths = FieldPath.parse('user.email');
      expect(paths, hasLength(2));
      expect(paths[0].name, equals('user'));
      expect(paths[1].name, equals('email'));
    });

    test('handles wildcard paths', () {
      final paths = FieldPath.parse('users.*.name');
      expect(paths, hasLength(3));
      expect(paths[0].name, equals('users'));
      expect(paths[1].name, equals('*'));
      expect(paths[1].isWildcard, isTrue);
      expect(paths[2].name, equals('name'));
    });

    test('throws on empty path', () {
      expect(() => FieldPath.parse(''), throwsArgumentError);
    });
  });

  group('ValidationException', () {
    test('creates FieldValidationException correctly', () {
      final exception = FieldValidationException(
        'name',
        'RequiredRule',
        'The name field is required.',
      );

      expect(exception.fieldPath, equals('name'));
      expect(exception.ruleName, equals('RequiredRule'));
      expect(exception.message, equals('The name field is required.'));
    });

    test('creates MultipleValidationException from errors', () {
      final errors = {
        'name': ['The name field is required.'],
        'email': ['The email field must be a valid email address.'],
      };

      final exception = MultipleValidationException.fromErrors(errors);

      expect(exception.failureCount, equals(2));
      expect(exception.inputErrors, equals(errors));
      expect(exception.message, contains('2 fields'));
    });
  });

  group('InputValidate', () {
    group('validate', () {
      test('should validate simple fields successfully', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'age': [RequiredRule(), NumberRule()],
        };

        final input = {
          'name': 'John',
          'age': 30,
          'extra': 'data',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'name': 'John',
              'age': 30,
            }));
      });

      test('should validate nested fields successfully', () async {
        final rules = {
          'user.name': [RequiredRule(), StringRule()],
          'user.email': [RequiredRule(), EmailRule()],
        };

        final input = {
          'user': {
            'name': 'John',
            'email': 'john@example.com',
            'password': 'secret',
          },
          'extra': 'data',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'user': {
                'name': 'John',
                'email': 'john@example.com',
              },
            }));
      });

      test('should throw MultipleValidationException for validation failures', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'age': [RequiredRule(), NumberRule()],
        };

        final input = {
          'name': '',
          'age': 'not a number',
        };

        expect(
          () => InputValidate.validate(input, rules),
          throwsA(isA<MultipleValidationException>()),
        );
      });

      test('should collect all validation errors before throwing', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'email': [RequiredRule(), EmailRule()],
          'age': [RequiredRule(), NumberRule()],
        };

        final input = {
          'name': '',
          'email': 'invalid-email',
          'age': 'not a number',
        };

        try {
          await InputValidate.validate(input, rules);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          expect(exception.failureCount, equals(3));
          expect(exception.inputErrors, isNotNull);
          expect(exception.inputErrors!.keys, containsAll(['name', 'email', 'age']));
        }
      });

      test('should handle multiple rules per field', () async {
        final rules = {
          'password': [RequiredRule(), StringRule(), MinRule(8)],
        };

        final input = {
          'password': 'short',
        };

        try {
          await InputValidate.validate(input, rules);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          expect(exception.inputErrors!['password'], hasLength(1));
          expect(exception.inputErrors!['password']!.first, contains('at least 8'));
        }
      });

      test('should handle missing fields correctly', () async {
        final rules = {
          'name': [RequiredRule()],
          'missing.field': [RequiredRule()],
        };

        final input = {
          'name': 'John',
        };

        try {
          await InputValidate.validate(input, rules);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          expect(exception.inputErrors!['missing.field'], isNotNull);
          expect(exception.inputErrors!['missing.field']!.first, contains('required'));
        }
      });

      test('should handle nullable rules correctly', () async {
        final rules = {
          'optional': [NullableRule(StringRule())],
          'required': [RequiredRule(), StringRule()],
        };

        final input = {
          'optional': null,
          'required': 'value',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'optional': null,
              'required': 'value',
            }));
      });

      test('should skip wildcard paths for now', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'users.*.name': [RequiredRule(), StringRule()], // Should be skipped
        };

        final input = {
          'name': 'John',
          'users': [
            {'name': 'Alice'},
            {'name': 'Bob'},
          ],
        };

        final result = await InputValidate.validate(input, rules);

        // Only 'name' should be validated, wildcard path should be skipped
        expect(
            result,
            equals({
              'name': 'John',
            }));
      });

      test('should handle deep nested fields', () async {
        final rules = {
          'level1.level2.level3.value': [RequiredRule(), StringRule()],
        };

        final input = {
          'level1': {
            'level2': {
              'level3': {
                'value': 'deep value',
              },
            },
          },
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'level1': {
                'level2': {
                  'level3': {
                    'value': 'deep value',
                  },
                },
              },
            }));
      });

      test('should handle validation rule exceptions gracefully', () async {
        // Create a mock rule that throws an exception
        final throwingRule = _ThrowingRule();
        final rules = {
          'test': [throwingRule],
        };

        final input = {
          'test': 'value',
        };

        try {
          await InputValidate.validate(input, rules);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          expect(exception.inputErrors!['test'], isNotNull);
          expect(exception.inputErrors!['test']!.first, contains('Validation error'));
        }
      });

      test('should return empty map when no rules are provided', () async {
        final rules = <String, List<ValidationRule>>{};
        final input = {'name': 'John', 'age': 30};

        final result = await InputValidate.validate(input, rules);

        expect(result, equals({}));
      });

      test('should handle constraint rules correctly', () async {
        final rules = {
          'username': [RequiredRule(), StringRule(), MinRule(3), MaxRule(20)],
          'score': [RequiredRule(), NumberRule(), MinRule(0), MaxRule(100)],
          'category': [
            RequiredRule(),
            InRule({'A', 'B', 'C'})
          ],
        };

        final input = {
          'username': 'johndoe',
          'score': 85,
          'category': 'A',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'username': 'johndoe',
              'score': 85,
              'category': 'A',
            }));
      });
    });
  });
}

// Mock rule that throws an exception for testing
class _ThrowingRule implements ValidationRule {
  @override
  String get message => 'This rule throws';

  @override
  FutureOr<bool> passes(dynamic value) {
    throw Exception('Test exception');
  }
}
