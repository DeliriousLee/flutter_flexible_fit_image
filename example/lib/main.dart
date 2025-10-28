import 'package:flexible_fit_image/flexible_fit_image.dart';
import 'package:flutter/material.dart';

void main() {
  double width = 200;
  double height = 300;

  /// 默认的按等比 撑满容器
  BoxFit _defaultRatioFillFit(Size originSize) {
    double windowRatio = 1.0;
    if (width != null && height != null && height != 0) {
      windowRatio = width / height;
    }
    double imgOriginRatio = originSize.width / originSize.height;
    // 图片比显示 扁
    if (imgOriginRatio > windowRatio) {
      return BoxFit.fitHeight;
    } else {
      // 图片比显示 窄
      return BoxFit.fitWidth;
    }
  }

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('FlexibleFitImage Example')),
      body: Center(
        child: FlexibleFitImage(
          imageUrl: 'https://www.example.com/image.jpg',
          width: 300,
          height: 200,
          selectFit: _defaultRatioFillFit, // 使用 _defaultRatioFillFit 函数
          borderRadius: 10,
        ),
      ),
    ),
  ));
}
