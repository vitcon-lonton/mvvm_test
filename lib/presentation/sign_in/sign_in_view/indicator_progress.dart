part of 'sign_in_view.dart';

class IndicatorProgress extends StatelessWidget {
  const IndicatorProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInViewModel viewModel = Provider.of<SignInViewModel>(context);

    return StreamBuilder<SignInViewModelStatus>(
      stream: viewModel.status,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.maybeWhen(orElse: () {
            return const SizedBox.shrink();
          }, inProgress: () {
            return const LinearProgressIndicator();
          });
        }

        return const SizedBox.shrink();
      },
    );
  }
}
