import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mvvm_test/credential.dart';
import 'package:mvvm_test/domain/domain.dart';
import 'package:mvvm_test/presentation/sign_in/sign_in.dart';

class MockEmailAddress extends Mock implements EmailAddress {}

class MockPassword extends Mock implements Password {}

class MockAuthFacade extends Mock implements AuthFacade {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthFacade());
    registerFallbackValue(MockEmailAddress());
    registerFallbackValue(MockPassword());
  });

  group('SignInViewModel', () {
    late SignInViewModel viewModel;
    late MockAuthFacade mockAuthFacade;

    setUp(() {
      mockAuthFacade = MockAuthFacade();
      viewModel = SignInViewModel(mockAuthFacade);
    });

    group("Submit", () {
      test('emit status success when submit success', () {
        final mockEmailAddress = MockEmailAddress();
        final mockPassword = MockPassword();
        // final emailAddress = myEmailAddress;
        // final password = myPassword;

        // setup
        when(() => mockEmailAddress.getOrCrash()).thenReturn('1232@gmail.com');
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.getOrCrash()).thenReturn('123457');
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

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.success()]),
        );

        // act
        viewModel.submit();

        // verify
        // verify(() => mockPassword.isValid()).called(1);
        // verify(() => mockAuthFacade.signInWithEmailAndPassword(
        //     emailAddress: mockEmailAddress, password: mockPassword)).called(1);
      });

      test('emit status success when submit success', () {
        final mockEmailAddress = MockEmailAddress();
        final mockPassword = MockPassword();
        // final emailAddress = myEmailAddress;
        // final password = myPassword;

        // setup
        when(() => mockEmailAddress.getOrCrash()).thenReturn('1232@gmail.com');
        when(() => mockEmailAddress.isValid()).thenReturn(true);
        when(() => mockPassword.getOrCrash()).thenReturn('123457');
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

        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.success()]),
        );

        // act
        viewModel.submit();

        // verify
        // verify(() => mockPassword.isValid()).called(1);
        // verify(() => mockAuthFacade.signInWithEmailAndPassword(
        //     emailAddress: mockEmailAddress, password: mockPassword)).called(1);
      });
    });

    group("Initial", () {
      test('initial', () {
        // expect later
        expectLater(
          viewModel.status,
          emitsInOrder([const SignInViewModelStatus.initial()]),
        );
        expectLater(viewModel.displayPassword, emitsInOrder([isFalse]));
        expectLater(viewModel.emailAddress, emitsInOrder([isNull]));
        expectLater(viewModel.password, emitsInOrder([isNull]));

        // run
        viewModel.initial();
      });
    });

    test('should emit numbers in decreasing order', () {
      // expect later
      expectLater(
        viewModel.status,
        emitsInOrder([
          const SignInViewModelStatus.initial(),
          const SignInViewModelStatus.inProgress(),
        ]),
      );

      // run
      viewModel.setStatus(const SignInViewModelStatus.initial());
      viewModel.setStatus(const SignInViewModelStatus.inProgress());
    });
  });
}
