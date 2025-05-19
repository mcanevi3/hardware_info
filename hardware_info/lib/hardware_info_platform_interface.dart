import 'package:hardware_info/hardware_info_method_channel.dart';

abstract class HardwareInfoPlatform {
  static HardwareInfoPlatform instance = MethodChannelHardwareInfo();

  Future<String?> getPlatformVersion();

  // Add this:
  Future<String?> getCpuId();
  Future<String?> getBiosSerial();
  Future<String?> getMotherboardId();
  Future<String?> getNTPDate();
}
