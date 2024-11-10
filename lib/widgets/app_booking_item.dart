import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/datetime.dart';
import 'package:listar_flutter_pro/widgets/app_placeholder.dart';

class AppBookingItem extends StatelessWidget {
  final BookingItemModel? item;
  final VoidCallback? onPressed;

  const AppBookingItem({
    Key? key,
    this.item,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      return InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item?.createdBy ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.date?.dateView ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item?.status ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: item?.statusColor),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return AppPlaceholder(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 150,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
