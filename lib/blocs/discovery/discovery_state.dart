import 'package:listar_flutter_pro/models/model.dart';

abstract class DiscoveryState {}

class DiscoveryLoading extends DiscoveryState {}

class DiscoverySuccess extends DiscoveryState {
  final List<DiscoveryModel> list;
  DiscoverySuccess(this.list);
}
