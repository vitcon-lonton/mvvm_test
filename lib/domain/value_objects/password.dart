import 'package:dartz/dartz.dart';

import 'failures.dart';
import 'value_object.dart';
import 'value_validators.dart';

class Password extends ValueObject<String> {
  static const minLength = 6;
  static const maxLength = 20;

  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validateStringNotEmpty(input)
          .flatMap((value) => validateMinStringLength(input, minLength))
          .flatMap((value) => validateMaxStringLength(input, maxLength)),
    );
  }

  const Password._(this.value);
}
