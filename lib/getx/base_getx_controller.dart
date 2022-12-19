import 'package:get/get.dart';
import 'package:tutorbin/utils/enums.dart';

class BaseGetxCotroller extends GetxController {

  ///common for all screens, used for manage screen states
  Rx<ViewWidgetState> widgetViewState = ViewWidgetState.WIDGET_LOADING_STATE.obs;

}