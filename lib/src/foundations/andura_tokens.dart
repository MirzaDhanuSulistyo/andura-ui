import 'package:flutter/material.dart';

/// Spacing scale shared by every Andura application.
abstract final class AnduraSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;

  static const page = EdgeInsets.fromLTRB(xl, sm, xl, 120);
  static const formPage = EdgeInsets.fromLTRB(xl, sm, xl, xxl);
}

abstract final class AnduraRadii {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const sheet = 24.0;
  static const pill = 999.0;
}

abstract final class AnduraSizes {
  static const control = 56.0;
  static const minimumTapTarget = 44.0;
  static const icon = 20.0;
  static const avatar = 40.0;
}

abstract final class AnduraElevation {
  static const card = 0.0;
  static const floating = 8.0;
  static const dialog = 24.0;
}

abstract final class AnduraLayout {
  static const maxContentWidth = 1200.0;
  static const desktopGutter = 36.0;
  static const tabletGutter = 24.0;
  static const phoneGutter = 16.0;
}

abstract final class AnduraMotion {
  static const fast = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 250);
  static const curve = Curves.easeOutCubic;
}

abstract final class AnduraTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  static const section = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );
  static const label = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const caption = TextStyle(fontSize: 12, height: 1.3);
}
