import {
  cloneElement,
  forwardRef,
  isValidElement,
  useEffect,
  useRef,
  useState,
  type ButtonHTMLAttributes,
  type DialogHTMLAttributes,
  type HTMLAttributes,
  type InputHTMLAttributes,
  type ReactElement,
  type ReactNode,
  type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';
import './styles.css';

export type ButtonVariant = 'primary' | 'secondary' | 'danger' | 'ghost';
export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  loading?: boolean;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = 'primary', loading = false, disabled, children, ...props }, ref,
) {
  return <button ref={ref} className={`andura-btn andura-btn-${variant}`} disabled={disabled || loading} aria-busy={loading || undefined} {...props}>
    {loading ? <span className="andura-spinner" aria-label="Loading" /> : children}
  </button>;
});

export const IconButton = forwardRef<HTMLButtonElement, ButtonHTMLAttributes<HTMLButtonElement>>(function IconButton({ children, title, ...props }, ref) {
  return <button ref={ref} className="andura-icon-btn" title={title} aria-label={props['aria-label'] ?? title} {...props}>{children}</button>;
});

export interface CardProps extends HTMLAttributes<HTMLDivElement> { interactive?: boolean; }
export const Card = forwardRef<HTMLDivElement, CardProps>(function Card({ interactive, className = '', ...props }, ref) {
  return <div ref={ref} className={`andura-card${interactive ? ' andura-card-interactive' : ''} ${className}`} {...props} />;
});

export const Input = forwardRef<HTMLInputElement, InputHTMLAttributes<HTMLInputElement>>(function Input({ className = '', ...props }, ref) {
  return <input ref={ref} className={`andura-control ${className}`} {...props} />;
});

export interface FieldProps { label?: string; error?: string; helper?: string; children: ReactNode; }
export function Field({ label, error, helper, children }: FieldProps) {
  const id = useRef(`andura-field-${Math.random().toString(36).slice(2)}`).current;
  const describedBy = error || helper ? `${id}-message` : undefined;
  const control = isValidElement(children)
    ? cloneElement(children as ReactElement<{ id?: string; 'aria-describedby'?: string }>, {
        id,
        'aria-describedby': describedBy,
      })
    : children;
  return <div className="andura-field">{label && <label htmlFor={id}>{label}</label>}{control}{describedBy && <span id={describedBy} className={error ? 'andura-error' : 'andura-helper'}>{error ?? helper}</span>}</div>;
}

export interface TextAreaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> { error?: string; helper?: string; label?: string; }
export const TextArea = forwardRef<HTMLTextAreaElement, TextAreaProps>(function TextArea({ label, error, helper, ...props }, ref) {
  return <Field label={label} error={error} helper={helper}><textarea ref={ref} className="andura-control andura-textarea" aria-invalid={!!error || undefined} {...props} /></Field>;
});

export interface SelectProps extends SelectHTMLAttributes<HTMLSelectElement> { error?: string; label?: string; }
export const Select = forwardRef<HTMLSelectElement, SelectProps>(function Select({ label, error, ...props }, ref) {
  return <Field label={label} error={error}><select ref={ref} className="andura-control" aria-invalid={!!error || undefined} {...props} /></Field>;
});

export interface DialogProps extends Omit<DialogHTMLAttributes<HTMLDialogElement>, 'title' | 'children' | 'open'> { open: boolean; title?: ReactNode; onClose: () => void; children: ReactNode; }
export function Dialog({ open, title, onClose, children, ...props }: DialogProps) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => { const dialog = ref.current; if (!dialog) return; if (open && !dialog.open) dialog.showModal(); if (!open && dialog.open) dialog.close(); }, [open]);
  useEffect(() => { const dialog = ref.current; if (!dialog) return; const close = () => onClose(); dialog.addEventListener('close', close); return () => dialog.removeEventListener('close', close); }, [onClose]);
  return <dialog ref={ref} className="andura-dialog" {...props}><div className="andura-dialog-header"><h2>{title}</h2><IconButton title="Close" aria-label="Close" onClick={onClose}>×</IconButton></div><div>{children}</div></dialog>;
}

export function Badge({ children, tone = 'neutral' }: { children: ReactNode; tone?: 'neutral' | 'success' | 'warning' | 'danger' }) {
  return <span className={`andura-badge andura-badge-${tone}`}>{children}</span>;
}

export function ErrorText({ children }: { children: ReactNode }) { return <p className="andura-error" role="alert">{children}</p>; }
