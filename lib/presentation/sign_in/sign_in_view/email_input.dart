part of 'sign_in_view.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInViewModel viewModel = Provider.of<SignInViewModel>(context);

    return StreamBuilder<EmailAddress?>(
      stream: viewModel.emailAddress,
      builder: (context, snapshot) {
        EmailAddress? emailAddress = snapshot.data;

        return TextFormField(
          decoration: const InputDecoration(
              labelText: 'Email', alignLabelWithHint: true),
          validator: (String? value) {
            return emailAddress?.value.swap().toOption().toNullable()?.map(
                    exceedingLength: (_) => 'ExceedingLength',
                    notAchievedLength: (_) => 'NotAchievedLength',
                    empty: (_) => 'Empty',
                    numeric: (_) => 'Numeric',
                    multiline: (_) => 'Multiline',
                    listTooLong: (_) => 'ListTooLong',
                    invalidEmail: (_) => 'InvalidEmail',
                    other: (_) => 'Other') ??
                'Empty';
          },
          onChanged: (String value) {
            viewModel.setEmailAddress(EmailAddress(value));
          },
        );
      },
    );
  }
}
