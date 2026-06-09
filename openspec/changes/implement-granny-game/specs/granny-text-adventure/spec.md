## ADDED Requirements

### Requirement: Player Movement
The system SHALL support player movement via walking (`go [Richtung]`) and running (`run [RichtungA] [RichtungB]`). Walking moves the player 1 room silently. Running moves the player through 2 rooms consecutively and MUST generate a loud noise at the destination.

#### Scenario: Walking to an adjacent room
- **WHEN** the player enters `go east` from a room connected east to the garage
- **THEN** the player moves to the garage and no noise is generated.

#### Scenario: Running through two rooms
- **WHEN** the player enters `run east south`
- **THEN** the player moves east and then south, and a loud noise event is generated in the south room.

---

### Requirement: Item Interactions
The system SHALL allow players to inspect furniture (`inspect [Möbel]`), pick up discovered items (`take [Gegenstand]`), and drop carried items (`drop [Gegenstand]`). Dropping a heavy item (such as `car_battery` or `motor`) MUST generate a loud noise, whereas dropping a light item (such as `padlock_key`) SHALL be silent. The player MUST carry at most 1 item at a time.

#### Scenario: Inspecting furniture reveals hidden item
- **WHEN** the player enters `inspect drawer` in a room where a drawer holds `padlock_key`
- **THEN** the `padlock_key` is revealed to be present in the room and is now available to be taken.

#### Scenario: Dropping a heavy item generates noise
- **WHEN** the player enters `drop car_battery`
- **THEN** the `car_battery` is placed on the floor of the current room and a loud noise is generated.

#### Scenario: Dropping a light item is silent
- **WHEN** the player enters `drop padlock_key`
- **THEN** the `padlock_key` is placed on the floor of the current room silently.

---

### Requirement: Hiding Mechanics
The system SHALL allow players to hide in rooms with hiding spots using the `hide` command, wait with the `wait` command, and emerge with the `unhide` command. While a player is hidden, Granny entering or occupying the same room MUST NOT cause a game over.

#### Scenario: Hiding prevents death when Granny enters
- **WHEN** the player enters `hide` in a room containing a closet and Granny enters the room
- **THEN** the player remains alive and the game does not trigger a game over.

---

### Requirement: Noise-Driven NPC AI
The system SHALL manage Granny's movements turn-by-turn. By default, Granny SHALL wander randomly. If a loud noise event is generated anywhere in the house, Granny's state MUST transition to alert, and she SHALL pathfind along the shortest path to the noise source room.

#### Scenario: Granny hears a noise and moves towards it
- **WHEN** a loud noise is generated in the garage and Granny is in the living room
- **THEN** Granny's AI moves her towards the garage on her next turn.

---

### Requirement: Bear Traps
The system SHALL support placing and triggering bear traps. If Granny walks into a room with a placed bear trap, she MUST be trapped and disabled for 3 turns. If the player walks into their own bear trap, they SHALL be trapped and must execute `break_out` 3 times consecutively to escape, with each breakout attempt generating a loud noise.

#### Scenario: Granny triggers a bear trap
- **WHEN** Granny enters a room where the player has placed a bear trap
- **THEN** Granny is immobilized and incapacitated for 3 turns, and the player is notified.

#### Scenario: Player triggers own bear trap
- **WHEN** the player walks into a room where they placed a bear trap
- **THEN** the player becomes trapped, cannot move, and must enter `break_out` three times to get free.

---

### Requirement: Escapes
The system SHALL check for escape conditions on each turn. The player can escape via the front door (by removing the wooden barricade, cutting smart lock cables and cellar fuse box cables, entering the code, unlocking the padlock, and using the master key) or via the car (by installing the battery, motor, and spark plug, tightening the motor with the wrench, and starting the car with the car key).

#### Scenario: Successful escape via the front door
- **WHEN** the player performs the final escape action on the front door
- **THEN** the game triggers a victory screen and terminates.

#### Scenario: Successful escape via the car
- **WHEN** all car parts are installed and tightened, and the player uses `car_key`
- **THEN** the game triggers a victory screen and terminates.

---

### Requirement: Lives and Days System
The system SHALL track player days. The player starts with 7 days. If Granny occupies the same room as the player and the player is not hidden (and Granny is not trapped/stunned), the player dies. The day counter SHALL decrement by 1, and the game state resets the player and Granny to their starting rooms. If days reach 0, it is Game Over.

#### Scenario: Player dies and a new day begins
- **WHEN** Granny occupies the same room as the player and the player is not hidden or protected
- **THEN** the player dies, the day count is decremented, and both the player and Granny are reset to their starting positions.
