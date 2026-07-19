import 'generated_tokens.dart';

/// Andura's brand and semantic color palette.
abstract final class AnduraColors {
  static const primary = AnduraGeneratedTokens.colorPrimary;
  static const primaryDeep = AnduraGeneratedTokens.colorPrimaryDeep;
  static const yellow = AnduraGeneratedTokens.colorYellow;
  static const mint = AnduraGeneratedTokens.colorMint;
  static const red = AnduraGeneratedTokens.colorRed;
  static const donutYellow = AnduraGeneratedTokens.colorDonutYellow;

  static const scaffold = AnduraGeneratedTokens.colorScaffold;
  static const searchFill = AnduraGeneratedTokens.colorSearchFill;
  static const emphasizedSurface = AnduraGeneratedTokens.colorEmphasizedSurface;
  static const subtleSurface = AnduraGeneratedTokens.colorSubtleSurface;

  static const pastelMint = AnduraGeneratedTokens.colorPastelMint;
  static const pastelLavender = AnduraGeneratedTokens.colorPastelLavender;
  static const pastelBlue = AnduraGeneratedTokens.colorPastelBlue;
  static const pastels = [pastelMint, pastelLavender, pastelBlue];

  static const textDark = AnduraGeneratedTokens.colorTextDark;
  static const textGray = AnduraGeneratedTokens.colorTextGray;

  static const success = mint;
  static const warning = yellow;
  static const danger = red;
}
