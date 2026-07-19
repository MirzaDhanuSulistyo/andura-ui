import type { CSSProperties, HTMLAttributes, ReactNode } from 'react';
import {
  designSystemVariables,
  getDesignSystem,
  type AnduraDesignSystem,
} from './design-systems';

export * from './design-systems';

export interface DesignSystemProviderProps extends HTMLAttributes<HTMLDivElement> {
  system?: AnduraDesignSystem;
  systemId?: string;
  children: ReactNode;
}

/** Applies one of the 151 design-system presets to a subtree. */
export function DesignSystemProvider({
  system,
  systemId = 'default',
  children,
  className = '',
  style,
  ...props
}: DesignSystemProviderProps) {
  const selected = system ?? getDesignSystem(systemId);
  return (
    <div
      data-andura-design-system={selected.id}
      data-theme={selected.brightness}
      className={`andura-theme ${className}`.trim()}
      style={{ ...designSystemVariables(selected), ...style } as CSSProperties}
      {...props}
    >
      {children}
    </div>
  );
}
