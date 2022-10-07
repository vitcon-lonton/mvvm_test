import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_test/domain/value_objects/value_objects.dart';

void main() {
  group("Password", () {
    test("Should return valid password when password string valid", () async {
      // act
      const tPasswordStr = 'valid@gmail1';
      const length = tPasswordStr.length;
      final tPassword = Password(tPasswordStr);

      // assert
      expect(length, greaterThanOrEqualTo(Password.minLength));
      expect(length, lessThanOrEqualTo(Password.maxLength));
      expect(tPassword.isValid(), true);
      expect(tPassword.getOrCrash(), isInstanceOf<String>());
      expect(tPassword.failureOrUnit.isRight(), true);
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

    test(
        "Should throw [UnexpectedValueError], return ValueFailure, invalid when password string length less than password min length",
        () async {
      // act
      const tPasswordStr = '5char';
      final tPassword = Password(tPasswordStr);
      const length = tPasswordStr.length;
      final valid = tPassword.isValid();
      final crash = tPassword.getOrCrash;
      final failure = tPassword.failureOrUnit;

      // assert
      expect(length, lessThan(Password.minLength));
      expect(valid, false);
      expect(crash, throwsA(isInstanceOf<UnexpectedValueError>()));
      expect(
        failure,
        const Left(ValueFailure.notAchievedLength(
            failedValue: tPasswordStr, min: Password.minLength)),
      );
    });

    test(
        "Should throw [UnexpectedValueError], return ValueFailure, invalid when password string length large than password max length",
        () async {
      // act
      const tPasswordStr = 'this is have length large than password max length';
      final tPassword = Password(tPasswordStr);
      const length = tPasswordStr.length;
      final valid = tPassword.isValid();
      final crash = tPassword.getOrCrash;
      final failure = tPassword.failureOrUnit;

      // assert
      expect(length, greaterThan(Password.maxLength));
      expect(valid, false);
      expect(crash, throwsA(isInstanceOf<UnexpectedValueError>()));
      expect(
        failure,
        const Left(ValueFailure.exceedingLength(
            failedValue: tPasswordStr, max: Password.maxLength)),
      );
    });
  });
}
