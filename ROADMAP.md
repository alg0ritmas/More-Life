# More Life roadmap

Primary target: friends playing together on a Build 42 dedicated multiplayer server. Single-player is secondary. Custom gameplay mutations remain single-player only; MP read-only policy is experimental.

Goal: reduce repetitive input and waiting, without removing meaningful survival choices. Time savings are targets, not measured results.

| Milestone | Scope | Status |
|---|---|---|
| v0.1.0 | Batch inventory transfer | Alpha |
| v0.2.0 | Six baseline modules | Alpha |
| v0.2.1 | 10x, 15x, 20x timing choices | Previous baseline |
| v0.2.2 | API review, rules extraction, tests, save normalization | Partially coded; runtime pending |
| v0.3 | Multi-container sorting, shared search, bag/trunk unload, custom profiles | Custom profile coded; other features pending |
| v0.4 | Independent reading speed, meaningful XP and progression | Reading preference coded; page timing and progression pending |
| v0.5 | Construction queues, cooking, farming, vehicle preparation | Planned |
| v0.6 | Measured time savings and translations | Hook counter coded; actual measurements and translations pending |
| v0.2.4 | Multiplayer-first architecture, server sandbox policy, command validation design | Read-only server/client policy coded; runtime pending |
| v0.2.5 | Per-container lock and internal server service | Prototype coded; adapter and runtime pending |
| v0.3-MP | Native synchronized reading and inventory integration; two-client tests | Pure batch planner/executor coded; native adapter and runtime pending |
| v0.9 | Server-authoritative multiplayer, permission and compatibility testing | Required before public MP release |
| v1.0 | Stable public Workshop release | Planned |
| v2.0 | Separate action extensions: threats, missions, danger zones, group operations | Planned |

## Acceptance gates
No item loss/duplication; native capacity and access constraints; protected gear; no intentional combat acceleration; no silent multiplayer mutations; documented supported game build; reproducible timing benchmarks. Public multiplayer alpha only after dedicated-server and two-client smoke tests. Never remove the current MP guard until the relevant server integration is verified. No release date committed.

## Reading UI enhancement
- Show total, read and remaining pages, progress percentage and estimated remaining reading time on skill-book information UI when supported by the installed Build 42 API.
- Estimate must account for server reading settings, day length and character modifiers where available; otherwise label estimate unavailable. No fabricated page counts for magazines.
- Real test feedback (Build 42.22.2, v0.2.6 local SP): mod and settings menu visible, user reports faster reading and timing-hook counter 24–27. Exact speed and page progress not yet measured.

## Smart Loot 2.0 — user-approved modes
- Selected: collect matching items from the selected container only (default).
- Nearby: one explicit command across accessible nearby containers, using native reach and capacity checks.
- Auto: opt-in collection while moving past accessible containers; off by default, easy stop, suspend during danger or combat, no repeated full scans.
- Per-player mode and multi-category profile selection; server controls allowed modes and limits. Respect favorites, equipment, private/shared storage permissions, container locks and capacity. No through-wall or remote looting. Native transfer integration and multiplayer tests required before enabling Nearby/Auto.
- Build 42.22.2 SP feedback: selected-container food loot works; adjacent containers require repeated manual command. Favorite protection and bidirectional batch transfer observed.
