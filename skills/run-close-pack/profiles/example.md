Example profile: fictional project, not a real setup.

# run-close-pack profile: Lanternworks

Lanternworks is an invented small web shop used only to show the fields. Copy this file into your own project, rename it and replace every value. Fields marked (full path only) are needed only when a build is closed; a text-only close may leave them out. Every other field is required, and a missing or blank required field stops the close at step 1.

- (full path only) build command: `npm run build:release` (produces the upload bundle from a clean checkout).
- (full path only) upload bundle name: `lanternworks-web-<version>-<close-sha>.zip` (the file the store consumes).
- (full path only) source snapshot name: `lanternworks-<version>-<close-sha>.zip`.
- (full path only) identity string format: `<version> / <close-sha-short>`, shown in the footer of the running product.
- (full path only) serve port and folder: `8400`, `~/serve/lanternworks/<version>`.
- texts folder: `~/notes/releases/<date>-lanternworks-<version>-texts/`.
- text pipeline steps: spell-check, house-style lint, peer read, final polish (in that order, each stamped in the sweep record).
- previous public version: `v1.4.0` (published on `<date>`, close sha `<sha>`; bump after every public upload).
- durable evidence store path: `~/notes/releases/evidence/`.
- channel path: `~/code/lanternworks/.runs/<run-id>-channel.md`.
- channel retention: kept in the project for its life; a copy lands in the evidence store at close.
- (full path only) worker cap: 4 (the unit-test runner's own cap; check its config before every run).
- (full path only) load threshold: 4.0.
- (full path only) report interval: 15 (minutes between coordinator report points).
- (full path only) artifact shape: entry file `index.html`, manifest file `package.json`.
- (full path only) pack folder: `~/notes/releases/<date>-lanternworks-<version>-pack/`.
- close docs folder: `docs/`.
- (full path only) pack owners: the bundle lane owns evidence, assets, index and the test inventory; the orchestrator owns the public texts and the playtest script.
