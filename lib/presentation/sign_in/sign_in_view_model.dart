// part of 'sign_in.dart';

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/domain.dart';
part 'sign_in_view_model.freezed.dart';

@freezed
class SignInViewModelStatus with _$SignInViewModelStatus {
  const factory SignInViewModelStatus.initial() = _Initial;
  const factory SignInViewModelStatus.invalid() = _Invalid;
  const factory SignInViewModelStatus.inProgress() = _InProgress;
  const factory SignInViewModelStatus.success() = _Success;
  const factory SignInViewModelStatus.failure(AuthFailure failure) = _Failure;
}

class SignInViewModel with ChangeNotifier {
  final IAuthFacade _facade;

  late BehaviorSubject<SignInViewModelStatus> _status;
  late BehaviorSubject<EmailAddress?> _emailAddress;
  late BehaviorSubject<Password?> _password;
  late BehaviorSubject<bool> _displayPassword;

  StreamSubscription<Either<AuthFailure, Unit>>? _loginResultSubscription;

  SignInViewModel(this._facade) {
    _status = BehaviorSubject<SignInViewModelStatus>();
    _emailAddress = BehaviorSubject<EmailAddress?>();
    _password = BehaviorSubject<Password?>();
    _displayPassword = BehaviorSubject<bool>();
  }

  Stream<SignInViewModelStatus> get status => _status.stream;
  Stream<EmailAddress?> get emailAddress => _emailAddress.stream;
  Stream<Password?> get password => _password.stream;
  Stream<bool> get displayPassword => _displayPassword.stream;

  void setStatus(SignInViewModelStatus value) => _status.add(value);
  void setEmailAddress(EmailAddress? value) => _emailAddress.add(value);
  void setPassword(Password? value) => _password.add(value);
  void setDisplayPassword(bool value) => _displayPassword.add(value);

  void initial() {
    setStatus(const SignInViewModelStatus.initial());
    setDisplayPassword(false);
    setEmailAddress(null);
    setPassword(null);
  }

  Future<void> submit() async {
    EmailAddress? emailAddress = _emailAddress.value;
    Password? password = _password.value;

    bool isEmailValid = emailAddress?.isValid() ?? false;
    bool isPasswordValid = password?.isValid() ?? false;
    bool isValid = isEmailValid && isPasswordValid;

    if (!isValid) {
      setStatus(const SignInViewModelStatus.invalid());
    } else {
      setStatus(const SignInViewModelStatus.inProgress());

      await _loginResultSubscription?.cancel();

      _loginResultSubscription = _facade
          .signInWithEmailAndPassword(
              emailAddress: emailAddress!, password: password!)
          .asStream()
          .listen((Either<AuthFailure, Unit> failureOrSuccess) {
        failureOrSuccess.fold((AuthFailure failure) {
          setStatus(SignInViewModelStatus.failure(failure));
        }, (_) {
          setStatus(const SignInViewModelStatus.success());
        });
      });
    }
  }

  @override
  Future<void> dispose() async {
    await _loginResultSubscription?.cancel();
    await _status.close();
    await _emailAddress.close();
    await _password.close();
    await _displayPassword.close();
    super.dispose();
  }
}

// class SignInViewModel with ChangeNotifier {
// _emailSubscription = _emailAddress.listen((value) => validate());
// _passwordSubscription = _password.listen((value) => validate());
// StreamSubscription<EmailAddress>? _emailSubscription;
// StreamSubscription<Password>? _passwordSubscription;
// Stream<bool?> get isValid => _isValid.stream;
// late BehaviorSubject<bool?> _isValid;


// await _emailSubscription?.cancel();
// await _passwordSubscription?.cancel();