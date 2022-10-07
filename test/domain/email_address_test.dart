import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_test/domain/value_objects/value_objects.dart';

void main() {
  group("EmailAddress", () {
    test("Should return valid email address when email address string valid",
        () async {
      // act
      const tEmailAddressStr = 'valid@gmail.com';
      final tEmailAddress = EmailAddress(tEmailAddressStr);

      // assert
      expect(tEmailAddress.isValid(), true);
      expect(tEmailAddress.getOrCrash(), isInstanceOf<String>());
      expect(tEmailAddress.failureOrUnit.isRight(), true);
    });

    test(
        "Should throw [UnexpectedValueError], return ValueFailure, invalid when email address string invalid",
        () async {
      // act
      const tEmailAddressStr = '|2/.sga!il.com';
      final tEmailAddress = EmailAddress(tEmailAddressStr);
      final valid = tEmailAddress.isValid();
      final crash = tEmailAddress.getOrCrash;
      final failure = tEmailAddress.failureOrUnit;

      // assert
      // expect(tEmailAddressStr, isEmpty);
      expect(valid, false);
      expect(crash, throwsA(isInstanceOf<UnexpectedValueError>()));
      expect(
        failure,
        const Left(ValueFailure.invalidEmail(failedValue: tEmailAddressStr)),
      );
    });

    test(
        "Should throw [UnexpectedValueError], return ValueFailure, invalid when email address string empty",
        () async {
      // act
      const tEmailAddressStr = '';
      final tEmailAddress = EmailAddress(tEmailAddressStr);
      final valid = tEmailAddress.isValid();
      final crash = tEmailAddress.getOrCrash;
      final failure = tEmailAddress.failureOrUnit;

      // assert
      expect(tEmailAddressStr, isEmpty);
      expect(valid, false);
      expect(crash, throwsA(isInstanceOf<UnexpectedValueError>()));
      expect(
        failure,
        const Left(ValueFailure.empty(failedValue: tEmailAddressStr)),
      );
    });

    test("Should return valid email address when email address string valid",
        () async {
      // act
      const tEmailAddressStr = 'valid@gmail.com';
      final EmailAddress tEmailAddress = EmailAddress(tEmailAddressStr);

      // assert
      expect(tEmailAddress.isValid(), true);
      expect(tEmailAddress.getOrCrash(), isInstanceOf<String>());
      expect(tEmailAddress.failureOrUnit.isRight(), true);
    });
  });
}
