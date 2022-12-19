import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tutorbin/getx/base_getx_controller.dart';
import 'package:tutorbin/menu/model/menu_model.dart';
import 'package:tutorbin/utils/constants.dart';
import 'package:tutorbin/utils/custom_snackbar.dart';
import 'package:tutorbin/utils/enums.dart';
import 'package:tutorbin/utils/firestore_functions.dart';
import 'package:tutorbin/utils/utils.dart';

class MenuScreenController extends BaseGetxCotroller {

  /// used to store category data load from json menu file
  Map<String, List<CategoryModel>> menuData = {};

  ///used to show error msg on screen
  RxString errorMsg = ''.obs;

  /// use to manage card data
  Map<String, CategoryModel> cartData = {};

  ///used to manage popular items
  List<CategoryModel> popularItem = [];

  ///used to manage best seller items
  List<String> bestSeller = [];

  ///fetch data from json file
  Future<void> getMenuData() async {
    try {
      Map<String, dynamic> data = await loadJsonFile(menuDataFilePath);
      data.forEach((key, value) {
        ///converting json data to category model object
        final list = List<CategoryModel>.from(
            value.map((e) => CategoryModel.fromMap(e)));

        /// filtering instock category only
        menuData[key] = list.where((i) => i.instock == true).toList();
      });
      widgetViewState.value = ViewWidgetState.WIDGET_VIEW_STATE;
    } catch (e) {
      errorMsg.value = e.toString();
      widgetViewState.value = ViewWidgetState.WIDGET_ERROR_STATE;
    }
  }

  /// to add and update cart
  void addToCart(CategoryModel data) async {
    try {
      if (cartData.containsKey(data.name)) {
        ///for item already present in cart then update item
        cartData.update(
          data.name,
          (value) => CategoryModel(
            name: value.name,
            instock: value.instock,
            price: value.price + data.price,
            quantity: value.quantity + 1,
          ),
        );
        showSnackBar('Success', 'Item updated in cart!');
      } else {
        /// for add new item in cart
        cartData.putIfAbsent(
          data.name,
          () => CategoryModel(
            name: data.name,
            price: data.price,
            instock: data.instock,
            quantity: 1,
          ),
        );
        showSnackBar('Success', 'Item added in cart!');
      }
      update();
    } catch (e) {
      showSnackBar('Error', e.toString());
    }
  }

  /// to get addition of all cart item price
  double getTotalCartValue() {
    double amount = 0;
    cartData.forEach((key, value) {
      amount += value.price;
    });
    return amount;
  }

  /// to remove item from cart
  void removeFromCart(CategoryModel data) async {
    try {
      CategoryModel? cardModelData = cartData[data.name];
      if ((cardModelData?.quantity ?? 1) > 1) {
        /// if cart contains more than one item then remove 1 item
        cartData.update(
          data.name,
          (value) => CategoryModel(
            name: value.name,
            instock: value.instock,
            price: value.price - data.price,
            quantity: value.quantity - 1,
          ),
        );
        showSnackBar('Success', 'Item updated in cart!');
      } else {
        ///if cart contain only one item them remove it
        cartData.remove(data.name);
        showSnackBar('Success', 'Item removed from cart!');
      }
      update();
    } catch (e) {
      showSnackBar('Error', e.toString());
    }
  }

  /// to place order
  void placeOrder() async {
    try {
      ///storing order data in firestore
      FirestoreFunctions.addOrder(cartData).then((value) async {
        showSnackBar('Success', 'Order Placed successfully!!');
        await Future.delayed(const Duration(seconds: 1));

        ///getting all updated orders list
        popularItem = await FirestoreFunctions.getUpdatedOrdersList();
        _getBestSeller();
        ///reset cart to empty
        cartData = {};
        update();
      });
    } catch (e) {
      showSnackBar('Error', e.toString());
    }
  }

  ///get all order list
  void getAllPopularItems() async {
    popularItem = await FirestoreFunctions.getUpdatedOrdersList();
    _getBestSeller();
    update();
  }

  void _getBestSeller() {
    if(popularItem.isEmpty){
      return;
    }
    if(popularItem.length == 1){
      popularItem[0].isBestSeller = true;
      bestSeller.add(popularItem[0].name);
    } else{
      int len = popularItem.length;
      if(len >= 3){
        for (int i = 0; i < 3; i++) {
          if(2 > i){
            if(popularItem[i].quantity > popularItem[i + 1].quantity ){
              popularItem[i].isBestSeller = true;
              bestSeller.add(popularItem[i].name);
              break;
            }else{
              popularItem[i].isBestSeller = true;
              popularItem[i + 1].isBestSeller = true;
              bestSeller.add(popularItem[i].name);
              bestSeller.add(popularItem[i + 1].name);
            }
          }
        }
      }else{
        if(popularItem[0].quantity > popularItem[1].quantity){
          popularItem[0].isBestSeller = true;
          bestSeller.add(popularItem[0].name);
        }else{
          popularItem[0].isBestSeller = true;
          popularItem[1].isBestSeller = true;
          bestSeller.add(popularItem[0].name);
          bestSeller.add(popularItem[1].name);
        }
      }
    }
  }
}
