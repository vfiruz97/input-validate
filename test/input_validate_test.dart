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
          'name': [RequiredRule(), IsStringRule()],
          'age': [RequiredRule(), IsNumberRule()],
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

      test('should throw MultipleValidationException for validation failures',
          () async {
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
          expect(exception.inputErrors!.keys,
              containsAll(['name', 'email', 'age']));
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
          expect(exception.inputErrors!['password']!.first,
              contains('at least 8'));
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
          expect(exception.inputErrors!['missing.field']!.first,
              contains('required'));
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

      test('should validate array fields with wildcard paths', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'users.*.name': [RequiredRule(), StringRule()],
        };

        final input = {
          'name': 'John',
          'users': [
            {'name': 'Alice'},
            {'name': 'Bob'},
          ],
        };

        final result = await InputValidate.validate(input, rules);

        // Wildcard paths are now fully supported
        expect(
            result,
            equals({
              'name': 'John',
              'users': [
                {'name': 'Alice'},
                {'name': 'Bob'},
              ],
            }));
      });

      test('should validate array fields with wildcards', () async {
        final rules = {
          'users.*.name': [RequiredRule(), StringRule()],
          'users.*.email': [RequiredRule(), EmailRule()],
          'users.*.age': [RequiredRule(), NumberRule()],
        };

        final input = {
          'users': [
            {
              'name': 'Alice',
              'email': 'alice@example.com',
              'age': 25,
              'secret': 'hidden',
            },
            {
              'name': 'Bob',
              'email': 'bob@example.com',
              'age': 30,
              'password': 'secret',
            },
          ],
          'extra': 'data',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'users': [
                {
                  'name': 'Alice',
                  'email': 'alice@example.com',
                  'age': 25,
                },
                {
                  'name': 'Bob',
                  'email': 'bob@example.com',
                  'age': 30,
                },
              ],
            }));
      });

      test('should handle validation errors in array fields', () async {
        final rules = {
          'users.*.name': [RequiredRule(), StringRule()],
          'users.*.email': [RequiredRule(), EmailRule()],
        };

        final input = {
          'users': [
            {
              'name': 'Alice',
              'email': 'alice@example.com',
            },
            {
              'name': '',
              'email': 'invalid-email',
            },
          ],
        };

        try {
          await InputValidate.validate(input, rules);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          expect(exception.inputErrors!['users.1.name'], isNotNull);
          expect(exception.inputErrors!['users.1.email'], isNotNull);
          expect(exception.inputErrors!['users.1.name']!.first,
              contains('required'));
          expect(exception.inputErrors!['users.1.email']!.first,
              contains('valid email'));
        }
      });

      test('should handle empty arrays with wildcards', () async {
        final rules = {
          'users.*.name': [RequiredRule(), StringRule()],
        };

        final input = {
          'users': <dynamic>[],
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'users': [],
            }));
      });

      test('should handle missing arrays with wildcards', () async {
        final rules = {
          'users.*.name': [RequiredRule(), StringRule()],
        };

        final input = <String, dynamic>{};

        final result = await InputValidate.validate(input, rules);

        // No validation should occur for missing arrays
        expect(result, equals({}));
      });

      test('should handle nested wildcards', () async {
        final rules = {
          'groups.*.users.*.name': [RequiredRule(), StringRule()],
        };

        final input = {
          'groups': [
            {
              'users': [
                {'name': 'Alice'},
                {'name': 'Bob'},
              ],
            },
            {
              'users': [
                {'name': 'Charlie'},
              ],
            },
          ],
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'groups': [
                {
                  'users': [
                    {'name': 'Alice'},
                    {'name': 'Bob'},
                  ],
                },
                {
                  'users': [
                    {'name': 'Charlie'},
                  ],
                },
              ],
            }));
      });

      test('should handle mixed wildcard and non-wildcard paths', () async {
        final rules = {
          'title': [RequiredRule(), StringRule()],
          'users.*.name': [RequiredRule(), StringRule()],
          'users.*.profile.bio': [NullableRule(StringRule())],
          'metadata.version': [RequiredRule(), NumberRule()],
        };

        final input = {
          'title': 'User List',
          'users': [
            {
              'name': 'Alice',
              'profile': {'bio': 'Software developer'},
              'extra': 'data',
            },
            {
              'name': 'Bob',
              'profile': {'bio': null},
            },
          ],
          'metadata': {
            'version': 1,
            'created': '2023-01-01',
          },
          'extra': 'ignored',
        };

        final result = await InputValidate.validate(input, rules);

        expect(
            result,
            equals({
              'title': 'User List',
              'users': [
                {
                  'name': 'Alice',
                  'profile': {'bio': 'Software developer'},
                },
                {
                  'name': 'Bob',
                  'profile': {'bio': null},
                },
              ],
              'metadata': {
                'version': 1,
              },
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
          expect(exception.inputErrors!['test']!.first,
              contains('Validation error'));
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

      test('should work with parallel validation enabled (default)', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'age': [RequiredRule(), NumberRule()],
          'email': [RequiredRule(), EmailRule()],
        };

        final input = {
          'name': 'John',
          'age': 30,
          'email': 'john@example.com',
        };

        final result = await InputValidate.validate(input, rules,
            enableParallelValidation: true);

        expect(
            result,
            equals({
              'name': 'John',
              'age': 30,
              'email': 'john@example.com',
            }));
      });

      test('should work with parallel validation disabled', () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'age': [RequiredRule(), NumberRule()],
          'email': [RequiredRule(), EmailRule()],
        };

        final input = {
          'name': 'John',
          'age': 30,
          'email': 'john@example.com',
        };

        final result = await InputValidate.validate(input, rules,
            enableParallelValidation: false);

        expect(
            result,
            equals({
              'name': 'John',
              'age': 30,
              'email': 'john@example.com',
            }));
      });

      test('should handle early termination with sequential validation',
          () async {
        final rules = {
          'name': [RequiredRule(), StringRule()],
          'age': [RequiredRule(), NumberRule()],
          'email': [RequiredRule(), EmailRule()],
        };

        final input = {
          'name': '', // Will fail RequiredRule
          'age': 30,
          'email': 'john@example.com',
        };

        try {
          await InputValidate.validate(input, rules,
              enableParallelValidation: false);
          fail('Expected validation exception');
        } catch (e) {
          expect(e, isA<MultipleValidationException>());
          final exception = e as MultipleValidationException;

          // With early termination, only the first required field failure should be reported
          expect(exception.inputErrors!['name'], isNotNull);
          expect(exception.inputErrors!['name']!.first, contains('required'));
        }
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
