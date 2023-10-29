import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class GalleryUpload extends StatefulWidget {
  final List<ImageModel> images;
  const GalleryUpload({Key? key, required this.images}) : super(key: key);

  @override
  _GalleryUploadState createState() {
    return _GalleryUploadState();
  }
}

class _GalleryUploadState extends State<GalleryUpload> {
  List<ImageModel?> _images = [];

  @override
  void initState() {
    super.initState();
    _images = List<ImageModel?>.from(widget.images);
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///on add item
  void _onAddItem() {
    final emptyUpload = _images.where((item) => item == null).isEmpty;
    if (emptyUpload) {
      ImageModel? item;
      setState(() {
        _images.add(item);
      });
    }
  }

  ///On Update
  void _onUpdate(ImageModel? old, ImageModel item) {
    setState(() {
      _images = _images.map((e) {
        if (e == old) {
          return item;
        }
        return e;
      }).toList();
    });
  }

  ///On Delete
  void _onDelete(item) {
    setState(() {
      _images.remove(item);
    });
  }

  ///On Save
  void _onSave() {
    final result = _images.where((item) {
      return item != null;
    }).toList();
    Navigator.pop(context, List<ImageModel>.from(result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('gallery'),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ..._images.map((item) {
                Widget action = Container();
                if (item != null) {
                  action = Positioned(
                    bottom: 4,
                    left: 4,
                    child: InkWell(
                      onTap: () {
                        _onDelete(item);
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.remove_circle,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                }
                return Stack(
                  children: [
                    AppUploadImage(
                      key: Key(item?.id.toString() ?? ''),
                      image: item,
                      onChange: (result) {
                        _onUpdate(item, result);
                      },
                    ),
                    action
                  ],
                );
              }).toList(),
              ...[
                InkWell(
                  onTap: _onAddItem,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).dividerColor,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
