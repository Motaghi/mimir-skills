# Deep modules

## Rule

Design modules that put a lot of behavior behind a small interface, place the interface at a seam where something really varies, and test through that interface. The payoff for callers is more capability per thing they must learn. The payoff for maintainers is that changes, bugs and verification concentrate in one place.

Terms used here: a module is anything with an interface and an implementation, at any scale from a function to a package. The interface is everything a caller must know to use it correctly: the type signature, but also invariants, ordering rules, error modes, required configuration and performance traits. A seam is a place where behavior can be changed without editing that place. An adapter is a concrete thing that fills an interface at a seam.

## Why

Depth is a property of the interface, not of the implementation. A module is deep when a large amount of behavior sits behind a small interface, and shallow when the interface is nearly as complex as the implementation. Shallow modules multiply the things a reader must learn without hiding anything.

## Checks

For each check, cite the module, its callers or its tests. A check with no citation is reported as unverified.

1. Deletion test: imagine deleting the module and see where its work goes. If only forwarding overhead disappears and nothing the caller needs is lost, it was a pass-through. If required complexity moves into one caller or into several, it was doing useful work; one caller is enough, there is no minimum count, and spread across several callers is the strongest sign. Distinguish overhead that disappears from useful behavior that merely moves. Name the callers it would move into.
2. Interface size: list everything a caller must know (signature, invariants, ordering, error modes, required configuration, performance traits). Is that list nearly as large as what the implementation does? Yes means the module is shallow. Name what could be removed or hidden.
3. Real seam: does something actually vary across this seam? One adapter makes a hypothetical seam, which is only indirection. Two adapters, typically production and test, make a real one. Name both adapters. A seam with one adapter fails.
4. Test surface: do callers and tests cross the same interface? No means the module may have the wrong shape, because tests have to reach past the interface.
5. Internal seams: are seams used only by the module's own tests kept private, instead of being exposed through the interface? No fails.
6. Testability: does the module accept its dependencies instead of creating them, and return results instead of changing its inputs? No fails.
7. Replace, do not layer: once tests at the deepened interface exist, are the old tests of the shallow modules deleted? No fails.

## Example

An order service is split into `OrderValidator`, `OrderPricer` and `OrderSaver`, each called only from `OrderService.place`. Each only forwards its argument to the next call and adds no rule of its own, and each has tests that stub the other two. Deleting any one of them removes forwarding and loses nothing the caller needs: the deletion test says they are pass-throughs. Line count is not the test. A three-line module that applied a real rule would be useful behavior that merely moves into its caller.

Merge them into one `place_order(order, payment)` with a small interface. Tests call that one function with real inputs. The only seam kept is the payment adapter, with a production and a test implementation.

## When it does not apply

- One-off scripts and glue code where a module boundary would be larger than the code.
- A seam with a single implementation that an outside contract requires. Keep it and say that the contract is the reason.
- Performance-critical paths where inlining is measured to matter. Cite the measurement.
- Generated or vendored code. Review the generator or its input.
- When the problem is the layers a reader must trace rather than module shape, see minimize-reader-load.md.
