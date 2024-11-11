import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/api/api.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:open_filex/open_filex.dart';

class AppDownloadFile extends StatefulWidget {
  final FileModel file;
  final Widget? child;
  final Widget? success;
  final Widget? fail;
  final Widget? downloading;

  const AppDownloadFile({
    Key? key,
    required this.file,
    this.child,
    this.success,
    this.downloading,
    this.fail,
  }) : super(key: key);

  @override
  _AppDownloadFileState createState() => _AppDownloadFileState();
}

class _AppDownloadFileState extends State<AppDownloadFile> {
  double _percent = 0.0;
  bool _error = false;
  File? _file;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Load file exist
  void _loadFile() async {
    final file = await UtilFile.loadFile(widget.file);
    setState(() {
      _file = file;
    });
  }

  ///Download file
  void _downloadFile() async {
    final result = await Api.requestDownloadFile(
        file: widget.file,
        progress: (percent) {
          setState(() {
            _percent = percent;
          });
        });

    if (!result.success) {
      setState(() {
        _error = true;
      });
    } else {
      _file = result.data;
    }
  }

  ///Download file
  void _openFile() {
    if (_file != null) {
      OpenFilex.open(_file!.path);
    }
  }

  ///Widget build child
  Widget _buildChild() {
    return InkWell(
      onTap: _downloadFile,
      child: Icon(
        Icons.cloud_download,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  ///Widget build fail
  Widget _buildFail() {
    return Container();
  }

  ///Widget build downloading
  Widget _buildDownloading() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        value: _percent,
      ),
    );
  }

  ///Widget build success
  Widget _buildSuccess() {
    return InkWell(
      onTap: _openFile,
      child: Icon(
        Icons.file_download_done,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return widget.fail ?? _buildFail();
    }
    if (_file != null) {
      return widget.success ?? _buildSuccess();
    }
    if (_percent > 0) {
      return widget.downloading ?? _buildDownloading();
    }
    return Container(
      child: widget.child ?? _buildChild(),
    );
  }
}
