# Boundary discipline

## Rule

Put validation, type narrowing and error handling at the points where data enters or leaves the system. Inside the system, trust typed data and let errors propagate. Keep business logic in pure functions and keep the code that touches the outside world thin and mechanical.

## Why

Validation scattered through the code is noisy and repeats itself, and it gives a false sense of safety, because the checks that matter are not the ones in the middle of a call chain. Logic that is tangled up with framework wiring can only be tested through the framework.

A boundary is any place where the system does not control the shape of the data: command-line arguments, configuration files, network protocols, external APIs, files and messages written by something else.

## The pattern

- At a boundary: validate, return errors, and handle input defensively.
- Inside the system: typed data, error propagation, no re-validation.
- Across a boundary: expose domain concepts, not the boundary's private representation. Keep general-purpose mechanism inside and special-purpose policy at the edge.

## Checks

1. Is this data crossing a system boundary right now? If not, a validation here is redundant. Remove it or move it to where the data came in.
2. Is configuration validated when it is parsed, not inside business logic that runs later?
3. Is raw input turned into a domain type once, at the edge, so everything after that point receives the typed value?
4. Does any transport, storage, framework or wire type leak through a public surface that other code depends on?
5. Is there a null or shape check deep in a call chain for a fact the boundary already guaranteed? Cite where the boundary validates. If no outer guarantee can be cited, report the check as not established; the inner check is then a symptom of check 3, not a redundant one.
6. Can this function be pure, with the shell simply calling it? If yes, extract it. Typical candidates are parsers (raw bytes to typed state), prompt or message builders (structured state in, string out), and scoring or assessment (state to result).
7. Can the logic be tested without starting the framework, server or process that hosts it?

## Example

A request handler parses a JSON body into a dictionary and passes it down. Four inner functions each begin with `if user is None or "email" not in user`. None of them agrees on what a valid user is, and one of them accepts an empty string.

Parse the body once at the handler into a `User` value that cannot exist without a valid email. Delete the four inner checks. The functions receive a `User` and have nothing left to validate, and the handler is the only place that can return a validation error.

## When it does not apply

- Trust inside the system is only justified when the types are actually enforced. In an untyped area, or for data written earlier by an older version of the code, treat the read as a boundary and validate it.
- Security and authorization checks belong where the protected resource is accessed, even if an outer layer already checked. Repeating those is deliberate defense in depth, not redundant validation.
- An internal interface that becomes a published one (a module other teams call, an extension point) is a boundary from that point on.
- Very small scripts where a separate pure core would be larger than the script.
- Frameworks that dictate where validation happens. Follow the framework's seam, and keep the domain logic outside it.
