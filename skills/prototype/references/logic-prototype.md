# Logic prototype

The start gate in SKILL.md applies first. This branch specifies one self-contained HTML page that lets anyone drive a state model by clicking buttons. The package puts the specification in the build request from SKILL.md, and the orchestrator writes the file. Use it when the question is about business rules, state transitions or the shape of data: things that read fine on paper and only feel wrong once real cases are pushed through them.

Because the page is one file with nothing to install, the owner can open it, and so can a domain expert the owner hands it to. It therefore speaks the language of the domain, not the language of the code.

## When this shape fits

- "I'm not sure this state machine handles X and then Y."
- "Does this data model let me represent the case where..."
- "I want to feel out what the interface should be before we write it."
- Any question where a person wants to press buttons and watch state change.

If the question is what something should look like, this is the wrong branch. Use `ui-prototype.md`.

## Process

### 1. State the question

Before any code, write the question as one visible paragraph at the top of the page, not only in a comment: which state model, and what is being asked of it. A demo that answers the wrong question is wasted, and a visible question can be checked later by someone who was not in the room.

### 2. Keep the logic in a small pure module

Put the part that answers the question in one script block, written as a pure module with no page in it. The right shape depends on the question:

- a reducer, `(state, action)` to the next state, when actions are discrete events and the state is one value;
- an explicit state machine, when "which actions are even allowed right now" is part of the question;
- a few pure functions over a plain data type, when there is no current state to track;
- a small object with a clear method surface, when the logic really owns changing internal state.

Choose by what the question needs, not by what is easiest to wire to a page. The module never touches the page, and nothing flows from the module to the page except return values. The page calls the module and draws the result. This is what lets a routed implementation lift the module out later once the question is answered; the page around it stays throwaway.

### 3. Build the page

One file of plain HTML, CSS and script: no framework, no bundler, no server, everything inline, so it opens by double-click and survives being sent around. Labels are domain words. Buttons and state read like the business, and a line of plain text explains what just happened.

Top to bottom:

1. A title and a one-line description of what the demo lets you explore, taken from the question in step 1.
2. The current state as a readable panel with labeled fields, not a raw data dump. It is redrawn after every click, and what just changed is called out.
3. Free-play buttons, one per action, always available, so anyone can try things in any order.
4. Guided walkthroughs, one per tab. Each tab has a short description of the situation it sets up and what to watch for, then the ordered buttons to press. Starting a walkthrough resets to a known state so it runs the same way each time.

Pick scenarios that show the awkward cases: the normal path, one tricky edge, and an attempt at something that should be impossible. Keep the look restrained: clear type, generous spacing, one accent color, no animation.

### 4. Hand it over

Give the orchestrator the file path as a run request, with what the first screen should show. This package has not written or opened the page, and the report says so. The owner clicks through when there is time. The valuable moments are the ones where the owner says "that shouldn't be possible" or "I assumed X would work differently", because each one is a flaw in the idea, which is what the demo is for. If the owner wants another action or scenario, add it. Prototypes change as the question sharpens.

### 5. Capture the answer

When the demo has answered its question, write the answer note described in SKILL.md. The validated module is a starting point for routed work. The page is not.

## Anti-patterns

- Tests. A prototype that needs tests has stopped being one.
- The real database or any real service. Keep state in memory unless persistence is the question.
- Generalising. The demo answers one question.
- Mixing the module and the page. If the module reads the page, it cannot be lifted.
- A framework, a bundler or a server. One file that opens by double-click is the point.
- Putting the page into production. It is built for being clicked through by hand.
