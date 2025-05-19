#include "hardware_details_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

#include "hardware_info.h"
namespace hardware_details {

// static
void HardwareDetailsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "hardware_details",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<HardwareDetailsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

HardwareDetailsPlugin::HardwareDetailsPlugin() {}

HardwareDetailsPlugin::~HardwareDetailsPlugin() {}

void HardwareDetailsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  }else if(method_call.method_name().compare("getCpuId") == 0)
  {
    result->Success(flutter::EncodableValue(get_cpu_id()));
  }
  else if(method_call.method_name().compare("getBiosSerial") == 0)
  {
    result->Success(flutter::EncodableValue(get_bios_serial()));
  }
  else if(method_call.method_name().compare("getMotherboardId") == 0)
  {
    result->Success(flutter::EncodableValue(get_motherboard_uuid()));
  }
  else if(method_call.method_name().compare("getNTPDate") == 0)
  {
    result->Success(flutter::EncodableValue(get_ntp_date()));
  }
  else {
    result->NotImplemented();
  }
}

}  // namespace hardware_details
