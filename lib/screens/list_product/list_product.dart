import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class ListProduct extends StatefulWidget {
  final CategoryModel category;

  const ListProduct({Key? key, required this.category}) : super(key: key);

  @override
  _ListProductState createState() {
    return _ListProductState();
  }
}

class _ListProductState extends State<ListProduct> {
  final _listCubit = ListCubit();
  final _swipeController = SwiperController();
  final _scrollController = ScrollController();
  final _endReachedThreshold = 100;

  late StreamSubscription _wishlistSubscription;
  late StreamSubscription _reviewSubscription;

  GoogleMapController? _mapController;
  ProductModel? _currentItem;
  MapType _mapType = MapType.normal;
  PageType _pageType = PageType.list;
  ProductViewType _listMode = Application.setting.listMode;

  FilterModel _filter = FilterModel.fromDefault();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.category.type == CategoryType.category) {
      _filter.categories.add(widget.category);
    }
    if (widget.category.type == CategoryType.feature) {
      _filter.features.add(widget.category);
    }
    if (widget.category.type == CategoryType.location) {
      _filter.city = widget.category;
    }
    _wishlistSubscription = AppBloc.wishListCubit.stream.listen((state) {
      if (state is WishListSuccess && state.updateID != null) {
        _listCubit.onUpdate(state.updateID!);
      }
    });
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewSuccess && state.id != null) {
        _listCubit.onUpdate(state.id!);
      }
    });
    _onRefresh();
  }

  @override
  void dispose() {
    _wishlistSubscription.cancel();
    _reviewSubscription.cancel();
    _swipeController.dispose();
    _scrollController.dispose();
    _mapController?.dispose();
    _listCubit.close();
    super.dispose();
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = _listCubit.state;
    if (state is ListSuccess && state.canLoadMore && !state.loadingMore) {
      _listCubit.onLoadMore(_filter);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await _listCubit.onLoad(_filter);
  }

  ///On Change Sort
  void _onChangeSort() async {
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_filter.sort],
            data: Application.setting.sort,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _filter.sort = result;
      });
      _onRefresh();
    }
  }

  ///On Change View
  void _onChangeView() {
    ///Icon for MapType
    if (_pageType == PageType.map) {
      switch (_mapType) {
        case MapType.normal:
          _mapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _mapType = MapType.normal;
          break;
        default:
          _mapType = MapType.normal;
          break;
      }
    }

    switch (_listMode) {
      case ProductViewType.grid:
        _listMode = ProductViewType.list;
        break;
      case ProductViewType.list:
        _listMode = ProductViewType.block;
        break;
      case ProductViewType.block:
        _listMode = ProductViewType.grid;
        break;
      default:
        return;
    }
    setState(() {
      _listMode = _listMode;
      _mapType = _mapType;
    });
  }

  ///On change filter
  void _onChangeFilter() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.filter,
      arguments: _filter.clone(),
    );
    if (result != null && result is FilterModel) {
      setState(() {
        _filter = result;
      });
      _onRefresh();
    }
  }

  ///On change page
  void _onChangePageStyle() {
    switch (_pageType) {
      case PageType.list:
        setState(() {
          _pageType = PageType.map;
        });
        return;
      case PageType.map:
        setState(() {
          _pageType = PageType.list;
        });
        return;
    }
  }

  ///On tap marker map location
  void _onSelectLocation(int index) {
    _swipeController.move(index);
  }

  ///Handle Index change list map view
  void _onIndexChange(ProductModel item) {
    setState(() {
      _currentItem = item;
    });
    if (item.location != null) {
      ///Camera animated
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              item.location!.latitude!,
              item.location!.longitude!,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  ///On focus current location
  void _onCurrentLocation() {
    // if (currentLocation != null) {
    //   _mapController?.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: LatLng(
    //           currentLocation.latitude,
    //           currentLocation.longitude,
    //         ),
    //         zoom: 15,
    //       ),
    //     ),
    //   );
    // }
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    ///Icon for MapType
    if (_pageType == PageType.map) {
      switch (_mapType) {
        case MapType.normal:
          return Icons.satellite;
        case MapType.hybrid:
          return Icons.map;
        default:
          return Icons.help;
      }
    }

    ///Icon for ListView Mode
    switch (_listMode) {
      case ProductViewType.list:
        return Icons.view_list;
      case ProductViewType.grid:
        return Icons.view_quilt;
      case ProductViewType.block:
        return Icons.view_array;
      default:
        return Icons.help;
    }
  }

  ///_build Item
  Widget _buildItem({
    ProductModel? item,
    required ProductViewType type,
  }) {
    switch (type) {
      case ProductViewType.list:
        if (item != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppProductItem(
              onPressed: () {
                _onProductDetail(item);
              },
              item: item,
              type: _listMode,
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppProductItem(
            type: _listMode,
          ),
        );
      default:
        if (item != null) {
          return AppProductItem(
            onPressed: () {
              _onProductDetail(item);
            },
            item: item,
            type: _listMode,
          );
        }
        return AppProductItem(
          type: _listMode,
        );
    }
  }

  ///Build Content Page Style
  Widget _buildContent() {
    return BlocBuilder<ListCubit, ListState>(
      builder: (context, state) {
        /// List Style
        if (_pageType == PageType.list) {
          Widget contentList = ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildItem(type: _listMode),
              );
            },
            itemCount: 8,
          );
          if (_listMode == ProductViewType.grid) {
            final size = MediaQuery.of(context).size;
            final left = MediaQuery.of(context).padding.left;
            final right = MediaQuery.of(context).padding.right;
            const itemHeight = 220;
            final itemWidth = (size.width - 48 - left - right) / 2;
            final ratio = itemWidth / itemHeight;
            contentList = GridView.count(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: ratio,
              children: List.generate(8, (index) => index).map((item) {
                return _buildItem(type: _listMode);
              }).toList(),
            );
          }

          ///Build List
          if (state is ListSuccess) {
            List list = List.from(state.list);
            if (state.loadingMore) {
              list.add(null);
            }
            contentList = RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildItem(item: item, type: _listMode),
                  );
                },
                itemCount: list.length,
              ),
            );
            if (_listMode == ProductViewType.grid) {
              final size = MediaQuery.of(context).size;
              final left = MediaQuery.of(context).padding.left;
              final right = MediaQuery.of(context).padding.right;
              const itemHeight = 220;
              final itemWidth = (size.width - 48 - left - right) / 2;
              final ratio = itemWidth / itemHeight;
              contentList = RefreshIndicator(
                onRefresh: _onRefresh,
                child: GridView.count(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: ratio,
                  children: list.map((item) {
                    return _buildItem(item: item, type: _listMode);
                  }).toList(),
                ),
              );
            }

            ///Build List empty
            if (state.list.isEmpty) {
              contentList = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context).translate('list_is_empty'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          /// List
          return SafeArea(child: contentList);
        }

        ///Build Map
        if (state is ListSuccess) {
          ///Default value map
          CameraPosition initPosition = const CameraPosition(
            target: LatLng(
              40.697403,
              -74.1201063,
            ),
            zoom: 14.4746,
          );
          Map<MarkerId, Marker> markers = {};

          ///Not build swipe and action when empty
          Widget list = Container();

          ///Build swipe if list not empty
          if (state.list.isNotEmpty) {
            if (state.list[0].location != null) {
              initPosition = CameraPosition(
                target: LatLng(
                  state.list[0].location!.latitude!,
                  state.list[0].location!.longitude!,
                ),
                zoom: 14.4746,
              );
            }

            ///Setup list marker map from list
            for (var item in state.list) {
              if (item.location != null) {
                final markerId = MarkerId(item.id.toString());
                final marker = Marker(
                  markerId: markerId,
                  position: LatLng(
                    item.location!.latitude!,
                    item.location!.longitude!,
                  ),
                  infoWindow: InfoWindow(title: item.title),
                  onTap: () {
                    _onSelectLocation(state.list.indexOf(item));
                  },
                );
                markers[markerId] = marker;
              }
            }

            ///build list map
            list = SafeArea(
              bottom: false,
              top: false,
              child: Container(
                height: 210,
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            heroTag: 'location',
                            mini: true,
                            onPressed: _onCurrentLocation,
                            backgroundColor: Theme.of(context).cardColor,
                            child: Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Swiper(
                        itemBuilder: (context, index) {
                          final ProductModel item = state.list[index];
                          bool selected = _currentItem == item;
                          if (index == 0 && _currentItem == null) {
                            selected = true;
                          }
                          return Container(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: selected
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).dividerColor,
                                    blurRadius: 4,
                                    spreadRadius: 1.0,
                                    offset: const Offset(1.5, 1.5),
                                  )
                                ],
                              ),
                              child: AppProductItem(
                                onPressed: () {
                                  _onProductDetail(item);
                                },
                                item: item,
                                type: ProductViewType.list,
                              ),
                            ),
                          );
                        },
                        controller: _swipeController,
                        onIndexChanged: (index) {
                          final item = state.list[index];
                          _onIndexChange(item);
                        },
                        itemCount: state.list.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          ///build Map
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                mapType: _mapType,
                initialCameraPosition: initPosition,
                markers: Set<Marker>.of(markers.values),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
              list
            ],
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData iconAction = Icons.map;
    if (_pageType == PageType.map) {
      iconAction = Icons.view_compact;
    }
    return BlocProvider(
      create: (context) => _listCubit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context).translate('listing')),
          actions: <Widget>[
            BlocBuilder<ListCubit, ListState>(
              builder: (context, state) {
                return Visibility(
                  visible: state is ListSuccess,
                  child: IconButton(
                    icon: Icon(iconAction),
                    onPressed: _onChangePageStyle,
                  ),
                );
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            AppNavBar(
              currentSort: _filter.sort,
              onChangeSort: _onChangeSort,
              iconModeView: _exportIconView(),
              onChangeView: _onChangeView,
              onFilter: _onChangeFilter,
            ),
            Expanded(
              child: _buildContent(),
            )
          ],
        ),
      ),
    );
  }
}
