# UI Design System Rules

## Purpose

These rules govern ALL admin dashboard UI work. Follow them exactly when creating or modifying components, pages, widgets, or layouts. They produce consistent, professional interfaces without requiring design review.

---

## 1. Visual Hierarchy

Visual hierarchy is the single most important design concept. Every screen must have a clear reading order.

### Size Hierarchy

- Page title (H1): `text-xl` or `text-2xl`, `font-semibold` — ONE per page
- Section title (H2): `text-base` or `text-lg`, `font-semibold`
- Subsection title (H3): `text-sm`, `font-semibold`
- Body text: `text-sm`, `font-normal`
- Supporting/muted text: `text-xs` or `text-sm`, `text-ui-fg-muted`
- NEVER skip levels (no H1 then H3 without H2)
- NEVER make two elements on screen compete for the same visual weight

### Color Hierarchy (Three Tiers)

- **Primary text** (`text-ui-fg-base`): Main content the user must read — titles, table cell values, form labels
- **Secondary text** (`text-ui-fg-subtle`): Supporting information — descriptions, timestamps, metadata
- **Tertiary text** (`text-ui-fg-muted`): Least important — placeholders, disabled text, helper text, empty-state dashes

### Contrast Hierarchy

- Important elements: high contrast against background (dark on light)
- Secondary elements: medium contrast (grey on light)
- Disabled elements: low contrast
- NEVER use pure black (`#000`) on pure white (`#fff`) — use the design system's `fg-base` and `bg-base` tokens
- WCAG AA minimum: 4.5:1 for body text, 3:1 for large text (18px+ or 14px+ bold)

### Spatial Hierarchy

- More important content gets more surrounding whitespace
- Primary content area gets the most space
- Related items are closer together; unrelated items are farther apart (Law of Proximity)
- Group related elements with less gap; separate groups with more gap

### Position Hierarchy (F-Pattern)

- Most important information: top-left
- Primary action buttons: top-right of the relevant section
- Secondary actions: below or to the right of primary actions
- Page layout follows the inverted pyramid: key info at top, details below

---

## 2. Spacing System

Use a consistent spacing scale. NEVER use arbitrary pixel values.

### The Scale (Base: 4px)

```
0.5 = 2px    (micro adjustments only)
1   = 4px    (tight: between icon and label)
1.5 = 6px    (rare)
2   = 8px    (compact: between related items in a group)
3   = 12px   (standard: between form fields, list items)
4   = 16px   (comfortable: section inner padding)
5   = 20px   (spacious)
6   = 24px   (section padding, card padding)
8   = 32px   (between sections)
10  = 40px   (large gaps)
12  = 48px   (page-level spacing)
16  = 64px   (major page sections)
```

### Spacing Rules

- **Card/Container padding**: `px-6 py-4` (24px horizontal, 16px vertical) — this is the Medusa admin standard
- **Between form fields**: `gap-4` (16px) vertically
- **Between form field groups**: `gap-6` (24px) or a divider
- **Between sections on a page**: `gap-y-2` on the outer wrapper (8px between Container cards)
- **Button group gap**: `gap-2` (8px)
- **Icon-to-text gap**: `gap-1.5` (6px) or `gap-2` (8px)
- **Table cell padding**: Use Medusa DataTable defaults; do not override
- **NEVER have zero padding** on content containers
- **NEVER mix padding scales** within the same visual level (e.g., `px-4` on one card and `px-8` on an adjacent card)
- Start with MORE whitespace than you think you need, then reduce — not the other way around

### Consistent Inner Padding Pattern

```tsx
// CORRECT — Medusa admin standard
<Container className="divide-y p-0">
  <div className="px-6 py-4">  {/* Header section */}
    <Heading level="h2">Title</Heading>
  </div>
  <div className="px-6 py-4">  {/* Content section */}
    {children}
  </div>
</Container>

// WRONG — inconsistent padding
<Container className="p-4">
  <div className="p-2">...</div>
  <div className="p-6">...</div>
</Container>
```

---

## 3. Typography

### Type Scale (Medusa UI Classes)

Use Medusa's `txt-*` utility classes when available. These map to tested size/weight/line-height combinations:

- `txt-xlarge` / `txt-xlarge-plus` — Page titles
- `txt-large` / `txt-large-plus` — Section headings
- `txt-medium` / `txt-medium-plus` — Subheadings, emphasized body
- `txt-small` / `txt-small-plus` — Standard body text, descriptions
- `txt-compact-small` / `txt-compact-small-plus` — Table cells, compact UI
- `txt-compact-xsmall` / `txt-compact-xsmall-plus` — Badges, tags, metadata

The `-plus` variants add `font-weight: 500` (medium weight). Use them for emphasis within a level.

### Line Height

- Headings: tight line-height (1.2-1.3) — handled by `txt-*` classes
- Body text: relaxed line-height (1.5) — handled by `txt-*` classes
- NEVER set `leading-none` on multi-line text

### Font Weight Hierarchy

- `font-normal` (400): Body text, descriptions, table cells
- `font-medium` (500): Emphasized body, navigation labels, subtle headings
- `font-semibold` (600): Section titles, column headers, important labels
- `font-bold` (700): Page titles only — use sparingly
- NEVER use more than 3 font weights on a single screen

### Line Length

- Body text: max-width of `45-75 characters` (roughly `max-w-prose` or `max-w-xl`)
- Form fields: match the expected input length (email = wider, zip code = narrower)
- NEVER let body text span the full container width on wide screens

---

## 4. Color Usage

### The 60-30-10 Rule

- **60% — Background/neutral**: `bg-ui-bg-base`, `bg-ui-bg-subtle` — the canvas
- **30% — Secondary**: `bg-ui-bg-component`, borders (`border-ui-border-base`), cards — structural elements
- **10% — Accent**: Brand/primary buttons, active states, badges — draws the eye

### Semantic Colors (Use ONLY for Their Intended Meaning)

- **Green** (`green` badge, `text-ui-fg-positive`): Success, active, enabled, complete
- **Red** (`red` badge, `text-ui-fg-error`): Error, destructive, critical, failed
- **Orange/Yellow** (`orange` badge, `text-ui-fg-warning`): Warning, pending, needs attention
- **Blue** (`blue` badge, `text-ui-fg-interactive`): Links, informational, selected
- **Grey** (`grey` badge, `text-ui-fg-muted`): Inactive, disabled, neutral

### Color Rules

- NEVER use semantic colors decoratively (no red text for non-error content)
- NEVER use more than ONE accent color per section
- NEVER rely on color alone to convey information — always pair with text, icons, or patterns
- Use `text-ui-fg-interactive` for all clickable text links
- Destructive buttons use `variant="danger"` — NEVER make a danger button the primary/default action
- Disabled states: reduce opacity OR use muted foreground — not both

---

## 5. Button Hierarchy

Every screen must have a clear button hierarchy. NEVER give all buttons the same visual weight.

### Button Prominence (Most to Least)

1. **Primary** (`<Button>`): The ONE main action on the page — "Create", "Save", "Submit". Filled, brand-colored.
2. **Secondary** (`<Button variant="secondary">`): Alternative actions — "Cancel", "Export", "Filter". Outlined or muted fill.
3. **Ghost/Transparent** (`<Button variant="transparent">`): Tertiary actions — "Clear", "Reset", icon-only actions.
4. **Danger** (`<Button variant="danger">`): Destructive actions — "Delete", "Remove". Red, used sparingly.

### Button Rules

- ONE primary button per visual section (not per page — a modal can have its own primary)
- Primary button goes on the RIGHT in button groups (Save on right, Cancel on left)
- In the Medusa admin toolbar pattern: primary action is top-right of the header area
- Button size should match context: `size="small"` in table rows/toolbars, default size in forms/modals
- ALWAYS show loading state on async buttons: `isLoading={true}` during submission
- Destructive actions REQUIRE a confirmation step (modal/dialog)
- NEVER place two primary buttons side-by-side
- NEVER use a link styled as a button for navigation; use `asChild` with a `<Link>` inside a Button

---

## 6. Component Patterns

### Data Tables

```
REQUIRED elements:
+-- Toolbar
|   +-- Title (H1 for page-level, H2 for section-level)
|   +-- Count badge or subtitle ("24 manufacturers")
|   +-- Search input (if >10 expected rows)
|   +-- Primary action button ("Create")
+-- Table
|   +-- Column headers (left-aligned for text, right-aligned for numbers)
|   +-- Sortable columns (where relevant)
|   +-- Row click navigation (navigate to detail page)
|   +-- Consistent cell formatting
+-- Pagination (if >20 rows)
+-- Empty state (if 0 rows)
```

- Left-align text columns, right-align numeric columns
- ALWAYS include an empty state — NEVER show a blank table
- Use Medusa's `DataTable` component with `useDataTable` hook
- Row density: use DataTable defaults; do not add custom row padding
- Clickable rows: use `onRowClick` to navigate to detail views
- Row height standards: condensed 40px, regular 48px, relaxed 56px
- Sticky headers during vertical scroll
- Sort chevrons must not interfere with header text alignment

### Empty States

Every data-driven component MUST have an empty state with:

1. **An icon or illustration** (subtle, muted color)
2. **A headline** explaining the state ("No manufacturers yet")
3. **A description** suggesting what to do ("Create your first manufacturer to get started")
4. **A call-to-action** button (if the user can resolve the state)

```tsx
// Empty state pattern
<div className="flex flex-col items-center gap-3 py-10">
  <Buildings className="h-8 w-8 text-ui-fg-muted" />
  <div className="flex flex-col items-center gap-1">
    <Text className="txt-medium-plus">No manufacturers yet</Text>
    <Text className="txt-small text-ui-fg-muted text-center max-w-sm">
      Create your first manufacturer to organize products by brand.
    </Text>
  </div>
  <Button size="small" variant="secondary" asChild>
    <Link to="/manufacturers/create">Create manufacturer</Link>
  </Button>
</div>
```

### Forms

```
REQUIRED elements:
+-- Page/modal title describing the action ("Create manufacturer")
+-- Field groups with visual separation (dividers or spacing)
+-- Labels (ABOVE the field, NEVER inside as placeholder-only)
+-- Required field indicators (asterisk or "(required)" text)
+-- Helper text below field (when input format is non-obvious)
+-- Inline validation errors (below the field, in red, with icon)
+-- Form actions
|   +-- Cancel (secondary, LEFT)
|   +-- Submit (primary, RIGHT)
+-- Loading state on submit button
```

- Group related fields visually (name + handle together, address fields together)
- Use appropriate input widths — email is wider than zip code
- Show validation errors inline, directly below the offending field
- NEVER clear the form on validation error — preserve user input
- NEVER validate while the user is still typing — validate on blur or submit
- Error messages must be specific: "Name is required" not "This field is required"
- Show a loading/disabled state on the submit button during async operations

### Cards and Containers

- Use Medusa's `<Container>` component with `divide-y p-0` pattern
- Each logical section gets its own `<Container>`
- Use the `SectionContainer` component for title + description + content pattern
- Stack multiple containers with `gap-y-2` wrapper
- NEVER nest containers inside containers

### Modals and Drawers (FocusModal / Drawer)

- Title clearly states the action ("Edit manufacturer", "Delete product?")
- Close button in top-right (provided by Medusa components)
- Action buttons at the bottom: Cancel (left) + Primary (right)
- Destructive modals: describe consequences, require explicit confirmation
- NEVER open a modal from within another modal
- NEVER use a modal for content that should be a page (if it has its own URL, it is a page)

### Toast Notifications

- Success: after create/update/delete operations complete
- Error: when an operation fails, with actionable message
- NEVER use toasts for validation errors (those go inline on the form)
- NEVER stack more than 3 toasts
- Keep toast messages under 10 words

### Loading States

- **Page-level loading**: Use Medusa's DataTable `isLoading` prop — shows skeleton rows
- **Section loading**: Skeleton shapes matching the expected content layout
- **Button loading**: `isLoading` prop on the submit button
- **Inline loading**: Spinner next to the element being loaded
- EVERY async operation MUST have a visible loading indicator
- NEVER show a blank screen during loading

---

## 7. Layout Patterns

### List Page (e.g., /manufacturers)

```
Container (divide-y p-0)
+-- Toolbar (px-6 py-4)
|   +-- Left: Title + count
|   +-- Right: Search + Create button
+-- DataTable.Table
+-- DataTable.Pagination
```

### Detail Page (e.g., /manufacturers/[id])

```
Page wrapper (flex flex-col gap-y-2)
+-- Container: Header section
|   +-- Breadcrumb or back link
|   +-- Title + status badge
|   +-- Action buttons (Edit, Delete)
+-- Container: Primary information section
+-- Container: Secondary information section
+-- Container: Related data (table of linked items)
```

### Create/Edit Page

```
Page wrapper (flex flex-col gap-y-2) OR FocusModal
+-- Header: Title ("Create manufacturer")
+-- Form sections (each in its own Container or separated by dividers)
|   +-- Section 1: Basic info (name, handle, description)
|   +-- Section 2: Details (country, website, etc.)
|   +-- Section 3: Configuration (status, settings)
+-- Form actions bar
    +-- Cancel (secondary, navigates back)
    +-- Save (primary, submits form)
```

### Widget Pattern

```
SectionContainer
+-- title + description (in header area)
+-- Content area
    +-- Data display (key-value pairs, mini-tables, badges)
    +-- Actions (edit button, links)
```

---

## 8. Responsive Considerations

- The Medusa admin is primarily a desktop application (min-width ~1024px)
- Use `grid` with responsive columns for form layouts: `grid grid-cols-1 md:grid-cols-2 gap-4`
- Tables should scroll horizontally on narrow viewports rather than stack
- Modals: use `FocusModal` for complex forms (full-screen on mobile)
- Drawers: use for supplementary content that does not warrant a full page
- NEVER use fixed pixel widths on content — use max-width + fluid widths
- Test at 1280px and 1440px as primary viewport targets

---

## 9. Interaction States

EVERY interactive element MUST have these states defined:

- **Default**: Normal appearance
- **Hover**: Subtle background change or color shift (Medusa UI handles this for its components)
- **Active/Pressed**: Slightly darker than hover
- **Focus**: Visible focus ring (`focus-visible:shadow-borders-focus`) for keyboard navigation
- **Disabled**: Reduced opacity (50%), cursor not-allowed, no pointer events
- **Loading**: Spinner or skeleton replacing content

### Specific Rules

- Table rows: hover background (`bg-ui-bg-hover` or similar)
- Links: underline on hover, color change
- Buttons: all states handled by Medusa UI — do NOT override
- Form inputs: border color change on focus, red border on error
- NEVER remove focus outlines for accessibility

---

## 10. Icons

- Use `@medusajs/icons` exclusively — NEVER import from other icon libraries
- Icons are SUPPORTING elements — they accompany text, not replace it (except in compact toolbars where tooltip is provided)
- Icon sizes: `h-4 w-4` (default inline), `h-5 w-5` (standalone/nav), `h-8 w-8` (empty states)
- Icons in buttons: place BEFORE the text label, with `gap-1.5`
- NEVER use icons without either a visible label or an `aria-label`/`title` attribute
- Match icon color to adjacent text color

---

## 11. Anti-Pattern Checklist

Before submitting any UI work, verify NONE of these are present:

- [ ] All buttons have the same visual weight (missing primary/secondary distinction)
- [ ] A data list has no empty state (blank space when no items)
- [ ] An async operation has no loading indicator
- [ ] Error messages are generic ("Something went wrong" with no detail)
- [ ] Destructive action has no confirmation dialog
- [ ] Form validation only fires on submit (no inline feedback)
- [ ] Text spans full container width on large screens (no max-width)
- [ ] Multiple competing CTAs at the same prominence level
- [ ] Inconsistent spacing (some cards have p-4, others p-6)
- [ ] Labels inside inputs as the only label (disappears on focus)
- [ ] Icon-only buttons without tooltips or aria-labels
- [ ] Missing hover states on clickable elements
- [ ] Color used as the sole differentiator (no text/icon backup)
- [ ] Nested containers/cards creating visual depth confusion
- [ ] Form that loses data on navigation without warning

---

## 12. Medusa Admin Specific Patterns

These are patterns observed in the existing codebase. Follow them for consistency.

### Route Configuration

```tsx
export const config = defineRouteConfig({
  label: "Page Name",
  icon: IconComponent,
});
```

### Data Fetching

```tsx
const { data, isLoading } = useQuery<ResponseType>({
  queryFn: () =>
    sdk.client.fetch("/admin/endpoint", { query: { limit, offset } }),
  queryKey: ["entity", "list", limit, offset],
  placeholderData: (prev) => prev, // Prevents flash during pagination
});
```

### Container + DataTable Assembly

```tsx
<Container className="divide-y p-0">
  <DataTable instance={table}>
    <DataTable.Toolbar className="flex items-center justify-between px-6 py-4">
      <div>
        <Heading level="h1">Title</Heading>
        <Text className="text-ui-fg-muted txt-small mt-0.5">{count} items</Text>
      </div>
      <div className="flex items-center gap-2">
        <DataTable.Search placeholder="Search..." />
        <Button size="small" asChild>
          <Link to="create">Create</Link>
        </Button>
      </div>
    </DataTable.Toolbar>
    <DataTable.Table />
    <DataTable.Pagination />
  </DataTable>
</Container>
```

### Table Cell Patterns

```tsx
// Name with avatar/icon + subtitle
<div className="flex items-center gap-3">
  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-ui-bg-subtle
       text-ui-fg-muted txt-compact-medium-plus">
    {name.charAt(0).toUpperCase()}
  </div>
  <div className="flex flex-col">
    <span className="txt-compact-small-plus">{name}</span>
    <span className="txt-compact-xsmall text-ui-fg-muted">{subtitle}</span>
  </div>
</div>

// Status badge
<Badge color={isActive ? "green" : "grey"}>
  {isActive ? "Active" : "Inactive"}
</Badge>

// Empty cell (no data)
<span className="text-ui-fg-muted">{"\u2014"}</span>

// External link
<a href={url} target="_blank" rel="noopener noreferrer"
   className="flex items-center gap-1 text-ui-fg-interactive txt-compact-small
              hover:text-ui-fg-interactive-hover"
   onClick={(e) => e.stopPropagation()}>
  {label}
  <ArrowUpRightOnBox className="h-3.5 w-3.5" />
</a>
```

---

## Quick Reference: Decision Matrix

| Scenario             | Do This                      | Not This                       |
| -------------------- | ---------------------------- | ------------------------------ |
| Primary page action  | ONE filled button, top-right | Multiple filled buttons        |
| Secondary actions    | Outlined/ghost buttons       | Same style as primary          |
| Empty data list      | Icon + message + CTA         | Blank space                    |
| Loading data         | Skeleton/spinner             | Blank space or frozen UI       |
| Error on form field  | Red text below field         | Alert banner at top only       |
| Destructive action   | Confirmation modal           | Immediate deletion             |
| Navigation to detail | Row click                    | Explicit "View" button per row |
| Null/missing value   | Em-dash in muted color       | Empty cell or "N/A"            |
| Related items count  | Badge or subtitle text       | Separate column                |
| Status indicator     | Colored Badge component      | Colored text without badge     |
