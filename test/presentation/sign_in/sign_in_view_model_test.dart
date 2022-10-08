import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm_test/domain/domain.dart';
import 'package:mvvm_test/presentation/sign_in/sign_in.dart';

class MockEmailAddress extends Mock implements EmailAddress {}

class MockPassword extends Mock implements Password {}

class MockAuthFacade extends Mock implements IAuthFacade {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthFacade());
    registerFallbackValue(MockEmailAddress());
    registerFallbackValue(MockPassword());
  });

  group('SignInViewModel', () {
    late SignInViewModel viewModel;
    late MockAuthFacade mockAuthFacade;
    late MockEmailAddress mockEmailAddress;
    late MockPassword mockPassword;
    late String tPasswordStr;
    late String tEmailAddressStr;

    setUp(() {
      tPasswordStr = '123457';
      tEmailAddressStr = '1232@example.com';
      mockAuthFacade = MockAuthFacade();
      viewModel = SignInViewModel(mockAuthFacade);
      mockEmailAddress = MockEmailAddress();
      mockPassword = MockPassword();
    });

    group("Submit", () {
      test('emit status invalid when email not set(null)', () async {
        // setup
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.isValid()).thenReturn(true);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Right(unit));

        // seed
        viewModel.initial();
        viewModel.setPassword(mockPassword);

        // act
        await viewModel.submit();

        // expect later
        expectLater(viewModel.emailAddress, emitsInOrder([isNull]));
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.invalid()]),
        );

        // verify
        verify(() => mockPassword.isValid()).called(1);
        verifyNever(() => mockEmailAddress.isValid());
        verifyNever(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword));
      });

      test('emit status invalid when password not set(null)', () async {
        // setup
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.isValid()).thenReturn(true);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Right(unit));

        // seed
        viewModel.initial();
        viewModel.setEmailAddress(mockEmailAddress);

        // act
        await viewModel.submit();

        // expect later
        expectLater(viewModel.password, emitsInOrder([isNull]));
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.invalid()]),
        );

        // verify
        verify(() => mockEmailAddress.isValid()).called(1);
        verifyNever(() => mockPassword.isValid());
        verifyNever(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword));
      });

      test('emit status invalid when call with invalid password', () async {
        // setup
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.isValid()).thenReturn(false);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Right(unit));

        // seed
        viewModel.initial();
        viewModel.setEmailAddress(mockEmailAddress);
        viewModel.setPassword(mockPassword);

        // act
        await viewModel.submit();

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.invalid()]),
        );

        // verify
        verify(() => mockEmailAddress.isValid()).called(1);
        verify(() => mockPassword.isValid()).called(1);
        verifyNever(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword));
      });

      test('emit status invalid when call with invalid email', () async {
        // setup
        when(() => mockEmailAddress.isValid()).thenReturn(false);
        when(() => mockPassword.isValid()).thenReturn(true);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Right(unit));

        // seed
        viewModel.initial();
        viewModel.setEmailAddress(mockEmailAddress);
        viewModel.setPassword(mockPassword);

        // act
        await viewModel.submit();

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.invalid()]),
        );

        // verify
        verify(() => mockEmailAddress.isValid()).called(1);
        verify(() => mockPassword.isValid()).called(1);
        verifyNever(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword));
      });

      test('emit status success when submit success', () async {
        // setup
        when(() => mockPassword.getOrCrash()).thenReturn(tPasswordStr);
        when(() => mockEmailAddress.getOrCrash()).thenReturn(tEmailAddressStr);
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.isValid()).thenReturn(true);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Right(unit));

        // seed
        viewModel.initial();
        viewModel.setEmailAddress(mockEmailAddress);
        viewModel.setPassword(mockPassword);

        // act
        await viewModel.submit();

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([
            const SignInViewModelStatus.inProgress(),
            const SignInViewModelStatus.success(),
          ]),
        );

        // verify
        verify(() => mockPassword.isValid()).called(1);
        verify(() => mockEmailAddress.isValid()).called(1);
        verify(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword)).called(1);
      });

      test('emit status failure when submit failure', () async {
        const failure = AuthFailure.invalidEmailAndPasswordCombination();

        // setup
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.isValid()).thenReturn(true);
        when(
          () => mockAuthFacade.signInWithEmailAndPassword(
              emailAddress: any(named: 'emailAddress'),
              password: any(named: 'password')),
        ).thenAnswer((_) async => const Left(failure));

        // seed
        viewModel.initial();
        viewModel.setEmailAddress(mockEmailAddress);
        viewModel.setPassword(mockPassword);

        // act
        await viewModel.submit();

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([
            const SignInViewModelStatus.inProgress(),
            const SignInViewModelStatus.failure(failure),
          ]),
        );

        // verify
        verify(() => mockPassword.isValid()).called(1);
        verify(() => mockEmailAddress.isValid()).called(1);
        verify(() => mockAuthFacade.signInWithEmailAndPassword(
            emailAddress: mockEmailAddress, password: mockPassword)).called(1);
      });
    });

    group("Initial", () {
      test('should reset all props', () {
        // expect later
        expectLater(viewModel.status,
            emitsInOrder([const SignInViewModelStatus.initial()]));
        expectLater(viewModel.displayPassword, emitsInOrder([isFalse]));
        expectLater(viewModel.emailAddress, emitsInOrder([isNull]));
        expectLater(viewModel.password, emitsInOrder([isNull]));

        // run
        viewModel.initial();
      });
    });

    group("SetStatus", () {
      test('should emit statues in order', () {
        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([
            const SignInViewModelStatus.initial(),
            const SignInViewModelStatus.inProgress(),
            const SignInViewModelStatus.initial(),
            const SignInViewModelStatus.success(),
            const SignInViewModelStatus.failure(
                AuthFailure.invalidEmailAndPasswordCombination()),
          ]),
        );

        // run
        viewModel.setStatus(const SignInViewModelStatus.initial());
        viewModel.setStatus(const SignInViewModelStatus.inProgress());
        viewModel.setStatus(const SignInViewModelStatus.initial());
        viewModel.setStatus(const SignInViewModelStatus.success());
        viewModel.setStatus(const SignInViewModelStatus.failure(
            AuthFailure.invalidEmailAndPasswordCombination()));
      });
    });

    group("SetEmailAddress", () {
      test('should emit email addresses in order', () {
        EmailAddress emailAddress = EmailAddress('example@gmail.com');
        EmailAddress invalidEmailAddress1 = EmailAddress('@32:as');
        EmailAddress? nullableEmailAddress;

        // expect later
        expectLater(
          viewModel.emailAddress,
          emitsInOrder([
            emailAddress,
            isNull,
            isNull,
            invalidEmailAddress1,
            emailAddress,
            isNull,
          ]),
        );

        // run
        viewModel.setEmailAddress(emailAddress);
        viewModel.setEmailAddress(nullableEmailAddress);
        viewModel.setEmailAddress(nullableEmailAddress);
        viewModel.setEmailAddress(invalidEmailAddress1);
        viewModel.setEmailAddress(emailAddress);
        viewModel.setEmailAddress(nullableEmailAddress);
      });
    });

    group("SetPassword", () {
      test('should emit passwords in order', () {
        Password password = Password('valid0password');
        Password invalidPassword = Password('1234');
        Password? nullablePassword;

        // expect later
        expectLater(
          viewModel.password,
          emitsInOrder([
            isNull,
            password,
            isNull,
            isNull,
            invalidPassword,
            password,
          ]),
        );

        // run
        viewModel.setPassword(nullablePassword);
        viewModel.setPassword(password);
        viewModel.setPassword(nullablePassword);
        viewModel.setPassword(nullablePassword);
        viewModel.setPassword(invalidPassword);
        viewModel.setPassword(password);
      });
    });

    group("SetDisplayPassword", () {
      test('should emit booleans in order', () {
        // expect later
        expectLater(
          viewModel.displayPassword,
          emitsInOrder([false, false, true, true, false]),
        );

        // run
        viewModel.setDisplayPassword(false);
        viewModel.setDisplayPassword(false);
        viewModel.setDisplayPassword(true);
        viewModel.setDisplayPassword(true);
        viewModel.setDisplayPassword(false);
      });
    });
  });
}
