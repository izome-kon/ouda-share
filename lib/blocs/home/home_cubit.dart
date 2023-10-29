import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/api/api.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> onLoad() async {
    ///Fetch API Home
    final response = await Api.requestHome();
    if (response.success) {
      final banner = List<String>.from(response.data['sliders'] ?? []);

      final category = List.from(response.data['categories'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      final location = List.from(response.data['locations'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      final recent = List.from(response.data['recent_posts'] ?? []).map((item) {
        return ProductModel.fromJson(
          item,
          setting: Application.setting,
        );
      }).toList();

      ///Notify
      emit(HomeSuccess(
        banner: banner,
        category: category,
        location: location,
        recent: recent,
      ));
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
  }
}
