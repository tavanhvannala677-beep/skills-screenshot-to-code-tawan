---
name: screenshot-to-code
description: High-fidelity implementation or adjustment of UI screens and components from visual references (Screenshots, Figma, Mockups) across modern platforms and frameworks (React, Next.js, Vue, Flutter, SwiftUI, Jetpack Compose, ArkTS/ArkUI, Angular, Svelte, HTML/Tailwind). Enforces strict architecture preservation, design token reuse, zero unauthorized dependencies, platform-accurate touch targets, and rigorous verification.
---

# Universal Screenshot to Code (Production Standard)

## Mission
Transform visual references (Screenshots, Figma exports, Design Mockups) into production-grade UI code that matches the reference appearance with precision, while strictly preserving the project's existing framework, design tokens, component library, architecture, and cross-platform contracts.

---

## 🛑 Non-Negotiable Guardrails (Zero Loopholes)

1. **Zero Unauthorized Dependencies**:
   - NEVER run `npm install`, `yarn add`, `pnpm add`, `pub add`, or add new dependencies to Gradle/Maven/Cocoapods/SPM/ohpm unless the user explicitly commands it.
   - If a specific icon or asset is missing, use existing project assets, vector drawables/SF Symbols/SVGs, or nearest built-in equivalents.

2. **Design Token & Component Priority**:
   - NEVER hardcode raw color hexes (e.g. `#1E40AF`), raw margins, or ad-hoc border radii if the project provides theme tokens (Tailwind classes, CSS variables, `MaterialTheme`, `Theme.of(context)`, SwiftUI Assets/Colors, ArkUI Resource tokens).
   - NEVER create low-level primitives (`<div onClick>`, raw `Box`) if the repository already has reusable components (e.g., `<Button>`, `<Card>`, `AppHeader`, `PrimaryTextField`).

3. **Scope & Multi-Platform Parity**:
   - Modify ONLY the target screen, component, and its direct navigation/route registration as requested.
   - For multi-platform projects (e.g., Android + iOS + HarmonyOS), keep changes aligned with shared API contracts and document any parity requirements across platforms.
   - DO NOT refactor unrelated screens, shared parent layouts, or global state models.
   - DO NOT run global linter or formatter (`prettier --write .`, `dart format .`) that mutates unrelated files.

4. **Responsive & Platform-Accurate Layout**:
   - DO NOT hardcode fixed viewport sizes (e.g. `width: 375px; height: 812px`) to match the screenshot device.
   - Implement proper responsive behavior (Flexbox, Grid, Auto-Layout, BoxWithConstraints) and respect Safe Area Insets (notches, status bars, navigation bars).
   - Follow platform-specific touch target minimums:
     - **Android (Material)**: minimum **48x48 dp**
     - **iOS (SwiftUI / UIKit)**: minimum **44x44 pt**
     - **Web**: minimum **44x44 px**

5. **No Invented Mock Data or States**:
   - DO NOT invent arbitrary data fields or synthetic models from the image without agreed fixtures or contract definitions.
   - Account for standard visual states (Loaded, Empty, Loading skeleton, and Error) when adjusting components.

6. **Anti-Hype & Honest Verification**:
   - Do NOT claim the UI is "pixel-perfect" or "zero regression" unless verified through actual rendering or test suites.
   - If the build or test environment cannot be run (e.g. sandbox restrictions, missing local SDK, or missing emulators), explicitly report `Build/Test: NOT RUN` with the exact reason.

---

## 📋 Mandatory 6-Phase Execution Workflow

### Phase 1: Stack & Architecture Reconnaissance
Before generating or modifying any UI file, run lightweight inspection to identify:
1. **Target Platform & Framework**:
   - Web: React, Next.js (App vs Pages router), Vue, Svelte, Angular.
   - Mobile: Jetpack Compose (Kotlin / Android), SwiftUI (Swift / iOS), Flutter (Dart).
   - HarmonyOS: ArkTS / ArkUI (check `entry/src/main/ets`, `build-profile.json5`).
   - Static: HTML5 + Tailwind CSS, SCSS, or Vanilla CSS.
2. **Styling & Design System**:
   - Inspect existing design tokens (colors, typography, spacing, shapes).
   - Locate reusable component library (e.g., `components/ui`, `common/widgets`, `core/presentation`).
   - Identify existing icon set (Material Icons, SF Symbols, custom SVG/Vector Drawables).
3. **State, Navigation & Contracts**:
   - Identify route registration, ViewModel/State management patterns, and shared data contracts.

### Phase 2: Visual Reference Deconstruction
Deconstruct the image systematically:
1. **Layout Hierarchy**: Header / App Bar ➔ Main Content Area (Scrollable vs Fixed) ➔ Footer / Bottom Navigation / Sticky CTA.
2. **Grid & Alignment**: Row/Column distribution, padding gutters, gap sizes, visual alignments.
3. **Typography & Surfaces**: Font family, weight hierarchy, text truncation, background surfaces, cards, borders, elevation.
4. **Interactive Components**: Buttons, chips, list items, toggles, badges, search fields.

### Phase 3: Minimal Surgical Plan
State your plan before writing code:
- Target files to create or modify.
- Existing components and design tokens identified for reuse.
- Resolution for any ambiguous UI details in the screenshot.

### Phase 4: Implementation
1. **Structure First**: Build skeleton layout using semantic containers.
2. **Component Integration**: Inject existing project components first, configuring props to match the reference.
3. **Styling & Spacing**: Apply project design tokens for colors, spacing, borders, and shadows.
4. **Interactions & Accessibility**: Ensure interactive elements have platform-appropriate touch targets (48dp on Android, 44pt on iOS) and accessible labels.

### Phase 5: Verification & Anti-Regression
1. **Compilation Check**:
   - Run the fastest project-appropriate type-check or compilation:
     - TypeScript/Web: `npx tsc --noEmit` or `npm run type-check`
     - Flutter: `flutter analyze`
     - Android: `./gradlew compileDebugSources` or lint
     - iOS/Swift: `swift build` or xcodebuild dry-run
     - HarmonyOS: `hvigorw --mode module -p module=entry assembleHap`
   - If build/test cannot be executed, explicitly report `Build/Test: NOT RUN (Reason: ...)`.
2. **Git Diff Audit**:
   - Run `git status --short` and `git diff --stat`.
   - Verify that **NO** unrelated files, configuration files, or package locks were touched.

### Phase 6: Final Verification Report
Every response must conclude with a standardized summary:
1. **Files Modified/Created**: Exact paths and brief purpose.
2. **Reused Assets & Tokens**: Which project components/colors were utilized.
3. **Build & Typecheck Results**: Passed cleanly or explicit `NOT RUN` with reason.
4. **Visual Deviations & Trade-offs**: Any minor visual gaps (e.g. custom icon replaced with standard project icon, or fonts not bundled).
5. **Cross-Platform / Parity Note**: Record whether corresponding updates are needed for other platforms (Android / iOS / HarmonyOS) or contract records.
