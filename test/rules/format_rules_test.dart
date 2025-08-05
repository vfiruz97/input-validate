import 'package:input_validate/input_validate.dart';
import 'package:test/test.dart';

void main() {
  group('EmailRule', () {
    const rule = EmailRule();

    test('should pass for valid email addresses', () async {
      expect(await rule.passes('user@example.com'), isTrue);
      expect(await rule.passes('test.email@domain.org'), isTrue);
      expect(await rule.passes('user+tag@company.co.uk'), isTrue);
      expect(await rule.passes('first.last@subdomain.example.com'), isTrue);
      expect(await rule.passes('123@numbers.net'), isTrue);
    });

    test('should fail for invalid email addresses', () async {
      expect(await rule.passes('invalid-email'), isFalse);
      expect(await rule.passes('user@'), isFalse);
      expect(await rule.passes('@domain.com'), isFalse);
      expect(await rule.passes('user@domain'), isFalse);
      expect(await rule.passes('user.domain.com'), isFalse);
      expect(await rule.passes('user@domain.'), isFalse);
      expect(await rule.passes(''), isFalse);
    });

    test('should pass for null values (null handling delegated to RequiredRule)', () async {
      expect(await rule.passes(null), isTrue);
    });

    test('should fail for non-string values', () async {
      expect(await rule.passes(123), isFalse);
      expect(await rule.passes(true), isFalse);
      expect(await rule.passes([]), isFalse);
      expect(await rule.passes({}), isFalse);
    });

    test('should have correct message', () {
      expect(rule.message, equals('This field must be a valid email address'));
    });
  });
}
