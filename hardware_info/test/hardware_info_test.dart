import 'package:flutter_test/flutter_test.dart';
import 'package:hardware_info/hardware_info.dart';
import 'package:hardware_info/hardware_info_platform_interface.dart';
import 'package:hardware_info/hardware_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHardwareInfoPlatform
    with MockPlatformInterfaceMixin
    implements HardwareInfoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getBiosSerial() => Future.value('mock_bios_serial');

  @override
  Future<String?> getCpuId() => Future.value('mock_cpu_id');

  @override
  Future<String?> getMotherboardId() => Future.value('mock_motherboard_id');

  @override
  Future<String?> getNTPDate() => Future.value('mock_ntp_date');
}

void main() {
  final HardwareInfoPlatform initialPlatform = HardwareInfoPlatform.instance;

  test('$MethodChannelHardwareInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHardwareInfo>());
  });

  test('getPlatformVersion', () async {
    HardwareInfo hardwareInfoPlugin = HardwareInfo();
    MockHardwareInfoPlatform fakePlatform = MockHardwareInfoPlatform();
    HardwareInfoPlatform.instance = fakePlatform;

    expect(await hardwareInfoPlugin.getPlatformVersion(), '42');
  });
}
