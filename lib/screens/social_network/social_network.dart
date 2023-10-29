import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class SocialNetwork extends StatefulWidget {
  final Map<String, dynamic>? socials;

  const SocialNetwork({Key? key, this.socials}) : super(key: key);

  @override
  _SocialNetworkState createState() {
    return _SocialNetworkState();
  }
}

class _SocialNetworkState extends State<SocialNetwork> {
  final _textFacebookController = TextEditingController();
  final _textTwitterController = TextEditingController();
  final _textInstagramController = TextEditingController();
  final _textGoogleController = TextEditingController();
  final _textLinkedinController = TextEditingController();
  final _textYoutubeController = TextEditingController();
  final _textTumblrController = TextEditingController();
  final _textFlickrController = TextEditingController();
  final _textPinterestController = TextEditingController();

  final _focusFacebook = FocusNode();
  final _focusTwitter = FocusNode();
  final _focusInstagram = FocusNode();
  final _focusGoogle = FocusNode();
  final _focusLinkedin = FocusNode();
  final _focusYoutube = FocusNode();
  final _focusTumblr = FocusNode();
  final _focusFlickr = FocusNode();
  final _focusPinterest = FocusNode();

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  void dispose() {
    super.dispose();
    _textFacebookController.dispose();
    _textTwitterController.dispose();
    _textInstagramController.dispose();
    _textGoogleController.dispose();
    _textLinkedinController.dispose();
    _textYoutubeController.dispose();
    _textTumblrController.dispose();
    _textFlickrController.dispose();
    _textPinterestController.dispose();
    _focusFacebook.dispose();
    _focusTwitter.dispose();
    _focusInstagram.dispose();
    _focusGoogle.dispose();
    _focusLinkedin.dispose();
    _focusYoutube.dispose();
    _focusTumblr.dispose();
    _focusFlickr.dispose();
    _focusPinterest.dispose();
  }

  ///On Init
  void _initForm() {
    if (widget.socials != null) {
      _textFacebookController.text = widget.socials!['facebook'] ?? '';
      _textTwitterController.text = widget.socials!['twitter'] ?? '';
      _textInstagramController.text = widget.socials!['instagram'] ?? '';
      _textGoogleController.text = widget.socials!['google_plus'] ?? '';
      _textLinkedinController.text = widget.socials!['linkedin'] ?? '';
      _textYoutubeController.text = widget.socials!['youtube'] ?? '';
      _textTumblrController.text = widget.socials!['tumblr'] ?? '';
      _textFlickrController.text = widget.socials!['flick'] ?? '';
      _textPinterestController.text = widget.socials!['pinterest'] ?? '';
    }
  }

  ///On Save
  void _onSave() {
    final Map<String, dynamic> data = {};
    if (_textFacebookController.text.isNotEmpty) {
      data['facebook'] = _textFacebookController.text;
    }
    if (_textTwitterController.text.isNotEmpty) {
      data['twitter'] = _textTwitterController.text;
    }
    if (_textInstagramController.text.isNotEmpty) {
      data['instagram'] = _textInstagramController.text;
    }
    if (_textGoogleController.text.isNotEmpty) {
      data['google_plus'] = _textGoogleController.text;
    }
    if (_textLinkedinController.text.isNotEmpty) {
      data['linkedin'] = _textLinkedinController.text;
    }
    if (_textYoutubeController.text.isNotEmpty) {
      data['youtube'] = _textYoutubeController.text;
    }
    if (_textTumblrController.text.isNotEmpty) {
      data['tumblr'] = _textTumblrController.text;
    }
    if (_textFlickrController.text.isNotEmpty) {
      data['flick'] = _textFlickrController.text;
    }
    if (_textPinterestController.text.isNotEmpty) {
      data['pinterest'] = _textPinterestController.text;
    }
    Navigator.pop(context, data.isNotEmpty ? data : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('social_network'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onSave,
            type: ButtonType.text,
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Facebook',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_facebook',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusFacebook,
                  _focusTwitter,
                );
              },
              controller: _textFacebookController,
              focusNode: _focusFacebook,
            ),
            const SizedBox(height: 8),
            Text(
              'Twitter',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_twitter',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusTwitter,
                  _focusInstagram,
                );
              },
              controller: _textTwitterController,
              focusNode: _focusTwitter,
            ),
            const SizedBox(height: 8),
            Text(
              'Instagram',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_instagram',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusInstagram,
                  _focusGoogle,
                );
              },
              controller: _textInstagramController,
              focusNode: _focusInstagram,
            ),
            const SizedBox(height: 8),
            Text(
              'Google',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_google',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusGoogle,
                  _focusLinkedin,
                );
              },
              controller: _textGoogleController,
              focusNode: _focusGoogle,
            ),
            const SizedBox(height: 8),
            Text(
              'Linkedin',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_linkedin',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusLinkedin,
                  _focusYoutube,
                );
              },
              controller: _textLinkedinController,
              focusNode: _focusLinkedin,
            ),
            const SizedBox(height: 8),
            Text(
              'Youtube',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_youtube',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusYoutube,
                  _focusTumblr,
                );
              },
              controller: _textYoutubeController,
              focusNode: _focusYoutube,
            ),
            const SizedBox(height: 8),
            Text(
              'Tumblr',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_tumblr',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusTumblr,
                  _focusFlickr,
                );
              },
              controller: _textTumblrController,
              focusNode: _focusTumblr,
            ),
            const SizedBox(height: 8),
            Text(
              'Flickr',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_flickr',
              ),
              onSubmitted: (text) {
                Utils.fieldFocusChange(
                  context,
                  _focusFlickr,
                  _focusPinterest,
                );
              },
              controller: _textFlickrController,
              focusNode: _focusFlickr,
            ),
            const SizedBox(height: 8),
            Text(
              'Pinterest',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            AppTextInput(
              hintText: Translate.of(context).translate(
                'input_pinterest',
              ),
              controller: _textPinterestController,
              focusNode: _focusPinterest,
            ),
          ],
        ),
      ),
    );
  }
}
