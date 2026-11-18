# Changelog

## v0.2.6 — MP batch core
- Added deterministic category/capacity batch planner, protected item filter and deduplication.
- Added guarded synchronous executor with source and target leases, validation, and release on adapter failure.
- Added mock tests and multiplayer result sheet. Native adapter remains intentionally disconnected; no MP item mutations enabled.


## v0.2.5 — MP lock prototype
- Added per-container leases and internal server lock service with canonical identity and authorization adapter requirements.
- Added regression tests and CI wiring; execution not yet verified.
- No live transfer integration or multiplayer mutation enabled.


## v0.2.4 — Multiplayer Foundation
- Added read-only server startup report and client context menu for native MinutesPerPage.
- Added policy tests and two-client test guide. No custom multiplayer mutations enabled.
- Native server reading preferences remain authoritative; actual runtime unverified.

## v0.2.2 — development alpha
- Extracted pure speed/profile rules and added Lua 5.1 unit tests and CI workflow (results not verified).
- Added independent reading-speed preference, exact-type custom loot profile, clearing storage labels, selected-container match report and timing-hook counter.
- Normalized persisted numeric settings. Runtime behavior remains unverified; no public release yet.

## v0.2.1 — Alpha
- Added 10x, 15x and 20x routine speed choices; capped timing multiplier at 20.
- Kept default speed 2x and independent XP settings.
- Prepared Workshop release kit, private initial visibility, English description and Turkish publishing instructions.
- Runtime and reading duration remain unverified.

## v0.2.0 — Full Alpha
- Combined six baseline modules into one client Lua file.
- Added selected-storage category labels, loot profiles, timing allowlist, optional XP, supplies and vehicle reports.
- Disabled multiplayer paths.
- Full automation not implemented.

## v0.1.0 — Alpha
- Initial same-type, same-category and unprotected batch transfers.
- Protected favorites/equipped gear and capped batches at 50.

## Repository import
- Canonical source preserved; docs and roadmap added. No gameplay changes intended.
