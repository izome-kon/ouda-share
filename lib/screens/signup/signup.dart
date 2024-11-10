import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _textIDController = TextEditingController();
  final _textPassController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _focusID = FocusNode();
  final _focusPass = FocusNode();
  final _focusEmail = FocusNode();

  bool _showPassword = false;
  String? _errorID;
  String? _errorPass;
  String? _errorEmail;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textIDController.dispose();
    _textPassController.dispose();
    _textEmailController.dispose();
    _focusID.dispose();
    _focusPass.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  ///On sign up
  void _signUp() async {
    Utils.hiddenKeyboard(context);
    setState(() {
      _errorID = UtilValidator.validate(_textIDController.text);
      _errorPass = UtilValidator.validate(_textPassController.text);
      _errorEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
    });
    if (_errorID == null && _errorPass == null && _errorEmail == null) {
      final result = await AppBloc.userCubit.onRegister(
        username: _textIDController.text,
        password: _textPassController.text,
        email: _textEmailController.text,
      );
      if (result) {
        if (!mounted) return;
        AppBloc.loginCubit.onLogin(
          username: _textIDController.text,
          password: _textPassController.text,
        );
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
          Translate.of(context).translate('sign_up'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('account'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_id'),
                  errorText: _errorID,
                  controller: _textIDController,
                  focusNode: _focusID,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _errorID = UtilValidator.validate(_textIDController.text);
                    });
                  },
                  onSubmitted: (text) {
                    Utils.fieldFocusChange(context, _focusID, _focusPass);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('password'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  errorText: _errorPass,
                  onChanged: (text) {
                    setState(() {
                      _errorPass = UtilValidator.validate(
                        _textPassController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    Utils.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusEmail,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: !_showPassword,
                  controller: _textPassController,
                  focusNode: _focusPass,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('email'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_email'),
                  errorText: _errorEmail,
                  focusNode: _focusEmail,
                  onSubmitted: (text) {
                    _signUp();
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
                const SizedBox(height: 16),
                AppButton(
                  Translate.of(context).translate('sign_up'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _signUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
