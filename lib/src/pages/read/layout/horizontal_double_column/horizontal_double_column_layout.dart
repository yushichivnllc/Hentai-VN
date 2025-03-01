import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhentai/src/model/read_page_info.dart';
import 'package:jhentai/src/pages/read/layout/horizontal_double_column/horizontal_double_column_layout_state.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../setting/read_setting.dart';
import '../base/base_layout.dart';
import 'horizontal_double_column_layout_logic.dart';

class HorizontalDoubleColumnLayout extends BaseLayout {
  HorizontalDoubleColumnLayout({Key? key}) : super(key: key);

  @override
  final HorizontalDoubleColumnLayoutLogic logic = Get.put<HorizontalDoubleColumnLayoutLogic>(HorizontalDoubleColumnLayoutLogic(), permanent: true);

  @override
  final HorizontalDoubleColumnLayoutState state = Get.find<HorizontalDoubleColumnLayoutLogic>().state;

  @override
  Widget buildBody(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: (readPageState.readPageInfo.pageCount + 1) ~/ 2,
      scrollPhysics: const ClampingScrollPhysics(),
      pageController: logic.pageController,
      cacheExtent: (ReadSetting.preloadPageCount.value.toDouble() + 1) / 2,
      reverse: ReadSetting.readDirection.value == ReadDirection.right2left,
      builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
        controller: state.photoViewControllers[index],
        initialScale: 1.0,
        minScale: 1.0,
        maxScale: 2.5,
        scaleStateCycle: ReadSetting.enableDoubleTapToScaleUp.isTrue ? logic.scaleStateCycle : null,
        enableDoubleTapZoom: ReadSetting.enableDoubleTapToScaleUp.isTrue,
        child: readPageState.readPageInfo.mode == ReadMode.online
            ? _buildDoubleColumnItemInOnlineMode(context, index)
            : _buildDoubleColumnItemInLocalMode(context, index),
      ),
    );
  }

  Widget _buildDoubleColumnItemInOnlineMode(BuildContext context, int pageIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ReadSetting.readDirection.value == ReadDirection.left2right) buildItemInOnlineMode(context, pageIndex * 2),
        if (ReadSetting.readDirection.value == ReadDirection.right2left && pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount)
          buildItemInOnlineMode(context, pageIndex * 2 + 1),
        if (pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount) SizedBox(width: ReadSetting.imageSpace.value.toDouble()),
        if (ReadSetting.readDirection.value == ReadDirection.left2right && pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount)
          buildItemInOnlineMode(context, pageIndex * 2 + 1),
        if (ReadSetting.readDirection.value == ReadDirection.right2left) buildItemInOnlineMode(context, pageIndex * 2),
      ],
    );
  }

  Widget _buildDoubleColumnItemInLocalMode(BuildContext context, int pageIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ReadSetting.readDirection.value == ReadDirection.left2right) buildItemInLocalMode(context, pageIndex * 2),
        if (ReadSetting.readDirection.value == ReadDirection.right2left && pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount)
          buildItemInLocalMode(context, pageIndex * 2 + 1),
        if (pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount) SizedBox(width: ReadSetting.imageSpace.value.toDouble()),
        if (ReadSetting.readDirection.value == ReadDirection.left2right && pageIndex * 2 + 1 < readPageState.readPageInfo.pageCount)
          buildItemInLocalMode(context, pageIndex * 2 + 1),
        if (ReadSetting.readDirection.value == ReadDirection.right2left) buildItemInLocalMode(context, pageIndex * 2),
      ],
    );
  }
}
