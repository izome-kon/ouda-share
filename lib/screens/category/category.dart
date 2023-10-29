import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class Category extends StatefulWidget {
  final CategoryModel? item;
  const Category({Key? key, this.item}) : super(key: key);

  @override
  _CategoryState createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<Category> {
  final _categoryCubit = CategoryCubit();
  final _textController = TextEditingController();

  CategoryView _type = CategoryView.full;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    _categoryCubit.close();
    _textController.dispose();
    super.dispose();
  }

  ///On refresh list
  Future<void> _onRefresh() async {
    await _categoryCubit.onLoad(
      item: widget.item,
      keyword: _textController.text,
    );
  }

  ///On select category
  void _onCategory(CategoryModel item) {
    if (item.hasChild) {
      Navigator.pushNamed(context, Routes.category, arguments: item);
    } else {
      Navigator.pushNamed(context, Routes.listProduct, arguments: item);
    }
  }

  ///On change mode view
  void _onChangeModeView() {
    switch (_type) {
      case CategoryView.full:
        setState(() {
          _type = CategoryView.icon;
        });
        break;
      case CategoryView.icon:
        setState(() {
          _type = CategoryView.full;
        });
        break;
      default:
        break;
    }
  }

  ///On Search Category
  void _onSearch(String text) {
    _onRefresh();
  }

  ///Export icon
  IconData _exportIcon(CategoryView type) {
    switch (type) {
      case CategoryView.icon:
        return Icons.view_headline;
      default:
        return Icons.view_agenda_outlined;
    }
  }

  ///Build content list
  Widget _buildContent(List<CategoryModel>? category) {
    ///Success
    if (category != null) {
      ///Empty
      if (category.isEmpty) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.sentiment_satisfied),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  Translate.of(context).translate(
                    'category_not_found',
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: category.length,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (context, index) {
            final item = category[index];
            return AppCategory(
              type: _type,
              item: item,
              onPressed: () {
                _onCategory(item);
              },
            );
          },
        ),
      );
    }

    ///Loading
    return ListView.separated(
      itemCount: List.generate(8, (index) => index).length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return AppCategory(type: _type);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? title;
    if (widget.item?.title != null) {
      title = widget.item?.title;
    }
    return BlocProvider(
      create: (context) => _categoryCubit,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          List<CategoryModel>? category;
          if (state is CategorySuccess) {
            category = state.list;
          }
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                title ?? Translate.of(context).translate('category'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    _exportIcon(_type),
                  ),
                  onPressed: _onChangeModeView,
                )
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    AppTextInput(
                      hintText: Translate.of(context).translate('search'),
                      controller: _textController,
                      onSubmitted: _onSearch,
                      onChanged: _onSearch,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildContent(category),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
