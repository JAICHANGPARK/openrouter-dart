//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <openrouter/openrouter_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) openrouter_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenrouterPlugin");
  openrouter_plugin_register_with_registrar(openrouter_registrar);
}
