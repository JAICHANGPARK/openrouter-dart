import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'openrouter_platform_interface.dart';

/// An implementation of [OpenrouterPlatform] that uses method channels.
class MethodChannelOpenrouter extends OpenrouterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('openrouter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
