import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';
import 'package:listar_flutter_pro/utils/utils.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event load user
    UserModel? user = await AppBloc.userCubit.onLoadUser();

    if (user != null) {
      ///Attach token push
      Application.device?.token = await Utils.getDeviceToken();

      ///Save user
      await AppBloc.userCubit.onSaveUser(user);

      ///Valid token server
      final result = await UserRepository.validateToken();

      if (result) {
        ///Load wishList
        AppBloc.wishListCubit.onLoad();

        ///Fetch user
        AppBloc.userCubit.onFetchUser();

        ///Notify
        emit(AuthenticationState.success);
      } else {
        ///Logout
        onClear();
      }
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onSave(UserModel user) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event Save user
    await AppBloc.userCubit.onSaveUser(user);

    ///Load wishList
    AppBloc.wishListCubit.onLoad();

    /// Notify
    emit(AuthenticationState.success);
  }

  void onClear() {
    /// Notify
    emit(AuthenticationState.fail);

    ///Delete user
    AppBloc.userCubit.onDeleteUser();
  }
}
