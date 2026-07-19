# App-local design-system APIs

Always inspect the installed package because signatures may evolve.

## Flutter

Create an app-local object from a bundled baseline and pass it to the public theme factory:

```dart
final acmeSystem = AnduraDesignSystems.byId('default').copyWith(
  id: 'acme',
  name: 'Acme',
  accent: 0xFF6750A4,
  accentOn: 0xFFFFFFFF,
);

MaterialApp(
  theme: AnduraTheme.fromSystem(acmeSystem, Brightness.light),
  darkTheme: AnduraTheme.fromSystem(acmeSystem, Brightness.dark),
  home: const App(),
);
```

Use ARGB integers (`0xAARRGGBB`). A custom font family must also be declared in the consuming app's `pubspec.yaml` or otherwise provided by the app.

## React

Create a typed object with a bundled baseline and pass the object, not an ID:

```tsx
import {
  DesignSystemProvider,
  getDesignSystem,
  type AnduraDesignSystem,
} from '@andura-ui/react';

export const acmeSystem: AnduraDesignSystem = {
  ...getDesignSystem('default'),
  id: 'acme',
  name: 'Acme',
  accent: '#6750a4',
  accentOn: '#ffffff',
};

<DesignSystemProvider system={acmeSystem}>
  <App />
</DesignSystemProvider>
```

Load web fonts in the consuming app; setting `fontBody` alone does not download them.

## Jetpack Compose

Use the generated data class's standard `copy` method:

```kotlin
val acmeSystem = AnduraDesignSystems.defaultSystem.copy(
    id = "acme",
    name = "Acme",
    accent = 0xFF6750A4u,
    accentOn = 0xFFFFFFFFu,
)

AnduraDesignSystemTheme(acmeSystem) {
    App()
}
```

Colors are ARGB `ULong` values. The current adapter maps normalized font-family names to platform generic families; custom font resources require app-level typography work.

## SwiftUI

Copy a bundled baseline and apply the object overload:

```swift
let acmeSystem = AnduraDesignSystems.defaultSystem.copyWith(
    id: "acme",
    name: "Acme",
    accent: 0xFF6750A4,
    accentOn: 0xFFFFFFFF
)

AppView()
    .anduraDesignSystem(acmeSystem)
```

`AnduraDesignSystem` also has a public full initializer. Colors are ARGB `UInt32` values. Configure custom font files in the consuming target separately.

## App-local versus catalog systems

App-local systems:

- live in the consuming application;
- are passed as objects;
- do not appear in bundled system selectors automatically;
- survive future Open Design catalog regeneration;
- require no Andura fork.

A catalog preset is different: it is distributed by Andura, selected globally by ID, generated for every adapter, and maintained as part of the shared catalog contract.
