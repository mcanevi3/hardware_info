#include "include/hardware_details/hardware_details_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hardware_details_plugin.h"

void HardwareDetailsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hardware_details::HardwareDetailsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
