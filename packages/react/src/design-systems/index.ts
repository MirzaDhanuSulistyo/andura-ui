// GENERATED FILE - DO NOT EDIT.
import type { AnduraDesignSystem } from './types';
import { designSystemsChunk01 } from './chunk-01';
import { designSystemsChunk02 } from './chunk-02';
import { designSystemsChunk03 } from './chunk-03';
import { designSystemsChunk04 } from './chunk-04';
import { designSystemsChunk05 } from './chunk-05';
import { designSystemsChunk06 } from './chunk-06';
import { designSystemsChunk07 } from './chunk-07';
import { designSystemsChunk08 } from './chunk-08';
export type { AnduraDesignSystem } from './types';

export const designSystems = [
  ...designSystemsChunk01,
  ...designSystemsChunk02,
  ...designSystemsChunk03,
  ...designSystemsChunk04,
  ...designSystemsChunk05,
  ...designSystemsChunk06,
  ...designSystemsChunk07,
  ...designSystemsChunk08,
] as const satisfies readonly AnduraDesignSystem[];

export function getDesignSystem(id: string): AnduraDesignSystem {
  return designSystems.find(system => system.id === id) ?? designSystems.find(system => system.id === 'default') ?? designSystems[0];
}

export function designSystemVariables(system: AnduraDesignSystem): Record<`--${string}`, string> {
  const px = (value: number) => `${value}px`;
  return {
    '--andura-bg': system.background, '--andura-surface': system.surface, '--andura-surface-warm': system.surfaceWarm,
    '--andura-fg': system.foreground, '--andura-fg-2': system.foregroundSecondary, '--andura-muted': system.muted, '--andura-border': system.border,
    '--andura-accent': system.accent, '--andura-accent-on': system.accentOn, '--andura-success': system.success, '--andura-warning': system.warning, '--andura-danger': system.danger,
    '--andura-font-display': system.fontDisplay, '--andura-font-body': system.fontBody, '--andura-text-base': px(system.textBase),
    '--andura-radius-sm': px(system.radiusSm), '--andura-radius-md': px(system.radiusMd), '--andura-radius-lg': px(system.radiusLg), '--andura-radius-pill': px(system.radiusPill),
    '--andura-space-1': px(system.space1), '--andura-space-2': px(system.space2), '--andura-space-3': px(system.space3), '--andura-space-4': px(system.space4), '--andura-space-6': px(system.space6), '--andura-space-8': px(system.space8),
    '--andura-motion-fast': `${system.motionFastMs}ms`, '--andura-motion-base': `${system.motionBaseMs}ms`, '--andura-container-max': px(system.containerMax),
  };
}
