import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/models/model.dart';

enum ProductViewType { small, grid, list, block, card }

enum DetailViewType { basic }

final mapListMode = {
  'small': ProductViewType.small,
  'list': ProductViewType.list,
  'grid': ProductViewType.grid,
  'block': ProductViewType.block,
  'card': ProductViewType.card,
};

final detailMode = {
  'default': DetailViewType.basic,
};

class SettingModel {
  final List<CategoryModel> category;
  final List<CategoryModel> features;
  final List<CategoryModel> locations;
  final List<SortModel> sort;
  final int perPage;
  final ProductViewType listMode;
  final DetailViewType detailViewType;
  final bool enableSubmit;
  final double minPrice;
  final double maxPrice;
  final List<String> color;
  final String unit;
  final TimeOfDay startHour;
  final TimeOfDay endHour;
  final bool useViewAddress;
  final bool useViewPhone;
  final bool useViewEmail;
  final bool useViewWebsite;
  final bool useViewSocial;
  final bool useViewStatus;
  final bool useViewDateEstablish;
  final bool useViewGalleries;
  final bool useViewAttachment;
  final bool useViewVideo;
  final bool useViewMap;
  final bool useViewPrice;
  final bool useViewOpenHours;
  final bool useViewTags;
  final bool useViewFeature;
  final bool useViewAdmob;

  SettingModel({
    required this.category,
    required this.features,
    required this.locations,
    required this.sort,
    required this.perPage,
    required this.listMode,
    required this.detailViewType,
    required this.enableSubmit,
    required this.minPrice,
    required this.maxPrice,
    required this.color,
    required this.unit,
    required this.startHour,
    required this.endHour,
    required this.useViewAddress,
    required this.useViewPhone,
    required this.useViewEmail,
    required this.useViewWebsite,
    required this.useViewSocial,
    required this.useViewStatus,
    required this.useViewDateEstablish,
    required this.useViewGalleries,
    required this.useViewAttachment,
    required this.useViewVideo,
    required this.useViewMap,
    required this.useViewPrice,
    required this.useViewOpenHours,
    required this.useViewTags,
    required this.useViewFeature,
    required this.useViewAdmob,
  });

  factory SettingModel.fromDefault() {
    return SettingModel(
      category: [],
      features: [],
      locations: [],
      sort: [],
      perPage: 20,
      listMode: ProductViewType.list,
      detailViewType: DetailViewType.basic,
      enableSubmit: true,
      minPrice: 0.0,
      maxPrice: 100.0,
      color: [],
      unit: 'USD',
      startHour: const TimeOfDay(hour: 8, minute: 0),
      endHour: const TimeOfDay(hour: 15, minute: 0),
      useViewAddress: true,
      useViewPhone: true,
      useViewEmail: true,
      useViewWebsite: true,
      useViewSocial: true,
      useViewStatus: true,
      useViewDateEstablish: true,
      useViewGalleries: true,
      useViewAttachment: true,
      useViewVideo: true,
      useViewMap: true,
      useViewPrice: true,
      useViewOpenHours: true,
      useViewTags: true,
      useViewFeature: true,
      useViewAdmob: true,
    );
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    final settings = json['settings'] ?? {};
    final viewOptions = json['view_option'] ?? {};
    final settingDetailView = settings['mobile_listing_view'];

    TimeOfDay? startHour;
    TimeOfDay? endHour;
    if (settings['time_min'] != null) {
      List<String> split = settings['time_min'].split(':');
      startHour = TimeOfDay(
        hour: int.tryParse(split[0]) ?? 0,
        minute: int.tryParse(split[1]) ?? 0,
      );
    }
    if (settings['time_max'] != null) {
      List<String> split = settings['time_max'].split(':');
      endHour = TimeOfDay(
        hour: int.tryParse(split[0]) ?? 0,
        minute: int.tryParse(split[1]) ?? 0,
      );
    }

    return SettingModel(
      category: List.from(json['categories'] ?? []).map((e) {
        return CategoryModel.fromJson(e);
      }).toList(),
      features: List.from(json['features'] ?? []).map((e) {
        return CategoryModel.fromJson(e);
      }).toList(),
      locations: List.from(json['locations'] ?? []).map((e) {
        return CategoryModel.fromJson(e);
      }).toList(),
      sort: List.from(json['place_sort_option'] ?? []).map((item) {
        return SortModel.fromJson(item);
      }).toList(),
      perPage: settings['per_page'] ?? 20,
      listMode: mapListMode[settings['list_mode']] ?? ProductViewType.list,
      detailViewType: detailMode[settingDetailView] ?? DetailViewType.basic,
      enableSubmit: settings['submit_listing'] ?? true,
      minPrice: double.tryParse('${settings['price_min']}') ?? 0.0,
      maxPrice: double.tryParse('${settings['price_max']}') ?? 100.0,
      color: settings['color_option'].cast<String>() ?? [],
      unit: settings['unit_price'] ?? 'USD',
      startHour: startHour ?? const TimeOfDay(hour: 8, minute: 0),
      endHour: endHour ?? const TimeOfDay(hour: 15, minute: 0),
      useViewAddress: viewOptions['view_address_use'] ?? true,
      useViewPhone: viewOptions['view_phone_use'] ?? true,
      useViewEmail: viewOptions['view_email_use'] ?? true,
      useViewWebsite: viewOptions['view_website_use'] ?? true,
      useViewSocial: viewOptions['social_network_use'] ?? true,
      useViewStatus: viewOptions['view_status_use'] ?? true,
      useViewDateEstablish: viewOptions['view_date_establish_use'] ?? true,
      useViewGalleries: viewOptions['view_galleries_use'] ?? true,
      useViewAttachment: viewOptions['view_attachment_use'] ?? true,
      useViewVideo: viewOptions['view_video_url_use'] ?? true,
      useViewMap: viewOptions['view_map_use'] ?? true,
      useViewPrice: viewOptions['view_price_use'] ?? true,
      useViewOpenHours: viewOptions['view_opening_hour_use'] ?? true,
      useViewTags: viewOptions['view_tags_use'] ?? true,
      useViewFeature: viewOptions['view_feature_use'] ?? true,
      useViewAdmob: viewOptions['view_admob_use'] ?? true,
    );
  }
}
