import 'dart:io';

import 'package:mineral/application/io/ffi/unix_terminal.dart';
import 'package:mineral/application/io/ffi/windows_terminal.dart';

abstract class Terminal {
  factory Terminal() => Platform.isWindows ? WindowsTerminal() : UnixTerminal();

  void enableRawMode();
  void disableRawMode();
}
