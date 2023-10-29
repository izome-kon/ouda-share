import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  _ScanQRState createState() {
    return _ScanQRState();
  }
}

class _ScanQRState extends State<ScanQR> {
  final _qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? _controller;
  bool _done = false;
  bool _flash = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!_done) {
        Navigator.pop(context, scanData.code);
      }
      _done = true;
    });

    if (Platform.isAndroid) {
      _controller?.resumeCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    }
    _controller?.resumeCamera();
  }

  void _flashChange(bool status) {
    _controller?.toggleFlash();
    setState(() {
      _flash = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('scan_qrcode'),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).colorScheme.primary,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
            ),
          ),
          Positioned(
            bottom: 50,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _flash
                          ? Icons.flashlight_off_outlined
                          : Icons.flashlight_on_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _flashChange(!_flash);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
