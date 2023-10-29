import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class SubmitSuccess extends StatefulWidget {
  const SubmitSuccess({Key? key}) : super(key: key);

  @override
  _SubmitSuccessState createState() {
    return _SubmitSuccessState();
  }
}

class _SubmitSuccessState extends State<SubmitSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Add More
  void _onSuccess() {
    Navigator.pushReplacementNamed(context, Routes.submit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('completed'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Translate.of(context).translate('completed'),
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Translate.of(context).translate(
                          'submit_success_message',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppButton(
                  Translate.of(context).translate('add_more'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _onSuccess,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
