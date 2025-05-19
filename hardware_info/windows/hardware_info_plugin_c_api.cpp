#include "include/hardware_info/hardware_info_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hardware_info_plugin.h"

void HardwareInfoPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hardware_info::HardwareInfoPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
