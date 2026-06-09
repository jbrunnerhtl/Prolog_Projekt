## 1. Setup & Map Definition

- [ ] 1.1 Define static predicates for map connections (standard doors, vents, trapdoors) in `granny.pl`
- [ ] 1.2 Declare dynamic predicates for player position, item locations, hiding status, trap status, and day count
- [ ] 1.3 Implement procedural item placement algorithm to randomly distribute key items to search spots at startup

## 2. CLI Parser & Game Loop

- [ ] 2.1 Implement raw terminal input reader, lowercasing, and whitespace tokenization
- [ ] 2.2 Implement the core recursive game loop handling game state evaluations (death, escape) and turn progression
- [ ] 2.3 Add custom help command detailing commands and game usage

## 3. Movement & Basic Actions

- [ ] 3.1 Implement walking via `go [Richtung]` with connectivity validation (silent action)
- [ ] 3.2 Implement running via `run [RichtungA] [RichtungB]` with multi-step movement and destination noise generation
- [ ] 3.3 Implement hiding commands `hide`, `unhide`, and `wait`, disabling Granny's attack capability when hidden

## 4. Item Interactions & Inventory

- [ ] 4.1 Implement `inspect [Möbel]` to reveal hidden items in containers (drawers, cabinets)
- [ ] 4.2 Implement `take [Gegenstand]` with 1-item limit validation
- [ ] 4.3 Implement `drop [Gegenstand]` placing the item in the room, checking weight to trigger noise events

## 5. Granny AI & Noise Propagation

- [ ] 5.1 Implement BFS shortest path search algorithm to find distance and direction between rooms
- [ ] 5.2 Implement sound propagation alerting Granny and steering her state to alert/tracking
- [ ] 5.3 Implement passive distance indicators ("Dielen knarren...", "Du hörst ein entferntes Schlurfen...") based on path length
- [ ] 5.4 Implement Granny's random wandering state machine when she is not alert

## 6. Traps, Tools, and Obstacles

- [ ] 6.1 Implement bear trap carrying and placement `place trap`
- [ ] 6.2 Implement player bear trap trigger, disabling movements, and the 3-step `break_out` mechanics (generating noise)
- [ ] 6.3 Implement Granny trap trigger immobilizing and incapacitating her for 3 turns
- [ ] 6.4 Implement key container interactions (safe requiring `safe_key`, well requiring `well_crank`)

## 7. Escapes, Days, and Final Polish

- [ ] 7.1 Implement the 7-day system and player/Granny state reset logic on player death
- [ ] 7.2 Implement multi-lock front door escape checks (hammer, code, keys, wire cutters)
- [ ] 7.3 Implement garage car assembly escape checks (battery, motor, sparkplug, wrench, car_key)
- [ ] 7.4 Verify final compilation, run the SWI-Prolog game console, and document launch commands
