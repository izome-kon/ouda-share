import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/repository/repository.dart';

import 'cubit.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit() : super(DiscoveryLoading());

  Future<void> onLoad() async {
    final result = await CategoryRepository.loadDiscovery();
    if (result != null) {
      emit(DiscoverySuccess(result));
    }
  }
}
