import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';

import 'cubit.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading());
  List<CategoryModel> list = [];

  Future<void> onLoad({CategoryModel? item, required String keyword}) async {
    if (keyword.isEmpty) {
      final result = await CategoryRepository.loadCategory(id: item?.id);
      if (result != null) {
        list = result;
      }

      ///Notify
      emit(CategorySuccess(list.where((item) {
        return item.title.toUpperCase().contains(keyword.toUpperCase());
      }).toList()));
    } else {
      if (list.isEmpty) {
        final result = await CategoryRepository.loadCategory();
        if (result != null) {
          list = result;
        }
      }

      ///Notify
      emit(CategorySuccess(list.where((item) {
        return item.title.toUpperCase().contains(keyword.toUpperCase());
      }).toList()));
    }
  }
}
