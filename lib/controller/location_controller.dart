import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/config/amap_config.dart';
import 'package:get/get.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_demo1/utils/image_util.dart';

class LocationController extends GetxController {
  // 默认为北京
  final RxString latitude = '39.919926'.obs; //纬度
  final RxString longitude = '116.397245'.obs; //经度
  RxSet<Marker> markerMap = <Marker>{}.obs;
  late StreamSubscription _locationListener;

  //实例化插件
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  AMapController? mapController;

  var isFirst = true;

  @override
  Future<void> onInit() async {
    Get.log('LocationController初始化');
    // TODO: implement onInit
    super.onInit();
    requestPermission();
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.setApiKey(AMapConfig.androidKey, AMapConfig.iosKey);
    Get.log('开始监听定位信息');
    _locationListener =
        _locationPlugin.onLocationChanged().listen((event) async {
      Get.log('定位信息：$event');
      latitude.value = event['latitude'].toString();
      longitude.value = event['longitude'].toString();
      // 移动地图到当前位置，只执行一次
      if (isFirst && mapController != null) {
        mapController?.moveCamera(
          CameraUpdate.newLatLng(LatLng(
            double.parse(latitude.value),
            double.parse(longitude.value),
          )),
        );
        Widget widget =
            await MapImageUtil.imageFromByteData('images/touxiang.png');
        ByteData byteData = await MapImageUtil.widgetToImage(
          widget,
          devicePixelRatio: AMapUtil.devicePixelRatio,
          pixelRatio: AMapUtil.devicePixelRatio,
          size: const Size(200, 200),
        );
        var a = byteData.buffer.asUint8List();
        markerMap.add(Marker(
          position: LatLng(
              double.parse(latitude.value), double.parse(longitude.value)),
          infoWindow: InfoWindow(
            title: '当前位置',
            snippet: '纬度：${latitude.value}，经度：${longitude.value}',
          ),
          icon: BitmapDescriptor.fromBytes(a),
        ));
        isFirst = false;
      }
    });
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  // 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      Get.log('定位权限已授予');
    } else {
      Get.log('定位权限未授予');
    }
  }

  //  申请定位权限  授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  //设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Height_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuratForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  void startLocation() {
    _locationPlugin.startLocation();
  }

  void addMarker(Marker marker) {
    markerMap.add(marker);
  }
}
