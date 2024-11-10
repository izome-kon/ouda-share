import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _textEmailController = TextEditingController();

  String? _errorEmail;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEmailController.dispose();
    super.dispose();
  }

  ///Fetch API
  void _forgotPassword() async {
    Utils.hiddenKeyboard(context);
    setState(() {
      _errorEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
    });
    if (_errorEmail == null) {
      final result = await AppBloc.userCubit.onForgotPassword(
        _textEmailController.text,
      );
      if (result) {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('forgot_password'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('email'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_email',
                  ),
                  errorText: _errorEmail,
                  onSubmitted: (text) {
                    _forgotPassword();
                  },
                  onChanged: (text) {
                    setState(() {
                      _errorEmail = UtilValidator.validate(
                        _textEmailController.text,
                        type: ValidateType.email,
                      );
                    });
                  },
                  controller: _textEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppButton(
                    Translate.of(context).translate('reset_password'),
                    mainAxisSize: MainAxisSize.max,
                    onPressed: _forgotPassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
