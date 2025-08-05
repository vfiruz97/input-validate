import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('RequiredRule', () {
    const rule = RequiredRule();

    test('should fail for null values', () async {
      expect(await rule.passes(null), isFalse);
    });

    test('should fail for empty strings', () async {
      expect(await rule.passes(''), isFalse);
    });

    test('should fail for empty lists', () async {
      expect(await rule.passes([]), isFalse);
    });

    test('should fail for empty maps', () async {
      expect(await rule.passes({}), isFalse);
    });

    test('should pass for non-empty strings', () async {
      expect(await rule.passes('hello'), isTrue);
    });

    test('should pass for non-empty lists', () async {
      expect(await rule.passes([1, 2, 3]), isTrue);
    });

    test('should pass for non-empty maps', () async {
      expect(await rule.passes({'key': 'value'}), isTrue);
    });

    test('should pass for numbers', () async {
      expect(await rule.passes(42), isTrue);
      expect(await rule.passes(0), isTrue);
      expect(await rule.passes(-1), isTrue);
    });

    test('should pass for booleans', () async {
      expect(await rule.passes(true), isTrue);
      expect(await rule.passes(false), isTrue);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field is required'));
    });
  });

  group('NullableRule', () {
    const rule = NullableRule();

    test('should always pass validation', () async {
      expect(await rule.passes(null), isTrue);
      expect(await rule.passes('hello'), isTrue);
      expect(await rule.passes(123), isTrue);
      expect(await rule.passes(true), isTrue);
      expect(await rule.passes([]), isTrue);
      expect(await rule.passes({}), isTrue);
    });

    test('should have correct message', () {
      expect(rule.message, equals('Field can be null or valid'));
    });
  });
}
