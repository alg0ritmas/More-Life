# More Life roadmap

Primary target: friends playing together on a Build 42 dedicated multiplayer server. Single-player is secondary. Current code remains single-player only until multiplayer gates pass.

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
| v0.2.4 | Multiplayer-first architecture, server sandbox policy, command validation design | Highest priority; implementation pending |
| v0.3-MP | Native synchronized reading and inventory integration; two-client tests | Planned; blocks multiplayer release |
| v0.9 | Server-authoritative multiplayer, permission and compatibility testing | Required before public MP release |
| v1.0 | Stable public Workshop release | Planned |
| v2.0 | Separate action extensions: threats, missions, danger zones, group operations | Planned |

## Acceptance gates
No item loss/duplication; native capacity and access constraints; protected gear; no intentional combat acceleration; no silent multiplayer mutations; documented supported game build; reproducible timing benchmarks. Public multiplayer alpha only after dedicated-server and two-client smoke tests. Never remove the current MP guard until the relevant server integration is verified. No release date committed.
