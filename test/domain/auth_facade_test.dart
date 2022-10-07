import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_test/credential.dart';
import 'package:mvvm_test/domain/domain.dart';

void main() {
  late Password tPassword;
  late Password tInvalidPassword;
  late Password tMyPassword;

  late EmailAddress tEmailAddress;
  late EmailAddress tInvalidEmailAddress;
  late EmailAddress tMyEmailAddress;

  late AuthFacade authFacade;

  setUpAll(() {
    // registerFallbackValue<TodoDto>(odoDto());
  });

  setUp(() {
    tEmailAddress = EmailAddress('radom@gmail.com');
    tInvalidEmailAddress = EmailAddress('123123123123.2.2.');
    tMyEmailAddress = myEmailAddress;

    tPassword = Password('1234567');
    tInvalidPassword = Password('');
    tMyPassword = myPassword;

    authFacade = AuthFacade(
      myEmailAddress: tMyEmailAddress,
      myPassword: tMyPassword,
    );
  });

  group("SignInWithEmailAndPassword", () {
    test("Should return unit when call with correct email and right password",
        () async {
      // arrange
      // act
      Either<AuthFailure, Unit> result;
      result = await authFacade.signInWithEmailAndPassword(
          emailAddress: tMyEmailAddress, password: tMyPassword);

      // assert
      expect(result.isRight(), true);
      expect(result.toOption().toNullable(), isNotNull);
      expect(result, const Right(unit));
      expect(result, isA<Right<AuthFailure, Unit>>());
    });

    test("Should return [AuthFailure] when call with incorrect email",
        () async {
      EmailAddress incorrectEmailAddress = tEmailAddress;

      // act
      Either<AuthFailure, Unit> result;
      result = await authFacade.signInWithEmailAndPassword(
          emailAddress: incorrectEmailAddress, password: tMyPassword);

      // assert
      expect(result.isLeft(), true);
      expect(result, isA<Left<AuthFailure, Unit>>());
      expect(result.swap().toOption().toNullable(), isNotNull);
      expect(
        result,
        const Left(AuthFailure.invalidEmailAndPasswordCombination()),
      );
    });

    test("Should return [AuthFailure] when call with incorrect password",
        () async {
      Password incorrectPassword = tPassword;

      // act
      Either<AuthFailure, Unit> result;
      result = await authFacade.signInWithEmailAndPassword(
          emailAddress: tMyEmailAddress, password: incorrectPassword);

      // assert
      expect(result.isLeft(), true);
      expect(result, isA<Left<AuthFailure, Unit>>());
      expect(result.swap().toOption().toNullable(), isNotNull);
      expect(
        result,
        const Left(AuthFailure.invalidEmailAndPasswordCombination()),
      );
    });

    test("Should throw [UnexpectedValueError] when call with invalid email",
        () async {
      // act
      final call = authFacade.signInWithEmailAndPassword;

      // assert
      expect(
        () => call(emailAddress: tInvalidEmailAddress, password: tPassword),
        throwsA(isInstanceOf<UnexpectedValueError>()),
      );
    });

    test("Should throw [UnexpectedValueError] when call with invalid password",
        () async {
      // act
      final call = authFacade.signInWithEmailAndPassword;

      // assert
      expect(
        () => call(emailAddress: tEmailAddress, password: tInvalidPassword),
        throwsA(isInstanceOf<UnexpectedValueError>()),
      );
    });
  });
}
