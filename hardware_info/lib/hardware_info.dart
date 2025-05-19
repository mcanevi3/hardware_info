import 'hardware_info_platform_interface.dart';

class HardwareInfo {
  Future<String?> getPlatformVersion() {
    return HardwareInfoPlatform.instance.getPlatformVersion();
  }

  Future<String?> getCpuId() {
    return HardwareInfoPlatform.instance.getCpuId();
  }

  Future<String?> getBiosSerial() {
    return HardwareInfoPlatform.instance.getBiosSerial();
  }

  Future<String?> getMotherboardId() {
    return HardwareInfoPlatform.instance.getMotherboardId();
  }

  Future<String?> getNTPDate() {
    return HardwareInfoPlatform.instance.getNTPDate();
  }
}
