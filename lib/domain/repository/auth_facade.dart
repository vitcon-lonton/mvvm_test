import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../auth_failure.dart';
import '../value_objects/value_objects.dart';
import 'i_auth_facade.dart';

class AuthFacade implements IAuthFacade {
  late final EmailAddress _myEmailAddress;
  late final Password _myPassword;

  AuthFacade({
    required EmailAddress myEmailAddress,
    required Password myPassword,
  }) {
    _myEmailAddress = myEmailAddress;
    _myPassword = myPassword;
  }

  /// Throws [UnexpectedValueError] containing the [ValueFailure] when email or password invalid
  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password}) async {
    await Future.delayed(const Duration(seconds: 1));

    emailAddress.getOrCrash();
    password.getOrCrash();

    try {
      bool isMatchPassword = password == _myPassword;
      bool isMatchEmail = emailAddress == _myEmailAddress;

      if (isMatchPassword && isMatchEmail) {
        return const Right(unit);
      } else {
        return const Left(AuthFailure.invalidEmailAndPasswordCombination());
      }
    } catch (e) {
      debugPrint('-------- signInWithEmailAndPassword --------');
      debugPrint(e.toString());
      debugPrint('-------- signInWithEmailAndPassword --------');

      return const Left(AuthFailure.unexpected());
    }
  }
}
