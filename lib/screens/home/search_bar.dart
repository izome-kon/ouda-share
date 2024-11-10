import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class MySearchBar extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onScan;
  const MySearchBar({
    Key? key,
    required this.onSearch,
    required this.onScan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: TextButton(
            onPressed: onSearch,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Translate.of(context).translate(
                        'search_location',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const VerticalDivider(),
                  InkWell(
                    onTap: onScan,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
