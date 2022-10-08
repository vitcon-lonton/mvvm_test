part of 'sign_in_view.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with MessengerProvider, SignInViewProvider {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  SignInViewModel create() {
    return SignInViewModel(
      AuthFacade(myEmailAddress: myEmailAddress, myPassword: myPassword),
    )..initial();
  }

  @override
  Widget builder(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('LOGIN')),
        body: Column(children: [
          // INDICATOR
          const IndicatorProgress(),

          // FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(children: const [
                SizedBox(height: 24.0),

                // EMAIL
                SizedBox(height: 16.0),
                EmailInput(),

                // PASSWORD
                SizedBox(height: 16.0),
                PasswordInput(),

                // BUTTON
                SizedBox(height: 32.0),
                SizedBox(height: 32.0),
                SubmitButton(),

                // RESET BUTTON
                SizedBox(height: 32.0),
                ClearButton(),

                SizedBox(height: 32.0),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void onStatusChanged(SignInViewModelStatus status) {
    status.when(initial: () {
      _formKey.currentState?.reset();
    }, invalid: () {
      _formKey.currentState?.validate();
    }, inProgress: () {
      _formKey.currentState?.validate();
    }, success: () {
      showBanner('Success');
    }, failure: (AuthFailure failure) {
      _formKey.currentState?.validate();
      showSnackbar(failure.when(
        unexpected: () => 'Unexpected',
        serverError: () => 'ServerError',
        cancelledByUser: () => 'CancelledByUser',
        emailAlreadyInUse: () => 'EmailAlreadyInUse',
        invalidEmailAndPasswordCombination: () =>
            'InvalidEmailAndPasswordCombination',
      ));
    });
  }
}
