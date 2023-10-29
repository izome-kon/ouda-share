import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/utils/utils.dart';
import 'package:listar_flutter_pro/widgets/widget.dart';

class ProfileTab extends SliverPersistentHeaderDelegate {
  final double height;
  final bool showFilter;
  final List<Widget> tabs;
  final TabController? tabController;
  final Function(int) onTap;
  final TextEditingController textSearchController;
  final Function(String) onSearch;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  ProfileTab({
    required this.height,
    required this.showFilter,
    this.tabController,
    required this.tabs,
    required this.onTap,
    required this.textSearchController,
    required this.onSearch,
    required this.onFilter,
    required this.onSort,
  });

  ///Build Action Filter and Sort
  Widget _buildAction(BuildContext context) {
    if (showFilter) {
      return Row(
        children: [
          InkWell(
            onTap: onFilter,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onSort,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Row(
      children: [
        InkWell(
          onTap: onSort,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      height: height,
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 4),
              TabBar(
                indicatorWeight: 2.0,
                controller: tabController,
                tabs: tabs,
                onTap: onTap,
                labelColor: Theme.of(context).textTheme.button?.color,
              ),
              const SizedBox(height: 16),
              AppTextInput(
                hintText: Translate.of(context).translate('search'),
                controller: textSearchController,
                onChanged: onSearch,
                onSubmitted: onSearch,
              ),
              const SizedBox(height: 16),
              _buildAction(context),
            ],
          ),
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
