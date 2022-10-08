part of 'sign_in_view.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            elevation: 0,
            minimumSize: const Size(double.infinity, 50)),
        onPressed: Provider.of<SignInViewModel>(context).initial,
        child: const Text('RESET FORM'));
  }
}
