import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/screens/home/search_bar.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class Discovery extends StatefulWidget {
  const Discovery({Key? key}) : super(key: key);

  @override
  _DiscoveryState createState() {
    return _DiscoveryState();
  }
}

class _DiscoveryState extends State<Discovery> {
  final _discoveryCubit = DiscoveryCubit();
  late StreamSubscription _submitSubscription;

  @override
  void initState() {
    super.initState();
    _discoveryCubit.onLoad();
    _submitSubscription = AppBloc.submitCubit.stream.listen((state) {
      if (state is Submitted) {
        _onRefresh();
      }
    });
  }

  @override
  void dispose() {
    _submitSubscription.cancel();
    _discoveryCubit.close();
    super.dispose();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await _discoveryCubit.onLoad();
  }

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory);
  }

  ///On navigate list product
  void _onProductList(CategoryModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).hoverColor,
            child: Column(
              children: [
                const SizedBox(height: 16),
                MySearchBar(
                  onSearch: _onSearch,
                  onScan: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
              bloc: _discoveryCubit,
              builder: (context, discovery) {
                ///Loading
                Widget content = SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const AppDiscoveryItem();
                    },
                    childCount: 15,
                  ),
                );

                ///Success
                if (discovery is DiscoverySuccess) {
                  if (discovery.list.isEmpty) {
                    content = SliverFillRemaining(
                      child: Center(
                        child: Text(
                          Translate.of(context).translate(
                            'can_not_found_data',
                          ),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    );
                  } else {
                    content = SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = discovery.list[index];
                          return AppDiscoveryItem(
                            item: item,
                            onSeeMore: _onProductList,
                            onProductDetail: _onProductDetail,
                          );
                        },
                        childCount: discovery.list.length,
                      ),
                    );
                  }
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    CupertinoSliverRefreshControl(
                      onRefresh: _onRefresh,
                    ),
                    SliverSafeArea(
                      top: false,
                      sliver: SliverPadding(
                        padding: const EdgeInsets.only(top: 8, bottom: 28),
                        sliver: content,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
