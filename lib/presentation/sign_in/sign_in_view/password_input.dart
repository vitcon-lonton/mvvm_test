part of 'sign_in_view.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInViewModel viewModel = Provider.of<SignInViewModel>(context);

    return StreamBuilder<bool>(
      stream: viewModel.displayPassword,
      builder: (context, snapshot) {
        bool isDisplayPassword = snapshot.data ?? false;
        Icon icon = isDisplayPassword
            ? const Icon(CupertinoIcons.lock_open_fill)
            : const Icon(CupertinoIcons.lock_fill);

        return StreamBuilder<Password?>(
          stream: viewModel.password,
          builder: (context, snapshot) {
            Password? password = snapshot.data;

            return TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  icon: icon,
                  onPressed: () =>
                      viewModel.setDisplayPassword(!isDisplayPassword),
                ),
              ),
              validator: (String? value) {
                return password == null
                    ? 'Empty'
                    : password.value.swap().toOption().toNullable()?.map(
                        exceedingLength: (_) => 'ExceedingLength',
                        notAchievedLength: (_) => 'NotAchievedLength',
                        empty: (_) => 'Empty',
                        numeric: (_) => 'Numeric',
                        multiline: (_) => 'Multiline',
                        listTooLong: (_) => 'ListTooLong',
                        invalidEmail: (_) => 'InvalidEmail',
                        other: (_) => 'Other');
              },
              obscureText: !isDisplayPassword,
              onChanged: (String value) {
                viewModel.setPassword(Password(value));
              },
            );
          },
        );
      },
    );
  }
}
