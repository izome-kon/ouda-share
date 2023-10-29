import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailLoading());
  ProductModel? product;

  void onLoad(int id) async {
    final result = await ListRepository.loadProduct(id);
    if (result != null) {
      product = result;
      emit(ProductDetailSuccess(product!));
    }
  }

  void onFavorite() {
    if (product != null) {
      product!.favorite = !product!.favorite;
      emit(ProductDetailSuccess(product!));
      if (product!.favorite) {
        AppBloc.wishListCubit.onAdd(product!.id);
      } else {
        AppBloc.wishListCubit.onRemove(product!.id);
      }
    }
  }
}
