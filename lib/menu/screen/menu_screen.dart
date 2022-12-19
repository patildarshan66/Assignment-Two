import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorbin/menu/controller/menu_screen_controller.dart';
import 'package:tutorbin/menu/model/menu_model.dart';
import 'package:tutorbin/menu/widget/category_expanded_list_widget.dart';
import 'package:tutorbin/utils/custom_text_styles.dart';
import 'package:tutorbin/utils/enums.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuScreenController _menuScreenController =
      Get.put(MenuScreenController());

  @override
  void initState() {
    _menuScreenController.getAllPopularItems();
    _menuScreenController.getMenuData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All Menu'),
        centerTitle: true,
      ),
      body: Obx(() => _getBody()),
    );
  }

  _getBody() {
    if (_menuScreenController.widgetViewState.value ==
        ViewWidgetState.WIDGET_VIEW_STATE) {
      return GetBuilder(
          init: _menuScreenController,
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      if (_menuScreenController.popularItem.isNotEmpty &&
                          i == 0) {
                        int popularItemsLen =
                            _menuScreenController.popularItem.length >= 3
                                ? 3
                                : _menuScreenController.popularItem.length;
                        return CategoryExpandedListWidget(
                          title: 'Popular Items',
                          subCategoriesLen: popularItemsLen,
                          subCategoryList: _menuScreenController.popularItem,
                        );
                      }
                      String key = _menuScreenController.popularItem.isNotEmpty
                          ? _menuScreenController.menuData.keys.toList()[i - 1]
                          : _menuScreenController.menuData.keys.toList()[i];
                      List<CategoryModel> itemList = _menuScreenController
                              .popularItem.isNotEmpty
                          ? _menuScreenController.menuData.values
                              .toList()[i - 1]
                          : _menuScreenController.menuData.values.toList()[i];
                      return CategoryExpandedListWidget(
                        subCategoryList: itemList,
                        title: key,
                        subCategoriesLen: itemList.length,
                      );
                    },
                    itemCount: _menuScreenController.menuData.length +
                        (_menuScreenController.popularItem.isNotEmpty ? 1 : 0),
                  ),
                ),
                if (_menuScreenController.getTotalCartValue() > 0)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        minimumSize: const Size.fromHeight(
                          50,
                        ),
                      ),
                      onPressed: () {
                        _menuScreenController.placeOrder();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Place Order', style: st20ptBold()),
                          const SizedBox(width: 50),
                          Text(
                            '\$ ${_menuScreenController.getTotalCartValue()}',
                            style: st20ptBold(),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            );
          });
    } else if (_menuScreenController.widgetViewState.value ==
        ViewWidgetState.WIDGET_LOADING_STATE) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Text(
          _menuScreenController.errorMsg.value,
          style: st13pt500w(),
        ),
      );
    }
  }
}
