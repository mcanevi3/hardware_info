import 'package:hardware_info/hardware_info_method_channel.dart';

abstract class HardwareInfoPlatform {
  static HardwareInfoPlatform _instance = MethodChannelHardwareInfo();

  static HardwareInfoPlatform get instance => _instance;

  static set instance(HardwareInfoPlatform instance) {
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  // Add this:
  Future<String?> getCpuId();
  Future<String?> getBiosSerial();
  Future<String?> getMotherboardId();
  Future<String?> getNTPDate();
}
