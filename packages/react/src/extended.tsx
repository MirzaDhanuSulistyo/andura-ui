import {
  useId,
  useState,
  type AnchorHTMLAttributes,
  type HTMLAttributes,
  type InputHTMLAttributes,
  type ReactNode,
} from 'react';

export type Intent = 'neutral' | 'info' | 'success' | 'warning' | 'danger';

export function SectionHeader({ title, action, onAction }: { title: ReactNode; action?: ReactNode; onAction?: () => void }) {
  return <header className="andura-section-header"><h2>{title}</h2>{action && <button type="button" onClick={onAction}>{action}</button>}</header>;
}

export function Link({ className = '', ...props }: AnchorHTMLAttributes<HTMLAnchorElement>) {
  return <a className={`andura-link ${className}`.trim()} {...props} />;
}

export function KeyboardKey({ children }: { children: ReactNode }) {
  return <kbd className="andura-keyboard-key">{children}</kbd>;
}

export function Chip({ children, selected = false, onClick, onDelete }: { children: ReactNode; selected?: boolean; onClick?: () => void; onDelete?: () => void }) {
  return <span className={`andura-chip${selected ? ' andura-chip-selected' : ''}`}><button type="button" aria-pressed={selected} onClick={onClick}>{children}</button>{onDelete && <button type="button" aria-label="Remove" onClick={onDelete}>×</button>}</span>;
}

export function Alert({ title, children, intent = 'info', onDismiss }: { title?: ReactNode; children: ReactNode; intent?: Intent; onDismiss?: () => void }) {
  return <div className={`andura-alert andura-intent-${intent}`} role={intent === 'danger' ? 'alert' : 'status'}><div>{title && <strong>{title}</strong>}{children}</div>{onDismiss && <button type="button" aria-label="Dismiss" onClick={onDismiss}>×</button>}</div>;
}

export function Switch({ label, ...props }: Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> & { label: ReactNode }) {
  return <label className="andura-toggle"><input type="checkbox" role="switch" {...props} /><span>{label}</span></label>;
}

export function Checkbox({ label, ...props }: Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> & { label: ReactNode }) {
  return <label className="andura-toggle"><input type="checkbox" {...props} /><span>{label}</span></label>;
}

export interface RadioOption { value: string; label: ReactNode; disabled?: boolean; }
export function Radio({ options, value, onChange, name }: { options: RadioOption[]; value: string; onChange: (value: string) => void; name?: string }) {
  const generatedName = useId();
  return <div className="andura-radio-group" role="radiogroup">{options.map(option => <label key={option.value}><input type="radio" name={name ?? generatedName} value={option.value} checked={option.value === value} disabled={option.disabled} onChange={() => onChange(option.value)} />{option.label}</label>)}</div>;
}

export function Tabs({ tabs, value, onChange }: { tabs: readonly { value: string; label: ReactNode }[]; value: string; onChange: (value: string) => void }) {
  return <div className="andura-tabs" role="tablist">{tabs.map(tab => <button type="button" role="tab" key={tab.value} aria-selected={tab.value === value} onClick={() => onChange(tab.value)}>{tab.label}</button>)}</div>;
}

export function Progress({ value, label }: { value?: number; label?: ReactNode }) {
  const percent = value == null ? undefined : Math.round(Math.max(0, Math.min(1, value)) * 100);
  return <div className="andura-progress">{label && <span>{label}</span>}<progress value={value} max={1} aria-label={typeof label === 'string' ? label : undefined} />{percent != null && <output>{percent}%</output>}</div>;
}

export function Skeleton({ width = '100%', height = 16, circle = false }: { width?: number | string; height?: number | string; circle?: boolean }) {
  return <span className={`andura-skeleton${circle ? ' andura-skeleton-circle' : ''}`} role="status" aria-label="Loading" style={{ width, height }} />;
}

export function Accordion({ title, children, open = false }: { title: ReactNode; children: ReactNode; open?: boolean }) {
  return <details className="andura-accordion" open={open}><summary>{title}</summary><div>{children}</div></details>;
}

export function Stat({ label, value, change, intent = 'neutral' }: { label: ReactNode; value: ReactNode; change?: ReactNode; intent?: Intent }) {
  return <div className="andura-stat"><span>{label}</span><strong>{value}</strong>{change && <small className={`andura-intent-${intent}`}>{change}</small>}</div>;
}

export function ListItem({ className = '', ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={`andura-list-item ${className}`.trim()} {...props} />;
}

export function MenuButton({ label = 'More actions', items }: { label?: ReactNode; items: readonly { label: ReactNode; onSelect: () => void }[] }) {
  const [open, setOpen] = useState(false);
  return <div className="andura-menu"><button type="button" aria-haspopup="menu" aria-expanded={open} onClick={() => setOpen(value => !value)}>{label}</button>{open && <div role="menu">{items.map((item, index) => <button type="button" role="menuitem" key={index} onClick={() => { item.onSelect(); setOpen(false); }}>{item.label}</button>)}</div>}</div>;
}

export function BottomSheet({ open, title, children, onClose }: { open: boolean; title?: ReactNode; children: ReactNode; onClose: () => void }) {
  if (!open) return null;
  return <div className="andura-sheet-backdrop" onMouseDown={onClose}><section className="andura-bottom-sheet" role="dialog" aria-modal="true" onMouseDown={event => event.stopPropagation()}><header>{title && <h2>{title}</h2>}<button type="button" aria-label="Close" onClick={onClose}>×</button></header>{children}</section></div>;
}

export function ResponsiveContainer({ className = '', ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={`andura-container ${className}`.trim()} {...props} />;
}

export function ResponsiveGrid({ className = '', ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={`andura-grid ${className}`.trim()} {...props} />;
}

export function Divider({ label }: { label?: ReactNode }) {
  return label ? <div className="andura-divider"><hr /><span>{label}</span><hr /></div> : <hr className="andura-divider" />;
}
