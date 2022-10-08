part of 'sign_in_view.dart';

mixin MessengerProvider<T extends StatefulWidget> on State<T> {
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(context);

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void showBanner(String message) {
    MaterialBanner banner = MaterialBanner(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Dismiss'),
        ),
      ],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showMaterialBanner(banner);
  }
}

mixin SignInViewProvider<T extends StatefulWidget> on State<T> {
  late final SignInViewModel viewModel;
  late final StreamSubscription<SignInViewModelStatus> _statusSubscription;

  @protected
  SignInViewModel create();

  @protected
  void onStatusChanged(SignInViewModelStatus status);

  @protected
  Widget builder(BuildContext context);

  @override
  @mustCallSuper
  initState() {
    super.initState();
    viewModel = create();
    _statusSubscription = viewModel.status.listen(onStatusChanged);
  }

  @override
  @mustCallSuper
  dispose() async {
    await _statusSubscription.cancel();
    await viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInViewModel>.value(
        value: viewModel, child: builder(context));
  }
}




// @protected
// Widget builder(BuildContext context, SignInViewModel viewModel);

//   @override
// Widget build(BuildContext context) {
//   return ChangeNotifierProvider<T>(
//     builder: (context) => model,
//     child: Consumer<T>(builder: widget.builder),
//   );
// }

// child: builder(context),
// void afterFirstLayout(BuildContext context);
// @mustCallSuper
