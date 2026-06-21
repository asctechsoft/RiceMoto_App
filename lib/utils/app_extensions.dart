import "package:flutter/material.dart";

extension SpacingX on num {
  /// Vertical gap sized box.
  SizedBox get vGap => SizedBox(height: toDouble());

  /// Horizontal gap sized box.
  SizedBox get hGap => SizedBox(width: toDouble());
}

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}
