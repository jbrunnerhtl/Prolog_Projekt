# Continuation Prompt: Prolog Granny Text Adventure

## System Context & Goal
The goal of this project is to implement a terminal-based horror text adventure game in **Prolog** (SWI-Prolog) inspired by the mobile game "Granny". The player must escape a locked house within 7 days (lives) while avoiding Granny, who tracks noise using dynamic pathfinding.

## Current State
1. **Planning Complete**: An OpenSpec change named `implement-granny-game` has been fully specified and approved. All artifacts are completed:
   - [proposal.md](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/openspec/changes/implement-granny-game/proposal.md) (Objectives, Scope, Capabilities)
   - [spec.md](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/openspec/changes/implement-granny-game/specs/granny-text-adventure/spec.md) (Normative requirements & WHEN/THEN test scenarios)
   - [design.md](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/openspec/changes/implement-granny-game/design.md) (BFS pathfinding choice, dynamic state design, parser decisions)
   - [tasks.md](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/openspec/changes/implement-granny-game/tasks.md) (Checkbox tasklist for implementation)
2. **Git Status**: 
   - All planning artifacts and cleanup modifications are committed to the `develop` branch.
   - Pushed and tracked upstream at `origin/develop` on `git@github.com:jbrunnerhtl/Prolog_Projekt.git`.

## Technical Specifications
- **Target runtime**: SWI-Prolog
- **State storage**: Dynamic database facts (`:- dynamic`) for item positions, player status, and NPC alerts.
- **Granny AI**: Uses BFS (Breadth-First Search) to compute shortest path to loud noise sources.
- **Map Layout**: 3 floors (OG, EG, Keller) and a Garden, with door, vent, and trapdoor connections specified in [granny-map.png](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/asciidocs/docs/images/granny-map.png).

## Next Steps for the Next Session
1. **Enter Implementation Mode**: Run `/opsx:apply` to transition from planning to implementation.
2. **First Action**: Begin working on **Task 1.1** inside [tasks.md](file:///home/jan/Desktop/HTL-3-Jahrgang/Loal/Projekt/openspec/changes/implement-granny-game/tasks.md):
   - Define static predicates representing the room layout connections in `granny.pl` (e.g. `door/3`, `vent/3`, `trapdoor/3` based on the map layout).
