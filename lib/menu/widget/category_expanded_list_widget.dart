import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorbin/menu/model/menu_model.dart';
import 'package:tutorbin/utils/custom_text_styles.dart';

import '../controller/menu_screen_controller.dart';

class CategoryExpandedListWidget extends StatelessWidget {
  final String title;
  final int subCategoriesLen;
  final List<CategoryModel> subCategoryList;
  final bool isPopularItem;
  CategoryExpandedListWidget({Key? key, required this.title,required this.subCategoriesLen, required this.subCategoryList, this.isPopularItem = false}) : super(key: key);

  final MenuScreenController _menuScreenController = Get.find<MenuScreenController>();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: st20ptBold(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$subCategoriesLen  ',
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500),
          ),
          Icon(
            Icons.keyboard_arrow_down_sharp,
            size: 35,
            color: Colors.grey.shade400,
          )
        ],
      ),
      children: <Widget>[
        ...List.generate(
          subCategoriesLen,
              (index) {
            CategoryModel category =
            subCategoryList[index];
            return Container(
              color: Colors.grey.shade200,
              margin: const EdgeInsets.only(left: 20),
              padding:
              const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.w400),
                                ),
                                if (category.isBestSeller || _menuScreenController.bestSeller.contains(category.name))
                                  const SizedBox(width: 15),
                                if (category.isBestSeller || _menuScreenController.bestSeller.contains(category.name))
                                  Container(
                                    padding:
                                    const EdgeInsets
                                        .all(5),
                                    alignment:
                                    Alignment.center,
                                    decoration:
                                    BoxDecoration(
                                      color:
                                      Colors.redAccent,
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                    ),
                                    child: Text(
                                      'Best Seller',
                                      style: st13pt500w(
                                          color:
                                          Colors.white),
                                    ),
                                  )
                              ],
                            ),
                            Text(
                              "\$ ${isPopularItem ? (category.price / category.quantity ) :category.price}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                  Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      if (!_menuScreenController.cartData.containsKey(category.name))
                        InkWell(
                          onTap: () {
                            _menuScreenController.addToCart(category);
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.orange),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Add',
                              style: st13pt500w(
                                  color: Colors.orange),
                            ),
                          ),
                        ),
                      if (_menuScreenController.cartData.containsKey(category.name))
                        Container(
                          width: 100,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.orange),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  _menuScreenController.removeFromCart(category);
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.orange,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets
                                    .symmetric(
                                    horizontal: 5),
                                alignment: Alignment.center,
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                    BorderRadius
                                        .circular(20)),
                                child: Text(
                                  "${_menuScreenController.cartData[category.name]?.quantity}",
                                  style: st15ptBold(
                                      color: Colors.white),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _menuScreenController.addToCart(category);
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                      const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider()
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
