import 'package:mineral/infrastructure/internals/environment/env_schema.dart';

enum AppEnv implements EnvSchema {
  token('TOKEN'),
  httpVersion('HTTP_VERSION'),
  wssVersion('WSS_VERSION'),
  intent('INTENT'),
  logLevel('LOG_LEVEL'),
  hmr('HMR');

  @override
  final String key;

  const AppEnv(this.key);
}