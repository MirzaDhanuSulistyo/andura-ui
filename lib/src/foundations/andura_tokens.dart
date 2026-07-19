import 'package:flutter/material.dart';

import 'generated_tokens.dart';

/// Spacing scale shared by every Andura application.
abstract final class AnduraSpacing {
  static const xs = AnduraGeneratedTokens.spacingXs;
  static const sm = AnduraGeneratedTokens.spacingSm;
  static const md = AnduraGeneratedTokens.spacingMd;
  static const lg = AnduraGeneratedTokens.spacingLg;
  static const xl = AnduraGeneratedTokens.spacingXl;
  static const xxl = AnduraGeneratedTokens.spacingXxl;
  static const xxxl = AnduraGeneratedTokens.spacingXxxl;

  static const page = EdgeInsets.fromLTRB(xl, sm, xl, 120);
  static const formPage = EdgeInsets.fromLTRB(xl, sm, xl, xxl);
}

abstract final class AnduraRadii {
  static const sm = AnduraGeneratedTokens.radiusSm;
  static const md = AnduraGeneratedTokens.radiusMd;
  static const lg = AnduraGeneratedTokens.radiusLg;
  static const xl = AnduraGeneratedTokens.radiusXl;
  static const sheet = AnduraGeneratedTokens.radiusSheet;
  static const pill = AnduraGeneratedTokens.radiusPill;
}

abstract final class AnduraSizes {
  static const control = AnduraGeneratedTokens.sizeControl;
  static const minimumTapTarget = AnduraGeneratedTokens.sizeMinimumTapTarget;
  static const icon = AnduraGeneratedTokens.sizeIcon;
  static const avatar = AnduraGeneratedTokens.sizeAvatar;
}

abstract final class AnduraElevation {
  static const card = AnduraGeneratedTokens.elevationCard;
  static const floating = AnduraGeneratedTokens.elevationFloating;
  static const dialog = AnduraGeneratedTokens.elevationDialog;
}

abstract final class AnduraLayout {
  static const maxContentWidth = AnduraGeneratedTokens.layoutMaxContentWidth;
  static const desktopGutter = AnduraGeneratedTokens.layoutDesktopGutter;
  static const tabletGutter = AnduraGeneratedTokens.layoutTabletGutter;
  static const phoneGutter = AnduraGeneratedTokens.layoutPhoneGutter;
}

abstract final class AnduraMotion {
  static const fast = Duration(
    milliseconds: AnduraGeneratedTokens.motionFastMs,
  );
  static const standard = Duration(
    milliseconds: AnduraGeneratedTokens.motionStandardMs,
  );
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
