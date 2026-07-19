// GENERATED FILE - DO NOT EDIT.
// Source: Open Design design-systems catalog.
import 'andura_design_system.dart';
import 'generated/design_systems_01.dart';
import 'generated/design_systems_02.dart';
import 'generated/design_systems_03.dart';
import 'generated/design_systems_04.dart';
import 'generated/design_systems_05.dart';
import 'generated/design_systems_06.dart';
import 'generated/design_systems_07.dart';
import 'generated/design_systems_08.dart';

abstract final class AnduraDesignSystems {
  static const all = <AnduraDesignSystem>[
    ...anduraDesignSystemsChunk01,
    ...anduraDesignSystemsChunk02,
    ...anduraDesignSystemsChunk03,
    ...anduraDesignSystemsChunk04,
    ...anduraDesignSystemsChunk05,
    ...anduraDesignSystemsChunk06,
    ...anduraDesignSystemsChunk07,
    ...anduraDesignSystemsChunk08,
  ];

  static AnduraDesignSystem byId(String id) =>
      all.firstWhere((system) => system.id == id, orElse: () => defaultSystem);

  static AnduraDesignSystem get defaultSystem => all.firstWhere(
    (system) => system.id == 'default',
    orElse: () => all.first,
  );
}
