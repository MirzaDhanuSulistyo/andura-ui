import { fireEvent, render, screen } from '@testing-library/react';
import { axe } from 'jest-axe';
import { describe, expect, it, vi } from 'vitest';
import {
  Alert,
  Badge,
  Button,
  DesignSystemProvider,
  Dialog,
  KeyboardKey,
  Progress,
  TextArea,
  designSystems,
  getDesignSystem,
} from '../src';

it('exports all design systems and applies semantic variables', () => {
  expect(designSystems).toHaveLength(151);
  expect(getDesignSystem('linear-app').name).toBe('Linear');
  render(<DesignSystemProvider systemId="linear-app"><Button>Continue</Button></DesignSystemProvider>);
  const provider = screen.getByText('Continue').parentElement;
  expect(provider).toHaveAttribute('data-andura-design-system', 'linear-app');
  expect(provider?.style.getPropertyValue('--andura-accent')).not.toBe('');
});

it('applies an app-local design system without catalog registration', () => {
  const custom = {
    ...getDesignSystem('default'),
    id: 'acme',
    name: 'Acme',
    accent: '#6750a4',
  };
  render(<DesignSystemProvider system={custom}><Button>Custom</Button></DesignSystemProvider>);
  const provider = screen.getByText('Custom').parentElement;

  expect(provider).toHaveAttribute('data-andura-design-system', 'acme');
  expect(provider?.style.getPropertyValue('--andura-accent')).toBe('#6750a4');
  expect(designSystems).not.toContain(custom);
});

it('renders extended component coverage', () => {
  render(<><Alert intent="success">Saved</Alert><KeyboardKey>⌘ K</KeyboardKey><Progress value={0.5} label="Coverage" /></>);
  expect(screen.getByText('Saved')).toBeInTheDocument();
  expect(screen.getByText('⌘ K')).toBeInTheDocument();
  expect(screen.getByText('50%')).toBeInTheDocument();
});

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

it('has no basic accessibility violations', async () => {
  const { container } = render(<><Button>Continue</Button><TextArea label="Description" /><Badge>Active</Badge></>);
  expect((await axe(container)).violations.length).toBe(0);
});

it('opens and closes a dialog', () => {
  const onClose = vi.fn();
  render(<Dialog open title="Confirm" onClose={onClose}>Content</Dialog>);
  expect(screen.getByRole('dialog')).toBeVisible();
  fireEvent.click(screen.getByRole('button', { name: 'Close' }));
  expect(onClose).toHaveBeenCalledOnce();
});
