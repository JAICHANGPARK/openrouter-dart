#include "include/openrouter/openrouter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "openrouter_plugin.h"

void OpenrouterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  openrouter::OpenrouterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
