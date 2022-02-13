# netdot-boxes

Simple Godot deterministic network physics example with falling boxes.

## Deterministic vs Non-deterministic

*Left*: client and server viewing deterministic output for physics computed by the server.

*Right*: client and server viewing their own non-deterministic physics simulation causing desync.

![comparision-gif](other/comparison.gif)

## Non-deterministic Overlay

It's easier to see the consequences of non-deterministic output when overlapping the two scenes. These kind of mismatches may be perfectly fine for a lot of game mechanics. However, games that rely on peers seeing the same physics outcomes will break due to this type of desync.

![overlay-gif](other/non-deterministic.gif)

MIT License

Copyright (c) 2022 feetuh