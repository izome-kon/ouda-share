import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({Key? key}) : super(key: key);

  @override
  _BookingManagementState createState() {
    return _BookingManagementState();
  }
}

class _BookingManagementState extends State<BookingManagement>
    with SingleTickerProviderStateMixin {
  final _bookingManagement = BookingManagementCubit();
  final _textSearchController = TextEditingController();
  final _scrollController = ScrollController();
  final _endReachedThreshold = 100;

  Timer? _timer;
  SortModel? _sortBooking;
  SortModel? _sortRequest;
  SortModel? _statusBooking;
  SortModel? _statusRequest;
  TabController? _tabController;
  int _indexTab = 0;

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _bookingManagement.close();
    _textSearchController.clear();
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    final request = _indexTab == 1;
    return await _bookingManagement.onLoad(
      sort: request ? _sortRequest : _sortBooking,
      status: request ? _statusRequest : _statusBooking,
      keyword: _textSearchController.text,
      request: _indexTab == 1,
    );
  }

  ///On Change Tab
  void _onTap(int index) {
    setState(() {
      _indexTab = index;
    });
    _onRefresh();
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = _bookingManagement.state;
    if (state is BookingListSuccess) {
      final request = _indexTab == 1;
      final canLoadMore =
          request ? state.canLoadMoreRequest : state.canLoadMoreBooking;
      final loadingMore =
          request ? state.loadingMoreRequest : state.loadingMoreBooking;
      if (canLoadMore && !loadingMore) {
        _bookingManagement.onLoadMore(
          sort: request ? _sortRequest : _sortBooking,
          status: request ? _statusRequest : _statusBooking,
          keyword: _textSearchController.text,
          request: _indexTab == 1,
        );
      }
    }
  }

  ///On Search
  void _onSearch(String? keyword) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      final request = _indexTab == 1;
      _bookingManagement.onLoad(
        sort: request ? _sortRequest : _sortBooking,
        status: request ? _statusRequest : _statusBooking,
        keyword: keyword,
        request: _indexTab == 1,
      );
    });
  }

  ///On Sort Booking
  void _onSortBooking() async {
    if (_bookingManagement.sortOptionBooking.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_sortBooking],
            data: _bookingManagement.sortOptionBooking,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _sortBooking = result;
      });
      _onRefresh();
    }
  }

  ///On Sort Booking
  void _onSortRequest() async {
    if (_bookingManagement.sortOptionRequest.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_sortRequest],
            data: _bookingManagement.sortOptionRequest,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _sortRequest = result;
      });
      _onRefresh();
    }
  }

  ///On Filter Booking
  void _onFilterBooking() async {
    if (_bookingManagement.statusOptionBooking.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_statusBooking],
            data: _bookingManagement.statusOptionBooking,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _statusBooking = result;
      });
      _onRefresh();
    }
  }

  ///On Filter Booking
  void _onFilterRequest() async {
    if (_bookingManagement.statusOptionRequest.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_statusRequest],
            data: _bookingManagement.statusOptionRequest,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _statusRequest = result;
      });
      _onRefresh();
    }
  }

  ///On Detail Booking
  void _onDetail(BookingItemModel item) {
    Navigator.pushNamed(
      context,
      Routes.bookingDetail,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = _indexTab == 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('booking_management')),
      ),
      body: BlocBuilder<BookingManagementCubit, BookingManagementState>(
        bloc: _bookingManagement,
        builder: (context, state) {
          Widget content = ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              return const AppBookingItem();
            },
            itemCount: 15,
          );
          if (state is BookingListSuccess) {
            List<BookingItemModel> list = state.listBooking;
            bool loadingMore = state.loadingMoreBooking;
            if (request) {
              list = state.listRequest;
              loadingMore = state.loadingMoreRequest;
            }
            if (list.isEmpty) {
              content = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context).translate(
                          'data_not_found',
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              int count = list.length;
              if (loadingMore) {
                count = count + 1;
              }
              content = RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  itemBuilder: (context, index) {
                    ///Loading loadMore item
                    if (index == list.length) {
                      return const AppBookingItem();
                    }
                    final item = list[index];
                    return AppBookingItem(
                      item: item,
                      onPressed: () {
                        _onDetail(item);
                      },
                    );
                  },
                  itemCount: count,
                ),
              );
            }
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  TabBar(
                    indicatorWeight: 2.0,
                    controller: _tabController,
                    tabs: [
                      Tab(text: Translate.of(context).translate('my_booking')),
                      Tab(
                        text: Translate.of(context).translate(
                          'request_booking',
                        ),
                      ),
                    ],
                    onTap: _onTap,
                    labelColor: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    hintText: Translate.of(context).translate('search'),
                    controller: _textSearchController,
                    onChanged: _onSearch,
                    onSubmitted: _onSearch,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: request ? _onFilterRequest : _onFilterBooking,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.track_changes_outlined,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Translate.of(context).translate('filter'),
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: request ? _onSortRequest : _onSortBooking,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.sort_outlined,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Translate.of(context).translate('sort'),
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(child: content),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
