import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/app_placeholder.dart';

class ProfileHeader extends SliverPersistentHeaderDelegate {
  final double height;
  final UserModel? user;
  final VoidCallback? onQRCode;
  final bool showQR;

  ProfileHeader({
    required this.height,
    this.user,
    this.onQRCode,
    required this.showQR,
  });

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    Widget content = AppPlaceholder(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 100, color: Colors.white),
                const SizedBox(height: 4),
                Container(height: 10, width: 150, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 10, width: 100, color: Colors.white),
                const SizedBox(height: 4),
                Container(height: 10, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
    Widget action = Container();
    Widget description = Container();

    if (user != null) {
      String post = '';
      String review = '';
      if (user!.total > 0) {
        post = '${user!.total} ${Translate.of(context).translate('post')},';
      }
      if (user!.rate > 0) {
        review = '${user!.comment} ${Translate.of(context).translate(
          'review',
        )}';
      }
      if (user!.description.isNotEmpty) {
        description = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user!.description,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
      if (showQR) {
        action = IconButton(
          onPressed: onQRCode,
          icon: const Icon(
            Icons.qr_code_rounded,
            size: 32,
          ),
        );
      }
      content = Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CachedNetworkImage(
                imageUrl: user!.image,
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  '${user!.rate}',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.name,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                description,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          initialRating: user!.rate,
                          minRating: 1,
                          allowHalfRating: true,
                          unratedColor: Colors.amber.withAlpha(100),
                          itemCount: 5,
                          itemSize: 12.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rate) {},
                          ignoreGestures: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$post$review',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                    action,
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      height: height,
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
