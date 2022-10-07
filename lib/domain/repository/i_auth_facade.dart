import 'package:dartz/dartz.dart';

import '../auth_failure.dart';
import '../value_objects/value_objects.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword(
      {required EmailAddress emailAddress, required Password password});
}
