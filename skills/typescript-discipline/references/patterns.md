# TypeScript patterns

Code for the rules in `SKILL.md`, keyed by rule number. This file is read together with `SKILL.md`, which defines the rules and the hot-path exceptions; it is not a rule set on its own. The examples are illustrations, not templates to paste. Names that stand for something the repository already owns, such as its schema library, are placeholders.

## Rule 1: discriminated unions

Give every variant a literal discriminant. Pick one name for it (`kind`, `type` or `tag`) and keep it across the code base.

```ts
// Loose: contradictory combinations compile.
type Upload = { done: boolean; url?: string; error?: string };

// Tight: only real states can be written.
type Upload =
  | { kind: "uploading"; sentBytes: number }
  | { kind: "done"; url: string }
  | { kind: "failed"; error: string };
```

## Rule 2: constructive modeling

Build the shape so the illegal value cannot be constructed.

```ts
type NonEmpty<T> = [T, ...T[]];

// Loose: every caller must remember the empty case.
function pickFirstWinner(entries: string[]): string {
  const first = entries[0];
  if (first === undefined) throw new Error("no entries");
  return first;
}

// Tight: an empty input cannot be passed.
function pickFirstWinner(entries: NonEmpty<string>): string {
  return entries[0];
}
```

When a plain array arrives, narrow it once and let the fact travel in the type.

```ts
const isNonEmpty = <T>(items: T[]): items is NonEmpty<T> => items.length > 0;
```

Even length, as pairs, and a range, as a start plus a duration:

```ts
type Pairs<T> = [T, T][];

// Loose: a comment holds the invariant "start <= end".
type LooseRange = { start: Date; end: Date };

// Tight: a range is a start plus a duration. The constructor validates every input, the fields
// are ECMAScript #private slots holding numbers, getters return fresh dates, and each instance
// is frozen. make() is the named way in.
class TimeRange {
  readonly #startMs: number;
  readonly #durationMs: number;

  private constructor(start: Date, durationMs: number) {
    const startMs = start.getTime();
    if (!Number.isFinite(startMs) || Number.isNaN(new Date(startMs).getTime())) {
      throw new RangeError("Start must be a valid date");
    }
    if (!Number.isFinite(durationMs) || durationMs < 0) {
      throw new RangeError(`Duration must be a non-negative number: ${durationMs}`);
    }
    if (Number.isNaN(new Date(startMs + durationMs).getTime())) {
      throw new RangeError("End falls outside the supported date range");
    }
    this.#startMs = startMs;
    this.#durationMs = durationMs;
    Object.freeze(this);
  }

  static make(start: Date, durationMs: number): TimeRange {
    return new TimeRange(start, durationMs);
  }

  get start(): Date {
    return new Date(this.#startMs);
  }

  get durationMs(): number {
    return this.#durationMs;
  }

  // Derive the end when needed.
  get end(): Date {
    return new Date(this.#startMs + this.#durationMs);
  }
}
```

The compiler rejects a bare object literal, a spread of an existing range with a new `durationMs`, an object that spells out a brand, and a direct `new` from outside the class. At runtime a validated instance, read directly, keeps the invariant against the usual escapes, because the checks sit in the constructor itself (so reflection such as `Reflect.construct` meets them too), the `#private` slots cannot be reached from outside, the start is copied into a number so later mutation of the caller's `Date` cannot affect the range, and the frozen instance cannot have its getters shadowed with `Object.defineProperty`. Use `#private` slots, not the `private` keyword alone: `private` is checked only by the compiler, so `Object.assign(range, { durationValue: -1 })` would overwrite a `private` field at runtime with no diagnostic. A plain `{ start: Date; durationMs: number }` type, or a brand on such a type, still lets a caller replace the validated field, so do not claim the guarantee for either. Claim only what the example enforces: the compiler rejections listed above, and a constructor that validates every instance it creates. A `Proxy` around a range, or other code that wraps or rewrites the class, can still report different values, so the guarantee covers validated instances read directly, not wrappers.

## Rule 3: simplest total type

Keep the plain array while every operation on it is total.

```ts
const total = (xs: number[]) => xs.reduce((a, b) => a + b, 0); // [] gives 0, so this is fine
```

Strengthen when the loose type forces a lie at a use site. The tells are `!`, `items[0] as T`, and a throw that says it cannot happen.

```ts
// Partiality hidden from the compiler. The list is ordered newest first.
function newest(sessions: Session[]): Session {
  return sessions.at(0)!;
}

// Option A: strengthen the input, and the assertion disappears. Position 0 of a
// non-empty tuple is known to exist, even with unchecked indexed access turned on.
function newest(sessions: NonEmpty<Session>): Session {
  return sessions[0];
}

// Option B: widen the result, so the empty case is a visible answer.
function newest(sessions: Session[]): Session | undefined {
  return sessions.at(0);
}
```

## Rule 4: branded types

```ts
type OrderId = string & { readonly __brand: "OrderId" };

const ORDER_ID = /^ord_[a-z0-9]{12}$/;

function isOrderId(input: string): input is OrderId {
  return ORDER_ID.test(input);
}

function parseOrderId(input: string): OrderId {
  if (!isOrderId(input)) throw new Error(`Not an order id: ${input}`);
  return input;
}

function shipOrder(id: OrderId): void {
  // the id is trusted here
}
```

Use the brand shape the repository already has. Do not introduce a second convention.

## Rule 5: `unknown` over `any`

```ts
// Loose: every access is unchecked.
function readName(input: any) {
  return input.user.name;
}

// Tight: the compiler forces the narrowing, and no cast is needed.
function readName(input: unknown): string | undefined {
  if (typeof input !== "object" || input === null || !("user" in input)) return undefined;
  const user = input.user;
  if (typeof user !== "object" || user === null || !("name" in user)) return undefined;
  return typeof user.name === "string" ? user.name : undefined;
}
```

This needs a TypeScript version that narrows unlisted properties with `in`. It also shows what hand-narrowing costs, which is the reason rule 7 exists. Prefer a schema where the repository has one.

## Rules 6 and 7: parse at the boundary, schema first

Validate once where data enters. Before writing a property-by-property guard, look for the repository's schema library and its existing schemas. Let one schema own both the check and the type.

```ts
// "schema" and "Infer" stand for the repository's own schema library.
const InvoiceSchema = schema.object({
  id: schema.string(),
  status: schema.oneOf(["open", "paid"]),
  lines: schema.array(schema.object({ sku: schema.string(), qty: schema.number() })),
});

type Invoice = Infer<typeof InvoiceSchema>;

function parseInvoice(input: unknown): Invoice {
  return InvoiceSchema.parse(input);
}

// Downstream code receives an Invoice and checks nothing again.
function totalQuantity(invoice: Invoice): number {
  return invoice.lines.reduce((sum, line) => sum + line.qty, 0);
}
```

Use the library's non-throwing parse when failure is an expected branch. If the repository has no schema library, a hand-written guard that checks every property is acceptable, and adding a library is a decision for the orchestrator to take to the owner. Never add a new dependency for a single guard.

When the type comes first, annotate the schema with the type it must prove. The compiler then rejects a schema that proves less than the type.

```ts
type User = { id: string; name: string };
const UserSchema: Validator<User> = schema.object({ id: schema.string(), name: schema.string() });
// Remove "name" from the schema and the line above stops compiling.
```

At other boundaries:

- Wire formats: ignore unknown fields so that a newer sender does not break an older reader.
- Persisted JSON: store a version with the blob and wrap the parse so a bad blob becomes a handled error.
- Do not re-validate deep inside the call chain.

## Rule 8: no unchecked `as`

```ts
// Unchecked: a wrong payload crashes later, far from the cause.
const user = data as User;

// Checked: the schema from rules 6 and 7 proves the claim.
const user = parseUser(data);
```

When removing an existing `as`, find out why inference failed and fix that:

- A missing discriminant: add one and switch to a union.
- A source type that is too wide, such as `Record<string, unknown>`: narrow it.
- An untyped boundary: parse with the schema that owns the shape, and add a schema only where none exists.
- A genuinely inexpressible case: use a brand or `satisfies`.

## Rule 9: narrowing order

From best to last resort:

1. A discriminant switch or `if`. The compiler narrows without help.
2. The `in` operator, which narrows to the variants that have the key.
3. `typeof` and `instanceof` for primitives and class instances.
4. A user-defined guard, when the above cannot express the check.
5. `as`, only after validation.

```ts
function area(s: Shape): number {
  if ("radius" in s) return Math.PI * s.radius ** 2; // narrowed to the circle
  return s.width * s.height; // narrowed to the rectangle
}
```

## Rule 10: honest guards

A guard must verify what its signature claims.

```ts
// Honest: the check is the claim.
function isCircle(s: Shape): s is Extract<Shape, { kind: "circle" }> {
  return s.kind === "circle";
}

// Lying: it proves less than it claims.
function isUser(data: unknown): data is User {
  return typeof data === "object" && data !== null;
}
```

Prefer discriminant narrowing over a guard whenever it is available.

## Rule 11: exhaustiveness

In the default arm, assign the narrowed union value to a `never` local. A new variant then breaks the build.

```ts
// Value-returning switch
function area(s: Shape): number {
  switch (s.kind) {
    case "circle":
      return Math.PI * s.radius ** 2;
    case "rect":
      return s.width * s.height;
    default: {
      const unhandled: never = s;
      return unhandled;
    }
  }
}

// Statement switch
function draw(s: Shape): void {
  switch (s.kind) {
    case "circle":
      drawCircle(s);
      break;
    case "rect":
      drawRect(s);
      break;
    default: {
      const unhandled: never = s;
      void unhandled;
    }
  }
}
```

A default arm that does nothing, or only breaks, hides the new variant until a user finds it.

## Rule 12: `satisfies` over `as`

```ts
type Settings = { theme: "dark" | "light"; columns: number };

// An assertion: the value is treated as a Settings, whatever it contains.
const asserted = { theme: "dark", columns: 3 } as Settings;

// Checked against Settings. Because Settings admits the literal "dark", theme keeps that type.
const settings = { theme: "dark", columns: 3 } satisfies Settings;

// When the target type is wider, such as Record<string, string>, satisfies does not keep the
// literals. Add `as const` where they must be preserved.
const routes = { home: "/", about: "/about" } as const satisfies Record<string, string>;
```

## Rule 13: derive, do not duplicate

```ts
// Duplicate: drifts when the generated type changes.
type CheckSummary = { totalCount: number; checks: { name: string; status: string }[] };

// Derived from the type that owns the shape.
import type { ChecksMessage } from "<generated module>";
type CheckSummary = Pick<ChecksMessage, "totalCount" | "checks">;
```

Reach for `Pick`, `Omit`, `Parameters`, `ReturnType`, `Awaited` and `typeof` before declaring a new interface.

## Rule 14: object arguments

```ts
// Swap two numbers and it still compiles.
openRange(file, 10, 1, 10, 40);

// Order-independent and self-describing.
openRange({ file, start: { line: 10, column: 1 }, end: { line: 10, column: 40 } });
```

Hot-path exception: on code that runs once per frame or per token, or inside a tight parsing or rendering loop, positional arguments are fine. The claim needs evidence, either a profile that shows the cost or a cited file and line showing the code sits in such a loop. "Probably hot" is not evidence, and without evidence the options object stays. An excepted rule is reported as not applicable, with the evidence cited.

## Rule 15: real tests

Prefer running the real thing to mocking it. If a database, a parser or a queue can run locally in a test, run it. Use the test framework's own primitives, including its checks for leaked handles and undisposed resources. Mock only what cannot run locally, such as a third-party service that charges money. For interface work, check the behavior in a running build, not only in a unit test.

## Rule 16: structured diagnostics

```ts
// Hard to search and nothing to join on.
console.log("failed " + id);

// Structured, with the id to debug from.
logger.warn({ event: "export_failed", exportId, attempt, reason });
```

Hot-path exception: inside a per-frame, per-token or tight parsing or rendering loop, structured context is not required. Log at the edge of the loop or sample. The claim needs the same evidence as for rule 14, a profile or a cited file and line, and without it rule 16 applies in full. An excepted rule is reported as not applicable, with the evidence cited.

## When it does not apply

This file inherits the exclusions in `SKILL.md` and cannot activate the rules on its own. Attach `SKILL.md` with it.

- Code that is not TypeScript, generated or vendored files, and throwaway scripts.
- A typing rule that a project instruction sets differently on purpose.
- Hot-path code, for rules 14 and 16 only, and only with the evidence `SKILL.md` requires.
- The examples are illustrations. Names such as `schema`, `Infer`, `Validator`, `logger` and the generated module stand for what the repository already owns, and the repository's own conventions win over these shapes.
