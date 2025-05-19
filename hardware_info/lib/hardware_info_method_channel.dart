import 'package:flutter/services.dart';

import 'hardware_info_platform_interface.dart';

class MethodChannelHardwareInfo extends HardwareInfoPlatform {
  static const MethodChannel _channel = MethodChannel('hardware_info');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getCpuId() async {
    final cpuId = await _channel.invokeMethod<String>('getCpuId');
    return cpuId;
  }

  @override
  Future<String?> getBiosSerial() async {
    final cpuId = await _channel.invokeMethod<String>('getBiosSerial');
    return cpuId;
  }

  @override
  Future<String?> getMotherboardId() async {
    final cpuId = await _channel.invokeMethod<String>('getMotherboardId');
    return cpuId;
  }

  @override
  Future<String?> getNTPDate() async {
    final cpuId = await _channel.invokeMethod<String>('getNTPDate');
    return cpuId;
  }
}
