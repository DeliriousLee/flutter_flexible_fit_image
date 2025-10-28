import 'package:flexible_fit_image/flexible_fit_image.dart';
import 'package:flutter/material.dart';

void main() {
  double width = 300;
  double height = 200;

  double aspectRatio = 16 / 9;
  String imagUrl =
      'http://gips2.baidu.com/it/u=4160611580,2154032802&fm=3028&app=3028&f=JPEG&fmt=auto?w=720&h=1280';
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('FlexibleFitImage Example')),
      body: Column(
        children: [
          FlexibleFitImage(
            imageUrl: imagUrl,
            width: width,
            height: height,
            selectFit: (Size originSize) {
              double windowRatio;

              windowRatio = width / height;

              double imgOriginRatio = originSize.width / originSize.height;
              // 图片比显示 扁
              if (imgOriginRatio > windowRatio) {
                return BoxFit.fitHeight;
              } else {
                // 图片比显示 窄
                return BoxFit.fitWidth;
              }
            }, // 使用 _defaultRatioFillFit 函数
            borderRadius: 10,
          ),
          FlexibleFitImage(
            imageUrl: imagUrl,
            width: double.infinity,
            aspectRatio: aspectRatio,
            selectFit: (Size originSize) {
              double windowRatio;

              windowRatio = aspectRatio;

              double imgOriginRatio = originSize.width / originSize.height;
              // 图片比显示 扁
              if (imgOriginRatio > windowRatio) {
                return BoxFit.fitHeight;
              } else {
                // 图片比显示 窄
                return BoxFit.fitWidth;
              }
            }, // 使用 _defaultRatioFillFit 函数
            borderRadius: 10,
          )
        ],
      ),
    ),
  ));
}
