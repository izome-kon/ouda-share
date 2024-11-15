import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class AppProductItem extends StatelessWidget {
  const AppProductItem({
    Key? key,
    this.item,
    this.onPressed,
    required this.type,
    this.trailing,
  }) : super(key: key);

  final ProductModel? item;
  final ProductViewType type;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      ///Mode View Small
      case ProductViewType.small:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 180,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      width: 84,
                      height: 84,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item!.title,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item?.category?.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${item!.rate}",
                          type: TagType.rate,
                        ),
                        const SizedBox(width: 4),
                        RatingBar.builder(
                          initialRating: item!.rate,
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
                      ],
                    ),
                    price ?? Container(),
                  ],
                ),
              ),
              trailing ?? Container()
            ],
          ),
        );

      ///Mode View Gird
      case ProductViewType.grid:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 24,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Text(
            item!.priceDisplay,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.end,
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            item!.status.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                item!.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              Text(
                item?.category?.title ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                item!.title,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AppTag(
                    "${item!.rate}",
                    type: TagType.rate,
                  ),
                  const SizedBox(width: 4),
                  RatingBar.builder(
                    initialRating: item!.rate,
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
                  Expanded(
                    child: price ?? Container(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item!.address,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );

      ///Mode View List
      case ProductViewType.list:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item!.image.thumb,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            item!.status.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return AppPlaceholder(
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return AppPlaceholder(
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item?.category?.title ?? '',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item!.title,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AppTag(
                              "${item!.rate}",
                              type: TagType.rate,
                            ),
                            const SizedBox(width: 4),
                            RatingBar.builder(
                              initialRating: item!.rate,
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
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item!.address,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone_outlined,
                              size: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(item!.phone,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodySmall),
                            )
                          ],
                        ),
                        price ?? Container(),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  item!.favorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        );

      ///Mode View Block
      case ProductViewType.block:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        Widget? price;
        if (item!.priceDisplay.isNotEmpty) {
          price = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                item!.priceDisplay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )
            ],
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: item!.image.thumb,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              item!.status.isNotEmpty
                                  ? AppTag(
                                      item!.status,
                                      type: TagType.status,
                                    )
                                  : Container(),
                              Icon(
                                item!.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      AppTag(
                                        "${item!.rate}",
                                        type: TagType.rate,
                                      ),
                                      const SizedBox(width: 4),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                              Translate.of(context).translate(
                                                'rate',
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          RatingBar.builder(
                                            initialRating: item!.rate,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            unratedColor:
                                                Colors.amber.withAlpha(100),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rate) {},
                                            ignoreGestures: true,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item!.numRate} ${Translate.of(context).translate('feedback')}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      height: 200,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      height: 200,
                      color: Colors.white,
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                item?.category?.title ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item!.title,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        price ?? Container(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item!.address,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item!.phone,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Case View Card small
      case ProductViewType.card:
        if (item == null) {
          return SizedBox(
            width: 110,
            child: AppPlaceholder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }
        return SizedBox(
          width: 110,
          child: GestureDetector(
            onTap: onPressed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item!.image.thumb,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    item!.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );

      default:
        return Container(width: 160.0);
    }
  }
}
