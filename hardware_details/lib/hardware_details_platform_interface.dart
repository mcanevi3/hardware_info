import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hardware_details_method_channel.dart';

abstract class HardwareDetailsPlatform extends PlatformInterface {
  /// Constructs a HardwareDetailsPlatform.
  HardwareDetailsPlatform() : super(token: _token);

  static final Object _token = Object();

  static HardwareDetailsPlatform _instance = MethodChannelHardwareDetails();

  /// The default instance of [HardwareDetailsPlatform] to use.
  ///
  /// Defaults to [MethodChannelHardwareDetails].
  static HardwareDetailsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HardwareDetailsPlatform] when
  /// they register themselves.
  static set instance(HardwareDetailsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Add this:
  Future<String?> getPlatformVersion();
  Future<String?> getCpuId();
  Future<String?> getBiosSerial();
  Future<String?> getMotherboardId();
  Future<String?> getNTPDate();
}
