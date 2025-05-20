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
  Future<String?> getCpuId() {
    // TODO: implement getCpuId
    throw UnimplementedError();
  }

  @override
  Future<String?> getBiosSerial() {
    // TODO: implement getBiosSerial
    throw UnimplementedError();
  }

  @override
  Future<String?> getMotherboardId() {
    // TODO: implement getMotherboardId
    throw UnimplementedError();
  }

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
