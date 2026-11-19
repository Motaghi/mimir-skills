# Experience first

This file is what to look at when judging a prototype, and what to build into it. When what is easy to build conflicts with what is good for the person using the result, the person wins.

## The principle

- Every feature, control and option has to earn its place. If it cannot be justified from the user's side, it goes.
- Ship fewer things and ship them well. A polished experience with three features beats a rough one with ten.
- Prototype before committing. A design decision is cheaper to change in a throwaway page than in production code, which is why this package exists.
- Get the small things right: transitions, alignment, spacing, feedback and error states are where people feel quality.
- Keep the core loop tight. Each feature serves the central task or stays out of its way.

## Who the user is

The user is whoever consumes the work. For a screen that is the end user. For a library or an internal interface it is the colleague who will import it. The engineer who maintains the code next is a user too. Weigh each one's experience the same way, and describe the impact from their point of view.

## How it relates to other principles

The foundations file in engineering-principles governs the order of work: what to settle before building on it. This principle governs the target: what the finished thing should feel like. They do not compete. Use the first to sequence the work and this one to choose what the work is for.

## What to look at in a prototype

- Does the first screen make the main action obvious without explanation?
- What is on screen that does not need to be?
- Where does the person wait, guess or backtrack?
- What happens on the awkward path: empty state, wrong input, a second try?
- Would a variant with less in it do the same job?

State these as questions for the owner on the decision page. The package asks them and records the owner's answers. It does not answer them for the owner.

## The project's own gate wins

Where a project has its own test for experience, that test decides, and this file only supplies questions to bring to it. Examples are a team's usability checklist or a first-run review. Wording used in such a test follows the project's approved wording. Never apply one project's gate to another project.

## When it does not apply

- A question that is purely about correctness, such as whether a calculation or a state transition is right. A logic prototype answers it, and delight does not enter into it.
- A constraint set by law, security or a signed agreement. Those outrank convenience for the user.
- Work where the user has already chosen the experience and only the implementation is open.
