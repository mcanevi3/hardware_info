#ifndef FLUTTER_PLUGIN_HARDWARE_DETAILS_PLUGIN_H_
#define FLUTTER_PLUGIN_HARDWARE_DETAILS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace hardware_details {

class HardwareDetailsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HardwareDetailsPlugin();

  virtual ~HardwareDetailsPlugin();

  // Disallow copy and assign.
  HardwareDetailsPlugin(const HardwareDetailsPlugin&) = delete;
  HardwareDetailsPlugin& operator=(const HardwareDetailsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace hardware_details

#endif  // FLUTTER_PLUGIN_HARDWARE_DETAILS_PLUGIN_H_
