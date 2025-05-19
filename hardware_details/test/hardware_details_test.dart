import 'package:flutter_test/flutter_test.dart';
import 'package:hardware_details/hardware_details.dart';
import 'package:hardware_details/hardware_details_platform_interface.dart';
import 'package:hardware_details/hardware_details_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHardwareDetailsPlatform
    with MockPlatformInterfaceMixin
    implements HardwareDetailsPlatform {
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
  final HardwareDetailsPlatform initialPlatform =
      HardwareDetailsPlatform.instance;

  test('$MethodChannelHardwareDetails is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHardwareDetails>());
  });

  test('getPlatformVersion', () async {
    HardwareDetails hardwareDetailsPlugin = HardwareDetails();
    MockHardwareDetailsPlatform fakePlatform = MockHardwareDetailsPlatform();
    HardwareDetailsPlatform.instance = fakePlatform;

    expect(await hardwareDetailsPlugin.getPlatformVersion(), '42');
  });
}
