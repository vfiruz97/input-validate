import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('StringRule', () {
    const rule = StringRule();

    test('should pass for string values', () async {
      expect(await rule.passes('hello'), isTrue);
      expect(await rule.passes(''), isTrue);
      expect(await rule.passes('123'), isTrue);
    });

    test('should fail for non-string values', () async {
      expect(await rule.passes(123), isFalse);
      expect(await rule.passes(true), isFalse);
      expect(await rule.passes([]), isFalse);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(null), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a string'));
    });
  });

  group('NumberRule', () {
    const rule = NumberRule();

    test('should pass for int values', () async {
      expect(await rule.passes(42), isTrue);
      expect(await rule.passes(0), isTrue);
      expect(await rule.passes(-10), isTrue);
    });

    test('should pass for double values', () async {
      expect(await rule.passes(3.14), isTrue);
      expect(await rule.passes(0.0), isTrue);
      expect(await rule.passes(-2.5), isTrue);
    });

    test('should fail for non-number values', () async {
      expect(await rule.passes('123'), isFalse);
      expect(await rule.passes(true), isFalse);
      expect(await rule.passes([]), isFalse);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(null), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a number'));
    });
  });

  group('BooleanRule', () {
    const rule = BooleanRule();

    test('should pass for boolean values', () async {
      expect(await rule.passes(true), isTrue);
      expect(await rule.passes(false), isTrue);
    });

    test('should fail for non-boolean values', () async {
      expect(await rule.passes('true'), isFalse);
      expect(await rule.passes(1), isFalse);
      expect(await rule.passes(0), isFalse);
      expect(await rule.passes([]), isFalse);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(null), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a boolean'));
    });
  });

  group('ListRule', () {
    const rule = ListRule();

    test('should pass for list values', () async {
      expect(await rule.passes([]), isTrue);
      expect(await rule.passes([1, 2, 3]), isTrue);
      expect(await rule.passes(['a', 'b']), isTrue);
    });

    test('should fail for non-list values', () async {
      expect(await rule.passes('[]'), isFalse);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(123), isFalse);
      expect(await rule.passes(true), isFalse);
      expect(await rule.passes(null), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a list'));
    });
  });

  group('MapRule', () {
    const rule = MapRule();

    test('should pass for map values', () async {
      expect(await rule.passes({}), isTrue);
      expect(await rule.passes({'key': 'value'}), isTrue);
      expect(await rule.passes({1: 'one', 2: 'two'}), isTrue);
    });

    test('should fail for non-map values', () async {
      expect(await rule.passes('{}'), isFalse);
      expect(await rule.passes([]), isFalse);
      expect(await rule.passes(123), isFalse);
      expect(await rule.passes(true), isFalse);
      expect(await rule.passes(null), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a map'));
    });
  });
}
