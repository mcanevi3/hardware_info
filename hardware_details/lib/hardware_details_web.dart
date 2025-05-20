// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'hardware_details_platform_interface.dart';

/// A web implementation of the HardwareDetailsPlatform of the HardwareDetails plugin.
class HardwareDetailsWeb extends HardwareDetailsPlatform {
  /// Constructs a HardwareDetailsWeb
  HardwareDetailsWeb();

  static void registerWith(Registrar registrar) {
    HardwareDetailsPlatform.instance = HardwareDetailsWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  @override
  Future<String?> getCpuId() async {
    return "unsupported";
  }

  @override
  Future<String?> getBiosSerial() async {
    return "unsupported";
  }

  @override
  Future<String?> getMotherboardId() async {
    return "unsupported";
  }

}
