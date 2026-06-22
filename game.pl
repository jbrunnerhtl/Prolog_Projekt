:- use_module(library(random)).

:- dynamic i_am_at/1.
:- dynamic at/2.
:- dynamic hidden_in/3.
:- dynamic turn_count/1.
:- dynamic granny_at/1.
:- dynamic granny_target/1.
:- dynamic game_over/0.
:- dynamic days_left/1.
:- dynamic hidden/0.
:- dynamic escaped/0.
:- dynamic installed/1.
:- dynamic lock_removed/1.
:- dynamic fuse_cut/0.
:- dynamic dev_seed/1.
:- dynamic granny_stunned/1.
:- dynamic pepper_charges/1.
:- dynamic trap_at/1.
:- dynamic granny_trap_frozen/1.
:- dynamic player_trapped/1.

:- retractall(i_am_at(_)).
:- retractall(at(_, _)).
:- retractall(hidden_in(_, _, _)).
:- retractall(turn_count(_)).
:- retractall(granny_at(_)).
:- retractall(granny_target(_)).
:- retractall(game_over).
:- retractall(days_left(_)).
:- retractall(hidden).
:- retractall(escaped).
:- retractall(installed(_)).
:- retractall(lock_removed(_)).
:- retractall(fuse_cut).
:- retractall(granny_stunned(_)).
:- retractall(pepper_charges(_)).
:- retractall(trap_at(_)).
:- retractall(granny_trap_frozen(_)).
:- retractall(player_trapped(_)).

i_am_at(bedroom_1).
turn_count(0).
granny_at(garage).
days_left(10).
pepper_charges(5).


path(garage,        u,      basement).
path(basement,      d,      garage).
path(basement,      u,      main_hall).
path(main_hall,     d,      basement).
path(main_hall,     u,      hallway).
path(main_hall,     n,      kitchen).
path(main_hall,     e,      living_room_2).
path(kitchen,       s,      main_hall).
path(kitchen,       e,      living_room_1).
path(living_room_1, w,      kitchen).
path(living_room_1, s,      living_room_2).
path(living_room_1, window, garden).
path(living_room_2, n,      living_room_1).
path(living_room_2, w,      main_hall).
path(garden,        window, living_room_1).
path(hallway,       d,      main_hall).
path(hallway,       n,      bedroom_1).
path(hallway,       e,      bedroom_2).
path(hallway,       s,      bedroom_3).
path(hallway,       w,      toilet).
path(bedroom_1,     s,      hallway).
path(bedroom_2,     w,      hallway).
path(bedroom_2,     s,      bedroom_3).
path(bedroom_3,     n,      bedroom_2).
path(bedroom_3,     e,      hallway).
path(toilet,        e,      hallway).
path(toilet,        n,      bedroom_1) :- at(screwdriver, in_hand), !.
path(toilet,        n,      _) :-
        write('A vent cover is screwed shut on the north wall.'), nl,
        write('You need a screwdriver to open it.'), nl,
        fail.
path(room_1,        d,      hallway).
path(hallway,       u,      room_1).
path(room_1,        u,      fourth_floor) :- at(special_key, in_hand), !.
path(room_1,        u,      _) :-
        write('The door to the upper floor is locked. You need the special_key.'), nl,
        fail.
path(room_1,        n,      room_2).
path(room_1,        e,      room_3).
path(room_2,        s,      room_1).
path(room_3,        w,      room_1).
path(fourth_floor,  d,      room_1).


furniture(car,            garage).
furniture(cabinet,        garage).
furniture(desk,           garage).
furniture(dresser,        garage).
furniture(safe,           basement).
furniture(desk,           basement).
furniture(electrical_box, basement).
furniture(well,           garden).
furniture(table,          living_room_1).
furniture(cabinet,        living_room_1).
furniture(sofa,           living_room_1).
furniture(cupboard,       living_room_1).
furniture(cabinet,        living_room_2).
furniture(cupboard,       living_room_2).
furniture(dresser,        main_hall).
furniture(main_door,      main_hall).
furniture(table,          kitchen).
furniture(upper_cabinet,  kitchen).
furniture(lower_cabinet,  kitchen).
furniture(cabinet,        kitchen).
furniture(microwave,      kitchen).
furniture(bed,            bedroom_1).
furniture(cupboard,       bedroom_1).
furniture(dresser,        bedroom_1).
furniture(bed,            bedroom_2).
furniture(cupboard,       bedroom_2).
furniture(cupboard,       bedroom_3).
furniture(bed,            bedroom_3).
furniture(dresser,        toilet).
furniture(wc,             toilet).
furniture(bathtub,        toilet).
furniture(dresser,        room_1).
furniture(cupboard,       room_2).
furniture(cabinet,        room_3).
furniture(cupboard,       room_3).
furniture(cupboard,       fourth_floor).
furniture(cabinet,        fourth_floor).


item(code).
item(padlock_key).
item(hammer).
item(wire_cutters).
item(master_key).
item(car_battery).
item(motor).
item(sparkplug).
item(wrench).
item(car_key).
item(pepper_spray).
item(safe_key).
item(special_key).
item(screwdriver).
item(bear_trap).
item(well_crank).

heavy(car_battery).
heavy(motor).

hideable(dresser).


valid_slot(cabinet,       garage).
valid_slot(desk,          garage).
valid_slot(desk,          basement).
valid_slot(table,         living_room_1).
valid_slot(cabinet,       living_room_1).
valid_slot(cupboard,      living_room_1).
valid_slot(cabinet,       living_room_2).
valid_slot(cupboard,      living_room_2).
valid_slot(table,         kitchen).
valid_slot(upper_cabinet, kitchen).
valid_slot(lower_cabinet, kitchen).
valid_slot(cabinet,       kitchen).
valid_slot(microwave,     kitchen).
valid_slot(bed,           bedroom_1).
valid_slot(cupboard,      bedroom_1).
valid_slot(bed,           bedroom_2).
valid_slot(cupboard,      bedroom_2).
valid_slot(cupboard,      bedroom_3).
valid_slot(bed,           bedroom_3).
valid_slot(cupboard,      room_2).
valid_slot(cabinet,       room_3).
valid_slot(cupboard,      room_3).
valid_slot(cupboard,      fourth_floor).
valid_slot(cabinet,       fourth_floor).

locked_3rd_room(room_2).
locked_3rd_room(room_3).
locked_3rd_room(fourth_floor).

placement_ok(special_key, _Furn, Room) :-
        \+ locked_3rd_room(Room).
placement_ok(Item, _Furn, _Room) :-
        Item \= special_key.

place_items :-
        ( dev_seed(N) -> set_random(seed(N)) ; true ),
        findall(I, item(I), Items),
        findall(F-R, valid_slot(F, R), Slots),
        place_items_loop(Items, Slots).

place_items_loop(Items, Slots) :-
        random_permutation(Slots, Shuffled),
        ( try_assign(Items, Shuffled, Pairs) ->
              maplist(assert_hidden, Pairs)
        ;     place_items_loop(Items, Slots)
        ).

try_assign([], _, []).
try_assign([Item | Items], Slots, [Item-(F,R) | Rest]) :-
        select_valid_slot(Item, Slots, F, R, RemainingSlots),
        try_assign(Items, RemainingSlots, Rest).

select_valid_slot(Item, [F-R | Rest], F, R, Rest) :-
        placement_ok(Item, F, R), !.
select_valid_slot(Item, [Skip | Rest], F, R, [Skip | Remaining]) :-
        select_valid_slot(Item, Rest, F, R, Remaining).

assert_hidden(Item-(F, R)) :-
        assert(hidden_in(Item, F, R)).

:- place_items.


n      :- go(n).
s      :- go(s).
e      :- go(e).
w      :- go(w).
u      :- go(u).
d      :- go(d).
window :- go(window).

go(_) :-
        game_over, !, over_msg.
go(_) :-
        escaped, !, escaped_msg.
go(_) :-
        hidden, !, blocked_hidden.
go(_) :-
        player_trapped(_), !, blocked_trapped.
go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look,
        check_player_trap, !,
        end_turn.
go(_) :-
        write('You can''t go that way.'), nl.

run(_, _) :-
        game_over, !, over_msg.
run(_, _) :-
        escaped, !, escaped_msg.
run(_, _) :-
        hidden, !, blocked_hidden.
run(_, _) :-
        player_trapped(_), !, blocked_trapped.
run(D1, D2) :-
        i_am_at(Here),
        path(Here, D1, Mid),
        path(Mid, D2, Dest), !,
        retract(i_am_at(Here)),
        assert(i_am_at(Dest)),
        write('You bolt through the house, footsteps hammering the floor!'), nl,
        look,
        make_noise,
        check_player_trap,
        end_turn.
run(_, _) :-
        write('You can''t run that way.'), nl.


look :-
        i_am_at(Place),
        nl,
        describe(Place),
        nl,
        notice_furniture(Place),
        list_exits(Place),
        notice_objects_at(Place),
        notice_trap(Place),
        notice_player_trapped,
        nl.

notice_furniture(Place) :-
        setof(F, furniture(F, Place), Fs), !,
        write('You can see: '), write_list(Fs), write('.'), nl.
notice_furniture(_).

list_exits(Place) :-
        setof(Dir, There^path(Place, Dir, There), Dirs), !,
        write('Exits: '), write_list(Dirs), write('.'), nl.
list_exits(_) :-
        write('There are no obvious exits.'), nl.

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' lying here.'), nl,
        fail.
notice_objects_at(_).

notice_trap(Place) :-
        trap_at(Place), !,
        write('A bear trap sits open and armed on the floor -- watch your step.'), nl.
notice_trap(_).

notice_player_trapped :-
        player_trapped(N), !,
        format('Your leg is caught in a bear trap. ~w pull(s) left to break free.~n', [N]).
notice_player_trapped.

write_list([]).
write_list([X])      :- !, write(X).
write_list([X | Xs]) :- write(X), write(', '), write_list(Xs).


inspect(_) :-
        game_over, !, over_msg.
inspect(_) :-
        escaped, !, escaped_msg.
inspect(_) :-
        hidden, !, blocked_hidden.
inspect(_) :-
        player_trapped(_), !, blocked_trapped.
inspect(F) :-
        i_am_at(Here),
        furniture(F, Here),
        hideable(F), !,
        write('The '), write(F),
        write(' is empty inside -- but big enough to climb into and hide.'), nl,
        end_turn.
inspect(safe) :-
        i_am_at(basement), !,
        ( at(safe_key, in_hand) ->
              inspect_container(safe, basement)
        ;     write('The safe is locked shut. You need the safe_key to open it.'), nl
        ).
inspect(well) :-
        i_am_at(garden), !,
        ( at(well_crank, in_hand) ->
              inspect_container(well, garden)
        ;     write('The well bucket is too far down to reach by hand. You need the well_crank.'), nl
        ).
inspect(electrical_box) :-
        i_am_at(basement), !,
        write('The fuse box is a tangle of cables, not something to rummage through.'), nl,
        write('Use  interact(electrical_box).  with wire_cutters to cut the power.'), nl.
inspect(car) :-
        i_am_at(garage), !,
        write('The car''s engine bay is open and waiting. You cannot search it --'), nl,
        write('use  install(Part).  to fit each missing component.'), nl.
inspect(main_door) :-
        i_am_at(main_hall), !,
        write('The door is sealed with locks and planks. Use  interact(main_door).'), nl,
        write('with the right item to remove each one in turn.'), nl.
inspect(F) :-
        i_am_at(Here),
        furniture(F, Here), !,
        findall(I, hidden_in(I, F, Here), Items),
        ( Items == [] ->
              write('You search the '), write(F),
              write(', but find nothing useful.'), nl
        ;     reveal_items(Items, F, Here)
        ),
        end_turn.
inspect(F) :-
        write('There is no '), write(F), write(' here to search.'), nl.

inspect_container(F, Here) :-
        findall(I, hidden_in(I, F, Here), Items),
        ( Items == [] ->
              write('You open it -- empty.'), nl
        ;     reveal_items(Items, F, Here)
        ),
        end_turn.

reveal_items([], _, _).
reveal_items([I | Is], F, Here) :-
        retract(hidden_in(I, F, Here)),
        assert(at(I, Here)),
        write('You find a '), write(I), write('.'), nl,
        !,
        reveal_items(Is, F, Here).


take(_) :-
        game_over, !, over_msg.
take(_) :-
        escaped, !, escaped_msg.
take(_) :-
        hidden, !, blocked_hidden.
take(_) :-
        player_trapped(_), !, blocked_trapped.
take(X) :-
        at(X, in_hand), !,
        write('You are already holding it.'), nl.
take(_) :-
        at(_, in_hand), !,
        write('Your hands are full. Drop what you are carrying first.'), nl.
take(X) :-
        i_am_at(Here),
        at(X, Here), !,
        retract(at(X, Here)),
        assert(at(X, in_hand)),
        write('You pick up the '), write(X), write('.'), nl, !, end_turn.
take(X) :-
        i_am_at(Here),
        hidden_in(X, _, Here), !,
        write('You do not see it lying out. Try searching the furniture.'), nl.
take(_) :-
        write('You do not see that here.'), nl.


drop :-
        game_over, !, over_msg.
drop :-
        escaped, !, escaped_msg.
drop :-
        hidden, !, blocked_hidden.
drop :-
        player_trapped(_), !, blocked_trapped.
drop :-
        at(X, in_hand), !,
        i_am_at(Here),
        retract(at(X, in_hand)),
        assert(at(X, Here)),
        write('You set down the '), write(X), write('.'), nl,
        ( heavy(X) ->
              write('It hits the floor with a deafening CRASH.'), nl,
              make_noise
        ;     true
        ), !,
        end_turn.
drop :-
        write('You are not holding anything.'), nl.


inventory :-
        at(X, in_hand), !,
        write('You are carrying: '), write(X), write('.'), nl,
        ( X == pepper_spray, pepper_charges(C) ->
              format('  (pepper spray: ~w charge(s) remaining)~n', [C])
        ;     true
        ).
inventory :-
        write('Your hands are empty.'), nl.

i :- inventory.

status :-
        nl,
        write('--- STATUS ---'), nl,
        days_left(D),
        format('Days left : ~w~n', [D]),
        turn_count(T),
        format('Turns     : ~w~n', [T]),
        i_am_at(Here),
        format('Location  : ~w~n', [Here]),
        ( at(Item, in_hand) ->
              format('Holding   : ~w~n', [Item])
        ;     write('Holding   : nothing'), nl
        ),
        car_parts_fitted(Fitted),
        car_parts_needed(Needed),
        ( Fitted == [] ->
              write('Car       : no parts fitted'), nl
        ; Needed == [] ->
              write('Car       : fully assembled -- need car_key'), nl
        ;     format('Car       : fitted ~w / still need ~w~n', [Fitted, Needed])
        ),
        findall(L, lock_removed(L), Removed),
        ( Removed == [] ->
              write('Front door: all locks in place'), nl
        ;     format('Front door: cleared ~w~n', [Removed])
        ),
        ( fuse_cut -> write('Fuse box  : power cut') ; write('Fuse box  : still live') ), nl,
        ( pepper_charges(C), C > 0 ->
              format('Pepper    : ~w charge(s)~n', [C])
        ;     true
        ),
        ( trap_at(R) ->
              format('Trap armed: in ~w~n', [R])
        ;     true
        ),
        write('--------------'), nl, nl.


car_needs(motor,       []).
car_needs(wrench,      [motor]).
car_needs(sparkplug,   [motor, wrench]).
car_needs(car_battery, [motor, wrench, sparkplug]).

prereqs_met([]).
prereqs_met([P | Ps]) :- installed(P), prereqs_met(Ps).

all_installed :-
        installed(motor), installed(wrench),
        installed(sparkplug), installed(car_battery).

install(_) :-
        game_over, !, over_msg.
install(_) :-
        escaped, !, escaped_msg.
install(_) :-
        hidden, !, blocked_hidden.
install(_) :-
        player_trapped(_), !, blocked_trapped.
install(car_key) :-
        i_am_at(garage), !,
        ( \+ at(car_key, in_hand) ->
              write('You are not holding the car_key.'), nl
        ; all_installed ->
              win_car
        ; write('You turn the key -- the engine just clicks, dead.'), nl,
          write('The car is still missing parts.'), nl
        ).
install(Part) :-
        i_am_at(garage),
        car_needs(Part, Prereqs), !,
        ( \+ at(Part, in_hand) ->
              format('You are not holding the ~w to fit it.~n', [Part])
        ; installed(Part) ->
              format('The ~w is already fitted.~n', [Part])
        ; \+ prereqs_met(Prereqs) ->
              install_blocked(Part)
        ; do_install(Part)
        ).
install(_) :-
        \+ i_am_at(garage), !,
        write('There is nothing to work on here. The car is in the garage.'), nl.
install(X) :-
        format('You cannot fit the ~w into the car.~n', [X]).

do_install(Part) :-
        retract(at(Part, in_hand)),
        assert(installed(Part)),
        install_msg(Part),
        car_progress_report,
        !, end_turn.

install_msg(motor) :-
        write('You heave the heavy motor block down into the engine bay.'), nl.
install_msg(wrench) :-
        write('You torque the motor mounts down tight with the wrench.'), nl.
install_msg(sparkplug) :-
        write('You thread the sparkplug into the cylinder head.'), nl.
install_msg(car_battery) :-
        write('You drop the battery into its cradle and clamp the terminals.'), nl.

install_blocked(wrench) :-
        write('There is no motor to tighten yet. Fit the motor first.'), nl.
install_blocked(sparkplug) :-
        write('Bolt the motor down with the wrench before the sparkplug.'), nl.
install_blocked(car_battery) :-
        write('Finish the motor and sparkplug before wiring in the battery.'), nl.

car_progress_report :-
        all_installed, !,
        write('That is everything. The car is whole -- now find the'), nl,
        write('car_key and use  install(car_key)  to start it.'), nl.
car_progress_report :-
        car_parts_needed(Needed),
        write('Fitted so far: '),
        car_parts_fitted(Fitted),
        ( Fitted == [] -> write('nothing yet') ; write_list(Fitted) ), write('.'), nl,
        write('Still needed (in order): '), write_list(Needed), write('.'), nl.

car_parts_fitted(Fitted) :-
        findall(P, ( member(P, [motor, wrench, sparkplug, car_battery]),
                     installed(P) ), Fitted).

car_parts_needed(Needed) :-
        findall(P, ( member(P, [motor, wrench, sparkplug, car_battery]),
                     \+ installed(P) ), Needed).


door_order([number_lock, padlock, barricade, smart_lock]).

lock_item(number_lock, code).
lock_item(padlock,     padlock_key).
lock_item(barricade,   hammer).
lock_item(smart_lock,  wire_cutters).

next_lock(Lock) :-
        door_order(Order),
        first_pending(Order, Lock).
first_pending([L | _], L) :- \+ lock_removed(L), !.
first_pending([L | Ls], Out) :- lock_removed(L), first_pending(Ls, Out).

all_locks_removed :- \+ next_lock(_).

interact(_) :-
        game_over, !, over_msg.
interact(_) :-
        escaped, !, escaped_msg.
interact(_) :-
        hidden, !, blocked_hidden.
interact(_) :-
        player_trapped(_), !, blocked_trapped.
interact(main_door) :-
        i_am_at(main_hall), !,
        door_interact.
interact(main_door) :- !,
        write('The front door is in the main hall, not here.'), nl.
interact(electrical_box) :-
        i_am_at(basement), !,
        box_interact.
interact(electrical_box) :- !,
        write('The fuse box is in the basement, not here.'), nl.
interact(car) :-
        i_am_at(garage), !,
        write('The car needs its parts fitted. Use  install(Part).  here.'), nl.
interact(safe) :-
        i_am_at(basement), !,
        write('You cannot interact with the safe directly. Use  inspect(safe).'), nl,
        write('with the safe_key to open it.'), nl.
interact(well) :-
        i_am_at(garden), !,
        write('You cannot interact with the well directly. Use  inspect(well).'), nl,
        write('with the well_crank to retrieve what is inside.'), nl.
interact(Obj) :-
        i_am_at(Here),
        furniture(Obj, Here), !,
        format('You examine the ~w closely, but there is nothing to do with it here.~n', [Obj]).
interact(_) :-
        write('There is nothing like that here to interact with.'), nl.

door_interact :-
        all_locks_removed, !,
        try_master_key.
door_interact :-
        next_lock(Lock),
        try_lock(Lock).

try_lock(Lock) :-
        lock_item(Lock, Needed),
        ( \+ at(Needed, in_hand) ->
              lock_prompt(Lock)
        ; Lock == smart_lock, \+ fuse_cut ->
              write('The smart lock''s panel is still live -- touch the cables'), nl,
              write('now and you will fry. Kill the power at the basement fuse box first.'), nl
        ; remove_lock(Lock)
        ).

remove_lock(Lock) :-
        assert(lock_removed(Lock)),
        lock_open_msg(Lock),
        door_progress_report,
        !, end_turn.

lock_prompt(number_lock) :-
        write('A keypad lock blinks red. You need the right code punched in.'), nl.
lock_prompt(padlock) :-
        write('A heavy padlock pins the chain. You need its key.'), nl.
lock_prompt(barricade) :-
        write('Planks are nailed across the frame. You need something to tear them off.'), nl.
lock_prompt(smart_lock) :-
        write('A smart lock is wired into the door. You need to cut its cables.'), nl.

lock_open_msg(number_lock) :-
        write('You key in the code. The keypad chirps and the bolt slides back.'), nl.
lock_open_msg(padlock) :-
        write('The padlock springs open and the chain rattles to the floor.'), nl.
lock_open_msg(barricade) :-
        write('You wrench the planks off the frame, nails shrieking.'), nl.
lock_open_msg(smart_lock) :-
        write('The dead smart lock pops loose under the cutters.'), nl.

door_progress_report :-
        all_locks_removed, !,
        write('The last lock gives. Only the deadbolt holds now --'), nl,
        write('open it with the master_key.'), nl.
door_progress_report :-
        findall(L, ( door_order(Os), member(L, Os), \+ lock_removed(L) ), Left),
        length(Left, N),
        format('That one yields. ~w lock(s) still to go.~n', [N]).

try_master_key :-
        at(master_key, in_hand), !,
        win_door.
try_master_key :-
        write('Every lock is broken and the barricade is down. The door'), nl,
        write('shifts in its frame, but a final deadbolt needs the master_key.'), nl.

box_interact :-
        fuse_cut, !,
        write('The fuse box is already dead, its wires hanging severed.'), nl.
box_interact :-
        \+ at(wire_cutters, in_hand), !,
        write('The fuse box is sealed behind a bundle of thick cables.'), nl,
        write('You need wire_cutters to get through them.'), nl.
box_interact :-
        assert(fuse_cut),
        write('You snip through the cable bundle. Somewhere the house'), nl,
        write('powers down with a dying whine -- the door''s smart lock is dead now.'), nl,
        !, end_turn.


win_car :-
        nl,
        write('You twist the key. The engine turns over once, twice -- then ROARS'), nl,
        write('to life with a sound like thunder trapped indoors. You stamp the'), nl,
        write('accelerator, hit the door opener, and the car tears out into the'), nl,
        write('cold night air. The house shrinks in the rear-view mirror.'), nl,
        write('You do not look back.'), nl,
        end_victory('YOU ESCAPED -- BY CAR').

win_door :-
        nl,
        write('The master key bites. The deadbolt gives with a heavy thud.'), nl,
        write('The front door swings wide and the night rushes in -- cold,'), nl,
        write('clean air after all that rot and dark. You run down the path'), nl,
        write('and do not stop running until the house is far behind you.'), nl,
        end_victory('YOU ESCAPED -- THROUGH THE FRONT DOOR').

end_victory(Banner) :-
        nl,
        write('========================================'), nl,
        write('  '), write(Banner), nl,
        write('========================================'), nl,
        days_left(D),
        turn_count(T),
        Used is 10 - D,
        ( Used =:= 0 ->
              write('Flawless run. Not a single day lost.'), nl
        ; Used =:= 1 ->
              write('One close call, but you made it out.'), nl
        ;     format('~w day(s) lost. ~w day(s) to spare.~n', [Used, D])
        ),
        format('Escaped in ~w turn(s).~n', [T]),
        write('Re-consult the file to play again, or type  halt.'), nl,
        nl,
        assert(escaped),
        !.

escaped_msg :-
        write('You are already free. Re-consult the file to play again.'), nl.


end_turn :-
        ( retract(turn_count(N)) -> N1 is N + 1 ; N1 = 1 ),
        assert(turn_count(N1)),
        ( caught_now ->
              player_caught
        ;     granny_turn,
              ( caught_now ->
                    player_caught
              ;     noise_report
              )
        ),
        !.

caught_now :-
        i_am_at(R),
        granny_at(R),
        \+ hidden.

player_caught :-
        at(pepper_spray, in_hand),
        retract(pepper_charges(C)),
        C > 0, !,
        C1 is C - 1,
        assert(pepper_charges(C1)),
        nl,
        write('A cold hand closes on your shoulder -- but your thumb finds the'), nl,
        write('pepper spray first. You spin and blast Granny full in the face.'), nl,
        write('She reels back with a shriek that shakes the walls.'), nl,
        ( C1 =:= 0 ->
              write('The canister coughs and dies. That was the last charge.'), nl
        ;     format('The canister has ~w charge(s) left.~n', [C1])
        ),
        retractall(granny_stunned(_)),
        assert(granny_stunned(3)),
        write('Granny is stunned and cannot move for 3 turns.'), nl.
player_caught :-
        i_am_at(DeathRoom),
        nl,
        write('A floorboard groans. Before you can turn,'), nl,
        write('a bony hand clamps onto your shoulder. Everything goes black.'), nl,
        ( retract(at(Held, in_hand)) ->
              assert(at(Held, DeathRoom))
        ;     true
        ),
        lose_a_day.

lose_a_day :-
        retract(days_left(D)), !,
        D1 is D - 1,
        ( D1 >= 1 ->
              assert(days_left(D1)),
              nl,
              write('You wake on the mattress. It was not a dream.'), nl,
              ( D1 =:= 1 ->
                    write('This is your LAST chance. One more slip and it is over.'), nl
              ;     format('~w day(s) left.~n', [D1])
              ),
              respawn_world
        ;     assert(days_left(0)),
              nl,
              write('========================================'), nl,
              write('              GAME OVER'), nl,
              write('========================================'), nl,
              write('Ten days. Ten chances. All of them wasted.'), nl,
              write('The house has you now, and it will never let go.'), nl,
              nl,
              write('Re-consult the file to try again, or type  halt.'), nl,
              assert(game_over)
        ).

respawn_world :-
        retractall(i_am_at(_)),         assert(i_am_at(bedroom_1)),
        retractall(granny_at(_)),        assert(granny_at(garage)),
        retractall(granny_target(_)),
        retractall(player_trapped(_)),
        retractall(granny_stunned(_)),
        retractall(granny_trap_frozen(_)).


granny_turn :-
        retract(granny_stunned(N)), N > 0, !,
        N1 is N - 1,
        ( N1 > 0 -> assert(granny_stunned(N1)) ; true ),
        ( N1 =:= 0 ->
              write('You hear Granny stir. The pepper spray is wearing off.'), nl
        ;     write('Somewhere Granny wheezes and coughs -- still blinded.'), nl
        ).
granny_turn :-
        retract(granny_trap_frozen(N)), N > 0, !,
        N1 is N - 1,
        ( N1 > 0 -> assert(granny_trap_frozen(N1)) ; true ),
        ( N1 =:= 0 ->
              write('You hear the bear trap rattle. Granny is pulling herself free.'), nl
        ;     write('Granny howls and thrashes somewhere -- the trap is holding.'), nl
        ).
granny_turn :-
        granny_at(G),
        granny_next(G, Next),
        retract(granny_at(G)),
        assert(granny_at(Next)),
        check_granny_trap(Next),
        !.

granny_next(G, Next) :-
        granny_target(T), T \== G, !,
        step_toward(G, T, Next),
        ( Next == T -> retractall(granny_target(_)) ; true ).
granny_next(G, Next) :-
        retractall(granny_target(_)),
        ( random_between(1, 3, 1) -> Next = G
        ; random_neighbour(G, Next)
        ).

upper_floor_room(hallway).
upper_floor_room(bedroom_1).
upper_floor_room(bedroom_2).
upper_floor_room(bedroom_3).
upper_floor_room(toilet).
upper_floor_room(room_1).
upper_floor_room(room_2).
upper_floor_room(room_3).
upper_floor_room(fourth_floor).

granny_safe_zone(Room) :-
        turn_count(T), T =< 5,
        upper_floor_room(Room).

random_neighbour(G, Next) :-
        findall(N, (path(G, _, N), \+ granny_safe_zone(N)), Ns),
        ( Ns \== [] -> random_member(Next, Ns)
        ; findall(N, path(G, _, N), All),
          ( All == [] -> Next = G ; random_member(Next, All) )
        ).

step_toward(G, T, Next) :-
        findall(D-N,
                ( path(G, _, N),
                  \+ granny_safe_zone(N),
                  ( distance(N, T, Dn) -> D = Dn ; D = 9999 ) ),
                Pairs),
        ( Pairs \== [] -> keysort(Pairs, [_-Next | _])
        ; Next = G
        ).


check_granny_trap(Room) :-
        trap_at(Room), !,
        retract(trap_at(Room)),
        assert(at(bear_trap, Room)),
        nl,
        write('[SNAP] Granny walks straight into the bear trap!'), nl,
        write('She screams and collapses. She cannot move for 3 turns.'), nl,
        retractall(granny_trap_frozen(_)),
        assert(granny_trap_frozen(3)).
check_granny_trap(_).

check_player_trap :-
        i_am_at(Room),
        trap_at(Room), !,
        retract(trap_at(Room)),
        assert(at(bear_trap, Room)),
        nl,
        write('SNAP! Your foot hits the bear trap -- you are caught!'), nl,
        write('The noise echoes through the house.'), nl,
        make_noise,
        retractall(player_trapped(_)),
        assert(player_trapped(3)).
check_player_trap.


make_noise :-
        i_am_at(Here),
        retractall(granny_target(_)),
        assert(granny_target(Here)).

noise_report :-
        i_am_at(P),
        granny_at(G),
        ( distance(G, P, D) -> true ; D = 9999 ),
        report_distance(D).

report_distance(0) :- hidden, !,
        write('You can hear Granny breathing just outside the dresser. Don''t move.'), nl.
report_distance(0) :- !,
        write('Granny is RIGHT HERE in the room with you. Hold your breath.'), nl.
report_distance(1) :- !,
        write('The floorboards creak right beside you.'), nl.
report_distance(2) :- !,
        write('You hear a distant shuffling somewhere nearby...'), nl.
report_distance(_).


distance(From, To, 0) :-
        From == To, !.
distance(From, To, Dist) :-
        bfs([From-0], [From], To, Dist).

bfs([R-D | _], _, To, D) :-
        R == To, !.
bfs([R-D | Rest], Vis, To, Dist) :-
        R \== To,
        D1 is D + 1,
        findall(N-D1, ( path(R, _, N), \+ memberchk(N, Vis) ), Succs),
        succ_rooms(Succs, SRooms),
        append(Vis, SRooms, Vis1),
        append(Rest, Succs, Queue),
        bfs(Queue, Vis1, To, Dist).

succ_rooms([], []).
succ_rooms([N-_ | T], [N | R]) :-
        succ_rooms(T, R).


hide :-
        game_over, !, over_msg.
hide :-
        escaped, !, escaped_msg.
hide :-
        player_trapped(_), !, blocked_trapped.
hide :-
        hidden, !,
        write('You are already hidden.'), nl.
hide :-
        i_am_at(Here),
        furniture(F, Here),
        hideable(F), !,
        assert(hidden),
        write('You squeeze into the '), write(F),
        write(' and pull it shut. Darkness, and the smell of old wood.'), nl,
        end_turn.
hide :-
        write('There is nowhere to hide in here.'), nl.

unhide :-
        game_over, !, over_msg.
unhide :-
        escaped, !, escaped_msg.
unhide :-
        \+ hidden, !,
        write('You are not hidden.'), nl.
unhide :-
        retractall(hidden),
        write('You ease the dresser open and climb out.'), nl,
        end_turn.

blocked_hidden :-
        write('You are tucked inside the dresser. Come out first with  unhide.'), nl.

blocked_trapped :-
        player_trapped(N),
        format('Your leg is caught in the trap. Use  break_out.  (~w attempt(s) needed) to free yourself.~n', [N]).


place_trap :-
        game_over, !, over_msg.
place_trap :-
        escaped, !, escaped_msg.
place_trap :-
        hidden, !, blocked_hidden.
place_trap :-
        player_trapped(_), !, blocked_trapped.
place_trap :-
        \+ at(bear_trap, in_hand), !,
        write('You are not holding a bear trap.'), nl.
place_trap :-
        i_am_at(Here),
        ( trap_at(Here) ->
              write('There is already a trap set here.'), nl
        ;     retract(at(bear_trap, in_hand)),
              assert(trap_at(Here)),
              write('You set the bear trap on the floor and step carefully clear of it.'), nl,
              !, end_turn
        ).

break_out :-
        game_over, !, over_msg.
break_out :-
        escaped, !, escaped_msg.
break_out :-
        \+ player_trapped(_), !,
        write('You are not caught in a trap.'), nl.
break_out :-
        retract(player_trapped(N)),
        make_noise,
        N1 is N - 1,
        ( N1 =:= 0 ->
              write('With a final wrench you tear your leg free from the trap!'), nl,
              write('Your scream echoes through the house.'), nl,
              !, end_turn
        ;     assert(player_trapped(N1)),
              format('You strain against the trap -- ~w more pull(s) needed.~n', [N1]),
              write('The noise must have carried.'), nl,
              !, end_turn
        ).


wait :-
        game_over, !, over_msg.
wait :-
        escaped, !, escaped_msg.
wait :-
        write('You hold still and listen to the house breathe...'), nl,
        end_turn.

turns :-
        turn_count(N), !,
        write('Turns elapsed: '), write(N), nl.
turns :-
        write('Turns elapsed: 0'), nl.

days :-
        days_left(D), !,
        ( D =:= 1 -> write('This is your last day.'), nl
        ; format('Days remaining: ~w.~n', [D])
        ).
days :-
        write('Days remaining: 10.'), nl.

over_msg :-
        write('The game is over. Re-consult the file to try again, or type  halt.'), nl.


describe(bedroom_1) :-
        write('You wake on a stained mattress in a cramped upstairs bedroom.'), nl,
        write('Your head is pounding. The door to the south opens onto a hallway.'), nl.

describe(hallway) :-
        write('A long upstairs hallway lined with peeling wallpaper. Doors lead'), nl,
        write('off in every direction, and a staircase runs both up and down.'), nl.

describe(bedroom_2) :-
        write('A child''s bedroom, long abandoned. Dust-caked toys line the shelves.'), nl,
        write('Doors lead west and south.'), nl.

describe(bedroom_3) :-
        write('A narrow guest room. The single window has been boarded over.'), nl,
        write('Ways out lie to the north and east.'), nl.

describe(toilet) :-
        write('A grimy bathroom. Something dark has dried in the tub.'), nl,
        write('A door leads east to the hallway. The walls feel close.'), nl.

describe(main_hall) :-
        write('The grand entrance hall. The heavy front door looms to the north,'), nl,
        write('buried under locks, chains, and planks. Stairs climb up; a darker'), nl,
        write('stair descends. Openings lead north to the kitchen and east to the lounge.'), nl.

describe(kitchen) :-
        write('A filthy kitchen reeking of rot. Cabinets hang open; the microwave'), nl,
        write('buzzes faintly. You can go south or east.'), nl.

describe(living_room_1) :-
        write('A faded sitting room. One window is loose enough to squeeze through'), nl,
        write('into the garden outside. Other ways lead west and south.'), nl.

describe(living_room_2) :-
        write('A second lounge draped in white sheets. The shapes beneath them'), nl,
        write('could be furniture -- or anything else. Exits lead north and west.'), nl.

describe(garden) :-
        write('Cold air -- but the garden is walled off with no way out. An old'), nl,
        write('stone well stands at its centre, very deep. The window back into'), nl,
        write('the house is behind you.'), nl.

describe(basement) :-
        write('A damp stone basement that smells of mould. A fuse box hums'), nl,
        write('on one wall; a heavy steel safe sits opposite. Stairs climb up;'), nl,
        write('a ramp slopes down into the dark below.'), nl.

describe(garage) :-
        write('A cold garage. A half-gutted car crouches over an oil stain,'), nl,
        write('its engine bay gaping open and waiting for parts. One way out: up.'), nl.

describe(room_1) :-
        write('A cluttered third-floor landing. Corridors branch north and east,'), nl,
        write('stairs run up to an attic and back down to the floor below.'), nl.

describe(room_2) :-
        write('A cramped storage room packed floor to ceiling with broken furniture.'), nl,
        write('The only way out is south.'), nl.

describe(room_3) :-
        write('A study choked with mouldering books. Pages have peeled from the'), nl,
        write('shelves and litter the floor. A door leads back west.'), nl.

describe(fourth_floor) :-
        write('A low attic under bare rafters. The air is stale and the dark'), nl,
        write('presses in from every corner. The stairs down are your only exit.'), nl.


instructions :-
        nl,
        write('========================================'), nl,
        write('   GRANNY -- Text Adventure'), nl,
        write('========================================'), nl,
        nl,
        write('You wake in a strange house. An old woman called Granny'), nl,
        write('hunts the rooms. You must escape before your time runs out.'), nl,
        nl,
        write('MOVEMENT'), nl,
        write('  n. s. e. w. u. d.       move one room (silent)'), nl,
        write('  window.                 climb through a window (where available)'), nl,
        write('  run(Dir, Dir).          sprint two rooms in one go (LOUD)'), nl,
        nl,
        write('ITEMS  (search furniture to find them; carry one at a time)'), nl,
        write('  inspect(Furniture).     search: inspect(cabinet). inspect(bed).'), nl,
        write('  take(Item).             pick up a found item'), nl,
        write('  drop.                   put down what you carry'), nl,
        write('  inventory.  (or i.)     what are you holding?'), nl,
        nl,
        write('ESCAPE -- two routes, each requiring specific items:'), nl,
        write('  install(Part).          fit a car part in the garage'), nl,
        write('  interact(Object).       use held item on: main_door, electrical_box'), nl,
        nl,
        write('GADGETS'), nl,
        write('  place_trap.             arm the bear_trap in this room (silent)'), nl,
        write('  break_out.             escape a bear trap (type it 3 times; loud)'), nl,
        write('  hide.                   hide in a dresser (Granny passes you by)'), nl,
        write('  unhide.                 climb back out (dangerous if she is near)'), nl,
        nl,
        write('INFO  (free -- no turn spent)'), nl,
        write('  look.                   describe the room again'), nl,
        write('  status.                 full game-state summary'), nl,
        write('  days.                   days (lives) remaining'), nl,
        write('  turns.                  turns elapsed'), nl,
        write('  wait.                   pass a turn'), nl,
        write('  instructions.           show this help'), nl,
        write('  halt.                   quit'), nl,
        nl,
        write('RULES'), nl,
        write('  You have 10 days (lives). Granny catches you -- you lose one.'), nl,
        write('  You wake back in bed but the house stays as you left it.'), nl,
        write('  Granny cannot see you, but she HEARS you. Loud moves'), nl,
        write('  (run, dropping heavy items, break_out) draw her straight to you.'), nl,
        write('  Proximity warnings: creaking = 1 room away; shuffling = 2 rooms.'), nl,
        nl,
        write('PEPPER SPRAY  carried = auto-fires on contact; stuns Granny 3 turns.'), nl,
        write('BEAR TRAP     place_trap. to arm it; Granny (or you!) stepping on it'), nl,
        write('              is frozen 3 turns. Break free with break_out. x3 (loud).'), nl,
        nl,
        write('CAR ROUTE  (garage)'), nl,
        write('  install motor -> install wrench -> install sparkplug'), nl,
        write('  -> install car_battery -> install car_key  (WIN)'), nl,
        nl,
        write('DOOR ROUTE  (main_hall)'), nl,
        write('  interact(main_door) with: code -> padlock_key -> hammer'), nl,
        write('  -> wire_cutters  (cut fuse box in basement first!)'), nl,
        write('  -> interact(main_door) with master_key  (WIN)'), nl,
        nl,
        write('Items are scattered randomly. Every run is different.'), nl,
        write('Re-consult the file to restart with a new layout.'), nl,
        nl.

start :-
        nl,
        write('========================================'), nl,
        write('   GRANNY -- Text Adventure'), nl,
        write('========================================'), nl,
        nl,
        write('Your eyes open. Damp ceiling. Peeling wallpaper. A smell like'), nl,
        write('old wood and something worse. You are in a house you do not'), nl,
        write('recognise, and from somewhere below you hear slow, heavy footsteps.'), nl,
        nl,
        write('You have 10 days to get out. Type  instructions.  for help.'), nl,
        look.
