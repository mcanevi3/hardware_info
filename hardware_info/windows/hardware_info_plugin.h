#ifndef FLUTTER_PLUGIN_HARDWARE_INFO_PLUGIN_H_
#define FLUTTER_PLUGIN_HARDWARE_INFO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace hardware_info {

class HardwareInfoPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HardwareInfoPlugin();

  virtual ~HardwareInfoPlugin();

  // Disallow copy and assign.
  HardwareInfoPlugin(const HardwareInfoPlugin&) = delete;
  HardwareInfoPlugin& operator=(const HardwareInfoPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace hardware_info

#endif  // FLUTTER_PLUGIN_HARDWARE_INFO_PLUGIN_H_
