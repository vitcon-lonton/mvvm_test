part of 'sign_in_view.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'LOGIN';
    SignInViewModel viewModel = Provider.of<SignInViewModel>(context);

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            elevation: 0,
            minimumSize: const Size(double.infinity, 50)),
      ),
      child: StreamBuilder<SignInViewModelStatus>(
        stream: viewModel.status,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ElevatedButton(onPressed: null, child: Text(title));
          }

          return snapshot.data!.maybeWhen(orElse: () {
            return ElevatedButton(
                onPressed: viewModel.submit, child: Text(title));
          }, inProgress: () {
            return ElevatedButton(onPressed: null, child: Text(title));
          });
        },
      ),
    );
  }
}
