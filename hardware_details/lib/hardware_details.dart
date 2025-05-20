import 'hardware_details_platform_interface.dart';

class HardwareDetails {
  //extends HardwareDetailsPlatform
  Future<String?> getPlatformVersion() {
    return HardwareDetailsPlatform.instance.getPlatformVersion();
  }

  Future<String?> getCpuId() {
    return HardwareDetailsPlatform.instance.getCpuId();
  }

  Future<String?> getBiosSerial() {
    return HardwareDetailsPlatform.instance.getBiosSerial();
  }

  Future<String?> getMotherboardId() {
    return HardwareDetailsPlatform.instance.getMotherboardId();
  }

  Future<String?> getIpAddress() {
    return HardwareDetailsPlatform.instance.getIpAddress();
  }
}
