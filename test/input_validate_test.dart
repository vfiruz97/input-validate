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
}
