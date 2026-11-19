# UI prototype

The start gate in SKILL.md applies first. This branch specifies several structurally different variants of one screen, switchable in the browser, so that the owner can flip between them, pick one or take parts from each, and let the rest go. The package puts the specification in the build request from SKILL.md, and the orchestrator writes it in the isolated checkout it names, never in the shared working tree.

## When this shape fits

- "What should this page look like?"
- "Show me a few options for this dashboard before we commit."
- "Try a different layout for the settings screen."
- Any case where a person would otherwise spend a day choosing between three vague mockups in their head.

If the question is about rules or state, use `logic-prototype.md`. If the question is a UX plan or a design brief with no building yet, that is not this package.

## Two ways to host the variants

A variant is much easier to judge next to the rest of the app: the real header, the real navigation, real data and real density. A separate empty page makes every variant look fine. So prefer the first way below, and use the second only when nothing nearby can host the variants.

**A. Inside an existing page (preferred).** The route already exists. The variants are drawn on that same route and chosen by a `variant` URL parameter. The route, its parameters and the interface the page renders from stay as they are, so the variants see the same shape of data the real page gets. The live loaders do not stay: in the isolated checkout each is replaced by a fixture of invented data in that same shape, and the page needs no real session, credential or service. Only the rendering changes. If the thing has no page yet but would naturally sit inside one (a new section of a dashboard, a new card on a settings screen, a new step in an existing flow), it is still this case: mount the variants in the host page.

**B. A new page (last resort).** Only for a surface with no sensible home, such as a new top-level area. Add a throwaway route that follows the project's routing convention, with "prototype" in the path or file name, and the same `variant` parameter. Before choosing this, check again that no existing page could host it.

## Process

### 1. State the question and choose how many

Default to three variants. More than five turns into noise, so five is the cap. Write the plan in one line in the prototype's location, for example: "Three variants of the settings page, chosen with the variant parameter, on the existing settings route."

### 2. Make the variants differ in structure

Each variant is built from the page's purpose, the data it has, and the project's own component library and styling. Give each a clear component name such as `VariantA`.

Variants must differ in layout, in how information is ordered, and in the main thing the user is invited to do. Different colors or different copy are a tweak, not a variant. If two drafts come out alike, redo one with an explicit ban on the shared pattern, for example "no card grid". Variants may share small parts such as a header. They may not share the layout, or the point is lost.

Variants are read-only and read invented fixtures. If one needs to change something, point it at a stub: the question is what it should look like, not whether the back end works. Shown wording follows the start gate: approved wording only, otherwise marked placeholder text.

### 3. Wire a switcher

Keep the page's rendering interface above the switcher, fed by the fixture loader, and draw one variant based on the parameter, defaulting to the first. Add one small switcher component to the route.

The switcher is a fixed pill at the bottom center of the screen with a previous arrow, a label showing the current key and the variant's name if it has one, and a next arrow. Both arrows wrap around. Choosing a variant updates the URL through the framework's own router, so the choice survives a reload and can be shared. The left and right arrow keys also cycle, except while a text field or an editable area has focus. The pill should look clearly different from the page so nobody mistakes it for part of the design. It is hidden in production builds, using the project's existing check for a production build, so a stray merge cannot show it to users. Put it in one shared component so both hosting ways reuse it.

### 4. Hand it over

Give the orchestrator the run request: the command that starts the project and the address to open, with each variant's key, and the service isolation from the build request (no live credentials, no real services, fixtures only). This package has not written, started or opened anything, and the report says so. For the decision page, supply the content: each variant's key and name, one line on what it is trying, and what to look for. The orchestrator takes screenshots through its browser route. The best feedback is usually a combination, such as "the header from B with the sidebar from C", and that combination is the design the owner wants.

### 5. Capture and clean up

Once the owner has chosen, write the answer note from SKILL.md: which variant won, what the owner took from the others, and why. Folding the winner into the real page is routed implementation, and it is rewritten properly rather than copied, because prototype code was written without tests or error handling. The losing variants and the switcher do not go into the real code. The orchestrator removes the isolated checkout unless the owner asks to keep the variants, in which case the orchestrator names a folder for them.

## Anti-patterns

- Variants that differ only in color or copy.
- Variants that share a layout.
- Variants wired to real changes of data, or fed by live loaders. Use stubs and invented fixtures.
- Promoting a variant straight to production. Rewrite it properly.
- Leaving the switcher or the losing variants in the real code. They go stale quickly and confuse the next reader.
- Editing the shared working tree. Everything here is requested for the isolated checkout only.
