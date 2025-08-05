import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('MinRule', () {
    test('should validate numeric values correctly', () async {
      const rule = MinRule(5);

      expect(await rule.passes(5), isTrue);
      expect(await rule.passes(10), isTrue);
      expect(await rule.passes(4), isFalse);
      expect(await rule.passes(0), isFalse);
    });

    test('should validate string length correctly', () async {
      const rule = MinRule(3);

      expect(await rule.passes('abc'), isTrue);
      expect(await rule.passes('hello'), isTrue);
      expect(await rule.passes('ab'), isFalse);
      expect(await rule.passes(''), isFalse);
    });

    test('should validate list length correctly', () async {
      const rule = MinRule(2);

      expect(await rule.passes([1, 2]), isTrue);
      expect(await rule.passes([1, 2, 3]), isTrue);
      expect(await rule.passes([1]), isFalse);
      expect(await rule.passes([]), isFalse);
    });

    test('should pass for null values (null handling delegated to RequiredRule)', () async {
      const rule = MinRule(1);
      expect(await rule.passes(null), isTrue);
    });

    test('should fail for unsupported types', () async {
      const rule = MinRule(1);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(true), isFalse);
    });

    test('should have correct message', () {
      const rule = MinRule(5);
      expect(rule.message, equals('This field must be at least 5'));
    });
  });

  group('MaxRule', () {
    test('should validate numeric values correctly', () async {
      const rule = MaxRule(10);

      expect(await rule.passes(10), isTrue);
      expect(await rule.passes(5), isTrue);
      expect(await rule.passes(11), isFalse);
      expect(await rule.passes(20), isFalse);
    });

    test('should validate string length correctly', () async {
      const rule = MaxRule(5);

      expect(await rule.passes('hello'), isTrue);
      expect(await rule.passes('hi'), isTrue);
      expect(await rule.passes('hello world'), isFalse);
    });

    test('should validate list length correctly', () async {
      const rule = MaxRule(3);

      expect(await rule.passes([1, 2, 3]), isTrue);
      expect(await rule.passes([1, 2]), isTrue);
      expect(await rule.passes([1, 2, 3, 4]), isFalse);
    });

    test('should pass for null values (null handling delegated to RequiredRule)', () async {
      const rule = MaxRule(10);
      expect(await rule.passes(null), isTrue);
    });

    test('should fail for unsupported types', () async {
      const rule = MaxRule(10);
      expect(await rule.passes({}), isFalse);
      expect(await rule.passes(true), isFalse);
    });

    test('should have correct message', () {
      const rule = MaxRule(10);
      expect(rule.message, equals('This field must be at most 10'));
    });
  });

  group('InRule', () {
    test('should pass for values in allowed set', () async {
      const rule = InRule({'apple', 'banana', 'orange'});

      expect(await rule.passes('apple'), isTrue);
      expect(await rule.passes('banana'), isTrue);
      expect(await rule.passes('orange'), isTrue);
    });

    test('should pass for null values (null handling delegated to RequiredRule)', () async {
      const rule = InRule({'apple', 'banana', 'orange'});

      expect(await rule.passes('grape'), isFalse);
      expect(await rule.passes(''), isFalse);
      expect(await rule.passes(null), isTrue);
    });

    test('should work with numeric values', () async {
      const rule = InRule({1, 2, 3});

      expect(await rule.passes(1), isTrue);
      expect(await rule.passes(2), isTrue);
      expect(await rule.passes(4), isFalse);
    });

    test('should work with mixed types', () async {
      const rule = InRule({'hello', 42, true});

      expect(await rule.passes('hello'), isTrue);
      expect(await rule.passes(42), isTrue);
      expect(await rule.passes(true), isTrue);
      expect(await rule.passes('world'), isFalse);
      expect(await rule.passes(41), isFalse);
      expect(await rule.passes(false), isFalse);
    });

    test('should have correct message', () {
      const rule = InRule({'red', 'green', 'blue'});
      expect(rule.message, equals('This field must be one of: red, green, blue'));
    });
  });
}
