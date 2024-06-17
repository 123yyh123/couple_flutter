import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class MapImageUtil {
  static Future<ByteData> widgetToImage(
    Widget widget, {
    Size size = const Size(double.maxFinite, double.maxFinite),
    Alignment alignment = Alignment.center,
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0,
  }) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: devicePixelRatio,
      ),
      view: WidgetsBinding.instance.platformDispatcher.views.first,
    );

    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image image = await repaintBoundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!;
  }

  static Future<Widget> imageFromByteData(String name) async {
    AssetImage provider = AssetImage(name);
    await precacheImage(provider, Get.context!);
    return Container(
      alignment: Alignment.center,
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1971FF), Color(0xFFD4E4FF)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(name),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            // child: Directionality(
            //   textDirection: TextDirection.ltr,
            //   child: Text(
            //     '距商家 10 公里',
            //     style: const TextStyle(
            //       fontWeight: FontWeight.normal,
            //       fontSize: 31,
            //       color: Color(0xFF1971FF),
            //     ),
            //   ),
            // ),
          ),
          // 绘制一个箭头，指向地图
        ],
      ),
    );
  }
}
