## Context

The project aims to implement a command-line horror text-adventure game in Prolog, inspired by the mobile game "Granny". The game has complex mechanics like dynamic pathfinding, randomized setup, a sound-alert system, hiding mechanics, and two alternative escape conditions. We will use SWI-Prolog as the target interpreter.

## Goals / Non-Goals

**Goals:**
- Implement the game map and connections (standard, vents, trapdoors) accurately based on the provided floor plan.
- Implement the procedural setup to randomize item locations.
- Implement the player state machine (carrying items, hidden, trapped in own trap).
- Implement Granny's pathfinding AI to track noise using a Breadth-First Search (BFS) algorithm.
- Implement the full console command parser supporting actions like `go`, `run`, `inspect`, `take`, `drop`, `install`, `place trap`, `break_out`, `hide`, `unhide`, and `wait`.
- Track the 7-day system and handle death-state resetting.

**Non-Goals:**
- Creating a graphical user interface (this is strictly a text-adventure in the terminal).
- Complex voice acting or audio output (audio/visuals are simulated purely through text descriptions).

## Decisions

### Decision 1: Game State Management via Dynamic Predicates
- **Option A**: Passing game state through argument recursion in the main loop.
- **Option B**: Using Prolog's dynamic database (`:- dynamic`) to assert/retract state facts.
- **Decision**: **Option B**. Since Prolog's database operates as a global state, managing multiple entities (player position, item locations, Granny's alert state, locked door status, trap locations) is much cleaner and less error-prone when using dynamic predicates instead of passing a giant state tuple through every recursive loop call.

### Decision 2: Parsing Command Line Inputs
- **Option A**: Standard Prolog term reader `read/1` which requires inputting terms ending with a dot (e.g. `go(north).`).
- **Option B**: Text parsing that reads raw lines, tokenizes them into lists of words, and uses pattern matching (e.g. `[go, north]`).
- **Decision**: **Option B**. Tokenizing raw user inputs is far more user-friendly as it does not require trailing periods or parentheses. We will read strings, lowercase them, and split them by whitespace.

### Decision 3: Granny AI Pathfinding Algorithm
- **Option A**: Depth-First Search (DFS).
- **Option B**: Breadth-First Search (BFS) to find the shortest path.
- **Decision**: **Option B**. When Granny is alerted by noise, she must move to the noise source using the shortest route. BFS guarantees the shortest path in an unweighted graph (the house map).

### Decision 4: Noise Propagation and Warning System
- **Option A**: Simulating distance by sound propagation waves.
- **Option B**: Standard path distance threshold warnings (0, 1, 2, or 3+ rooms away).
- **Decision**: **Option B**. Computing the path length between Granny's room and the player's room using our BFS algorithm provides a direct, robust way to trigger the correct text feedback (e.g., "Die Dielen knarren direkt neben dir" at distance 1).

### Decision 5: Traps & Stun Timers
- **Option A**: Managing timers as dynamic facts decremented on each turn.
- **Option B**: Storing timer state in the loop arguments.
- **Decision**: **Option A**. Placing a trap creates a dynamic fact `placed_trap(Room)`. If Granny enters, we assert `granny_disabled(3)`. Each turn, we decrement the value. This cleanly decouples the player's turns from Granny's active/inactive states.

## Risks / Trade-offs

- **[Risk]**: SWI-Prolog version differences or library availability for parsing.
  - *Mitigation*: Stick to standard built-in predicates like `read_line_to_string/2`, `split_string/4`, and list manipulation.
- **[Risk]**: Infinite loops in Granny's pathfinder if cyclic connections are not handled.
  - *Mitigation*: The BFS pathfinder will maintain a visited list to prevent revisiting rooms and looping infinitely.
