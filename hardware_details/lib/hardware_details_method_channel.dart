import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hardware_details_platform_interface.dart';

/// An implementation of [HardwareDetailsPlatform] that uses method channels.
class MethodChannelHardwareDetails extends HardwareDetailsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hardware_details');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> getCpuId() async {
    final version = await methodChannel.invokeMethod<String>('getCpuId');
    return version;
  }

  @override
  Future<String?> getMotherboardId() async {
    final version = await methodChannel.invokeMethod<String>(
      'getMotherboardId',
    );
    return version;
  }

  @override
  Future<String?> getBiosSerial() async {
    final version = await methodChannel.invokeMethod<String>('getBiosSerial');
    return version;
  }
  
  @override
  Future<String?> getIpAddress() async {
    final version = await methodChannel.invokeMethod<String>('getIpAddress');
    return version;
  }

}
