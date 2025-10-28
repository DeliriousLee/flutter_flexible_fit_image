import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 定义一个别名，让代码更清晰
typedef BoxFitSelector = BoxFit Function(Size originalSize);

class FlexibleFitImage extends StatefulWidget {
  const FlexibleFitImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 0.0,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit,
    this.selectFit,
    this.placeHolder,
    this.errorWidget,
  });

  final String imageUrl;
  final double borderRadius;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit? fit;
  final BoxFitSelector? selectFit;
  final Widget Function(BuildContext, String)? placeHolder;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  @override
  State<FlexibleFitImage> createState() => _FlexibleFitImageState();
}

class _FlexibleFitImageState extends State<FlexibleFitImage> {
  BoxFit? _currentFit;
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;
  
  @override
  void initState() {
    super.initState();
    _currentFit = widget.fit;
    _loadAndGetImageSize();
  }

  @override
  void didUpdateWidget(covariant FlexibleFitImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl || widget.fit != oldWidget.fit) {
      _currentFit = widget.fit;
      _loadAndGetImageSize();
    }
  }

  // 在这里进行资源清理
  @override
  void dispose() {
    _imageStream?.removeListener(_imageStreamListener!);
    super.dispose();
  }

  void _loadAndGetImageSize() {
    // 移除旧的监听器，防止内存泄漏或多重监听
    _imageStream?.removeListener(_imageStreamListener!);

    if (widget.selectFit == null) {
      return;
    }

    final ImageProvider imageProvider =
        CachedNetworkImageProvider(widget.imageUrl);
    _imageStream = imageProvider.resolve(const ImageConfiguration());

    _imageStreamListener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted) {
          final Size originalSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          final BoxFit newFit = widget.selectFit!(originalSize);
          if (_currentFit != newFit) {
            setState(() {
              _currentFit = newFit;
            });
          }
        }
      },
      // 捕获加载错误
      onError: (dynamic error, StackTrace? stackTrace) {
        if (mounted) {
          setState(() {
            _currentFit = BoxFit.cover; // 恢复默认行为或处理错误
          });
        }
      },
    );
    _imageStream!.addListener(_imageStreamListener!);
  }

  // 辅助方法，根据参数构建不同的布局
  Widget _buildImageWidget() {
    Widget image = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: _currentFit,
      placeholder: widget.placeHolder,
      errorWidget: widget.errorWidget,
    );

    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: image,
      );
    } else if (widget.aspectRatio != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: image,
      );
    } else {
      return image;
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = _buildImageWidget();
    if (widget.borderRadius == 0) {
      return image;
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: image,
      );
    }
  }
}
