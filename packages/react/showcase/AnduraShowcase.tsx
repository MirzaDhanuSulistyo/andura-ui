import { useState } from 'react';
import { Badge, Button, Card, Dialog, Input, Select, TextArea } from '../src';

export function AnduraShowcase() {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  return <main style={{ maxWidth: 720, margin: '40px auto', padding: 16 }}>
    <h1>Andura React</h1>
    <Card><p>Shared tokens and platform-native React components.</p><Badge tone="success">Active</Badge></Card>
    <h2>Forms</h2>
    <Input aria-label="Project name" placeholder="Project name" />
    <TextArea label="Description" helper="Keep it concise." placeholder="Describe your project" />
    <Select label="Type" defaultValue="personal"><option value="personal">Personal</option><option value="team">Team</option></Select>
    <div style={{ display: 'flex', gap: 12, marginTop: 16 }}>
      <Button loading={loading} onClick={() => { setLoading(true); window.setTimeout(() => setLoading(false), 700); }}>Save</Button>
      <Button variant="ghost" onClick={() => setDialogOpen(true)}>Open dialog</Button>
    </div>
    <Dialog open={dialogOpen} title="Andura dialog" onClose={() => setDialogOpen(false)}>Dialog content with native modal semantics.</Dialog>
  </main>;
}
