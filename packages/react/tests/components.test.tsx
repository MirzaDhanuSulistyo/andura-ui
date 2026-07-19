import { fireEvent, render, screen } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';
import { Badge, Button, Dialog, TextArea } from '../src';

it('renders loading and disabled button states', () => {
  render(<Button loading>Save</Button>);
  expect(screen.getByRole('button')).toHaveAttribute('aria-busy', 'true');
  expect(screen.getByRole('button')).toBeDisabled();
});

describe('form components', () => {
  it('renders labelled textarea errors', () => {
    render(<TextArea label="Description" error="Required" />);
    expect(screen.getByLabelText('Description')).toHaveAttribute('aria-invalid', 'true');
    expect(screen.getByText('Required')).toBeInTheDocument();
  });

  it('renders a badge', () => {
    render(<Badge tone="success">Active</Badge>);
    expect(screen.getByText('Active')).toHaveClass('andura-badge-success');
  });
});

it('opens and closes a dialog', () => {
  const onClose = vi.fn();
  render(<Dialog open title="Confirm" onClose={onClose}>Content</Dialog>);
  expect(screen.getByRole('dialog')).toBeVisible();
  fireEvent.click(screen.getByRole('button', { name: 'Close' }));
  expect(onClose).toHaveBeenCalledOnce();
});
