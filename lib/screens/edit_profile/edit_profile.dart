import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _textNameController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textWebsiteController = TextEditingController();
  final _textInfoController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusWebsite = FocusNode();
  final _focusInfo = FocusNode();
  final picker = ImagePicker();

  ImageModel? _image;
  String? _errorName;
  String? _errorEmail;
  String? _errorWebsite;
  String? _errorInfo;

  @override
  void initState() {
    super.initState();
    final user = AppBloc.userCubit.state!;
    _textNameController.text = user.name;
    _textEmailController.text = user.email;
    _textWebsiteController.text = user.url;
    _textInfoController.text = user.description;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On update image
  void _updateProfile() async {
    Utils.hiddenKeyboard(context);
    setState(() {
      _errorName = UtilValidator.validate(_textNameController.text);
      _errorEmail = UtilValidator.validate(
        _textEmailController.text,
        type: ValidateType.email,
      );
      _errorWebsite = UtilValidator.validate(_textWebsiteController.text);
      _errorInfo = UtilValidator.validate(_textInfoController.text);
    });
    if (_errorName == null &&
        _errorEmail == null &&
        _errorWebsite == null &&
        _errorInfo == null) {
      ///Fetch change profile
      final result = await AppBloc.userCubit.onUpdateUser(
        name: _textNameController.text,
        email: _textEmailController.text,
        url: _textWebsiteController.text,
        description: _textInfoController.text,
        image: _image,
      );

      ///Case success
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
        title: Text(Translate.of(context).translate('edit_profile')),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: AppUploadImage(
                          type: UploadImageType.circle,
                          image: ImageModel(
                            id: 0,
                            full: AppBloc.userCubit.state!.image,
                            thumb: AppBloc.userCubit.state!.image,
                          ),
                          onChange: (result) {
                            setState(() {
                              _image = result;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translate.of(context).translate('name'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText: Translate.of(context).translate('input_name'),
                    errorText: _errorName,
                    focusNode: _focusName,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (text) {
                      Utils.fieldFocusChange(
                        context,
                        _focusName,
                        _focusEmail,
                      );
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorName = UtilValidator.validate(
                          _textNameController.text,
                        );
                      });
                    },
                    controller: _textNameController,
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
                    textInputAction: TextInputAction.next,
                    onSubmitted: (text) {
                      Utils.fieldFocusChange(
                        context,
                        _focusEmail,
                        _focusWebsite,
                      );
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
                  Text(
                    Translate.of(context).translate('website'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText: Translate.of(context).translate(
                      'input_website',
                    ),
                    errorText: _errorWebsite,
                    focusNode: _focusWebsite,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (text) {
                      Utils.fieldFocusChange(
                        context,
                        _focusWebsite,
                        _focusInfo,
                      );
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorWebsite = UtilValidator.validate(
                          _textWebsiteController.text,
                        );
                      });
                    },
                    controller: _textWebsiteController,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translate.of(context).translate('information'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText: Translate.of(context).translate(
                      'input_information',
                    ),
                    errorText: _errorInfo,
                    focusNode: _focusInfo,
                    maxLines: 5,
                    onSubmitted: (text) {
                      _updateProfile();
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorInfo = UtilValidator.validate(
                          _textInfoController.text,
                        );
                      });
                    },
                    controller: _textInfoController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                Translate.of(context).translate('confirm'),
                mainAxisSize: MainAxisSize.max,
                onPressed: _updateProfile,
              ),
            )
          ],
        ),
      ),
    );
  }
}
