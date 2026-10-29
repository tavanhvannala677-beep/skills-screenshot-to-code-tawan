---
name: screenshot-to-code
description: High-fidelity, zero-regression implementation or adjustment of UI screens and components from visual references (Screenshots, Figma, Mockups) across any framework (React, Next.js, Vue, Flutter, SwiftUI, Jetpack Compose, Angular, Svelte, HTML/Tailwind). Enforces strict architecture preservation, design token reuse, zero unauthorized dependencies, and rigorous build verification.
---

# Universal Screenshot to Code (Production Standard)

## Mission
Transform visual references (Screenshots, Figma exports, Design Mockups) into production-grade code that matches the reference visual appearance with precision, while strictly preserving the project's existing framework, design tokens, component library, and architecture.

---

## 🛑 Non-Negotiable Guardrails (Zero Loopholes)

1. **Zero Unauthorized Dependencies**:
   - NEVER run `npm install`, `yarn add`, `pnpm add`, `pub add`, or add new dependencies to Gradle/Maven/Cocoapods/SPM unless the user explicitly commands it in prompt text.
   - If a specific icon or library is missing, use existing project assets, SVGs, or nearest built-in equivalents.

2. **Design Token & Component Priority**:
   - NEVER hardcode raw color hexes (e.g. `#1E40AF`), raw pixel margins, or ad-hoc border radii if the project provides theme tokens (Tailwind classes, CSS variables, `MaterialTheme`, `Theme.of(context)`, SwiftUI Assets/Colors).
   - NEVER create low-level primitives (`<div onClick>`, raw `Box`) if the repository already has reusable components (e.g., `<Button>`, `<Card>`, `AppHeader`, `PrimaryTextField`).

3. **Strict Scope Isolation**:
   - Modify ONLY the target screen, target component, and its direct navigation/route registration if needed.
   - DO NOT refactor unrelated screens, shared parent layouts, global state models, database schemas, or backend API contracts.
   - DO NOT run global linter or formatter (`prettier --write .`, `dart format .`) that mutates unrelated files.

4. **Responsive & Safe Area Integrity**:
   - DO NOT hardcode fixed viewport sizes (e.g. `width: 375px; height: 812px`) to match the screenshot device.
   - Implement proper responsive behavior (Flexbox, Grid, Auto-Layout, BoxWithConstraints) and respect Safe Area Insets (notches, status bars, navigation bars).

5. **State Completeness**:
   - If the screenshot shows data, provide clean, strongly typed mock models or wire into existing state without breaking existing contracts.
   - Preserve or account for default states (Loaded, Empty, Loading skeleton, and Error) when adjusting components.

---

## 📋 Mandatory 6-Phase Execution Workflow

### Phase 1: Stack & Architecture Reconnaissance
Before generating or modifying any UI file, run lightweight inspection to identify:
1. **Core Framework**:
   - Web: React, Next.js (App vs Pages router), Vue (Options vs Composition API), Svelte, Angular.
   - Mobile: Flutter, Jetpack Compose (Kotlin), SwiftUI (iOS).
   - Static: HTML5 + Tailwind CSS, SCSS, or Vanilla CSS.
2. **Styling Paradigm**:
   - Tailwind CSS (check `tailwind.config`), CSS Modules, Emotion/Styled-Components, Vanilla CSS, or Native Theme system.
3. **Component & Asset Inventory**:
   - Inspect existing design system directory (e.g., `components/ui`, `common/widgets`, `core/presentation`).
   - Identify existing icon set (e.g. Lucide, FontAwesome, Phosphor, Material Icons, SF Symbols, custom SVG/Vector Drawables).
4. **State & Routing**:
   - Identify how screens receive params, route names, and ViewModel/State management patterns (Redux, Zustand, Riverpod, Bloc, StateFlow, Observable).

### Phase 2: Visual Reference Deconstruction
Deconstruct the image systematically:
1. **Layout Hierarchy**: Header / App Bar ➔ Main Content Area (Scrollable vs Fixed) ➔ Footer / Bottom Navigation / Sticky CTA.
2. **Grid & Alignment**: Row/Column distribution, padding gutters, gap sizes, visual alignments (baseline, center).
3. **Typography**: Font family, font weight hierarchy (Headline, Title, Body, Caption), line-height, text truncation.
4. **Color & Surface System**: Background surfaces, cards, borders, shadows/elevation, active/inactive accent colors.
5. **Component Identification**: Locate buttons, chips, list items, toggles, badges, avatars, search fields.

### Phase 3: Minimal Surgical Plan
State your plan before writing code:
- Target files to create or modify.
- Existing components and design tokens identified for reuse.
- Resolution for any ambiguous UI details in the screenshot.

### Phase 4: Implementation
1. **Structure First**: Build skeleton layout using semantic containers.
2. **Component Integration**: Inject existing project components first, configuring props to match the reference.
3. **Styling & Spacing**: Apply project design tokens for colors, spacing, borders, and shadows.
4. **Interactions & Accessibility**: Ensure interactive elements have click/tap targets (minimum 44x44 pt/dp), accessible labels, and proper keyboard focus states where applicable.

### Phase 5: Verification & Anti-Regression
1. **Compilation Check**:
   - Run the fastest project-appropriate type-check or compilation:
     - TypeScript/Web: `npx tsc --noEmit` or `npm run type-check`
     - Flutter: `flutter analyze`
     - Android: `./gradlew compileDebugSources` or lint
     - iOS/Swift: `swift build` or xcodebuild dry-run
   - If the build or test environment cannot be run (e.g. sandbox restrictions, missing local SDK, or missing emulators), explicitly report `Build/Test: NOT RUN` with the exact reason. Do not assume or claim tests passed without execution.
2. **Git Diff Audit**:
   - Run `git status --short` and `git diff --stat`.
   - Verify that **NO** unrelated files, configuration files, or package locks were touched inadvertently.

### Phase 6: Final Verification Report
Every response must conclude with a standardized summary:
1. **Files Modified/Created**: Exact paths and brief purpose.
2. **Reused Assets & Tokens**: Which project components/colors were utilized.
3. **Build & Typecheck Results**: Passed cleanly or explicit `NOT RUN` with reason.
4. **Visual Deviations & Trade-offs**: Any minor visual gaps (e.g. specific custom icon replaced with standard project icon, or fonts not bundled).
5. **Cross-Platform Note**: Remind if corresponding feature/contract changes are needed for parity on other target platforms to satisfy acceptance criteria.
