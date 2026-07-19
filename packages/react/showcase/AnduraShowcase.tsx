import { useState } from 'react';
import {
  Alert,
  Badge,
  Button,
  Card,
  DesignSystemProvider,
  Dialog,
  Input,
  KeyboardKey,
  Progress,
  Select,
  Tabs,
  TextArea,
  designSystems,
} from '../src';

export function AnduraShowcase() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [systemId, setSystemId] = useState('default');
  const [tab, setTab] = useState('overview');
  return <DesignSystemProvider systemId={systemId}>
    <main className="andura-container" style={{ paddingBlock: 40 }}>
      <header className="andura-section-header">
        <h1>Andura React</h1>
        <Select aria-label="Design system" value={systemId} onChange={event => setSystemId(event.target.value)}>
          {designSystems.map(system => <option key={system.id} value={system.id}>{system.name}</option>)}
        </Select>
      </header>
      <Card><p>Shared components and all 151 platform-native themes.</p><Badge tone="success">Active</Badge></Card>
      <h2>Forms</h2>
      <Input aria-label="Project name" placeholder="Project name" />
      <TextArea label="Description" helper="Keep it concise." placeholder="Describe your project" />
      <Select label="Type" defaultValue="personal"><option value="personal">Personal</option><option value="team">Team</option></Select>
      <div style={{ display: 'flex', gap: 12, marginTop: 16 }}>
        <Button loading={loading} onClick={() => { setLoading(true); window.setTimeout(() => setLoading(false), 700); }}>Save</Button>
        <Button variant="ghost" onClick={() => setDialogOpen(true)}>Open dialog</Button>
      </div>
      <h2>Extended coverage</h2>
      <Alert intent="success" title="Catalog ready">Every component consumes contextual tokens.</Alert>
      <Tabs tabs={[{ value: 'overview', label: 'Overview' }, { value: 'tokens', label: 'Tokens' }]} value={tab} onChange={setTab} />
      <p>Command palette <KeyboardKey>⌘ K</KeyboardKey></p>
      <Progress value={1} label="Catalog coverage" />
      <Dialog open={dialogOpen} title="Andura dialog" onClose={() => setDialogOpen(false)}>Dialog content with native modal semantics.</Dialog>
    </main>
  </DesignSystemProvider>;
}
