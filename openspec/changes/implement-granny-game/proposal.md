## Why

Implement a Prolog-based horror text adventure game inspired by the mobile game "Granny" as a school project. This utilizes Prolog's logic programming paradigm to manage complex room pathfinding, dynamic game state, and rule-based NPC behavior.

## What Changes

- Create the Prolog source code containing the game logic, command loop, parser, and map.
- Implement the movement systems (`go` and `run`) with associated noise generation.
- Implement room interaction commands: `inspect`, `interact`, `take`, `drop`, `install`, `place trap`, and `break_out`.
- Implement hiding spot states (`hide`, `unhide`, and `wait`).
- Implement the dynamic distance warning and noise tracking alert system.
- Implement the bear trap system for both Granny and the player.
- Implement procedural item randomization at game startup.

## Capabilities

### New Capabilities

- `granny-text-adventure`: Covers the full game rules, map definition, state tracking, command parser, item database, and Granny's pathfinding AI.

### Modified Capabilities

<!-- None -->

## Impact

- Addition of a core Prolog file (`granny.pl`) for the game runtime.
- Addition of testing and execution scripts to run the game in a terminal console (e.g. with SWI-Prolog).
