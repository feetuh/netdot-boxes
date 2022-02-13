# netdot-boxes

Simple Godot synchronised network physics example with falling boxes. Pressing `w` spawns a new box with a random colour and rotation which is removed from the scene after 5 seconds.

## Synchronised vs Unsynchronised

*Left*: client and server viewing synchronised output for physics computed by the server.

*Right*: client and server viewing their own unsynchronised physics simulation causing desync.

![comparison-gif](other/sync-vs-desync.gif)

## Unsynchronised Overlay

It's easier to see the consequences of unsynchronised output when overlapping the two scenes. 

![overlay-gif](other/unsynchronised.gif)

These kind of mismatches may be perfectly fine for a lot of game mechanics. However, games that rely on peers seeing the same physics outcomes will break due to this type of desync.

# Setup

### **NetworkSync**

Autoload singleton used to instantiate and destruct nodes as well as for tracking and updating the state of any NetworkEntity.

`func make(product_enum: int, params={})` reliably calls equivalent on peers.

`func delete_from_state(uuid)` reliably calls equivalent on peers.

NetworkSync has a const TICK_RATE and will send updates to peers every increment (defaults to 120 ticks per second). Updates will only consist of changes in state since the last update so peers only need to apply changes. Updates are applied to NetworkEntity nodes by emitting the `state_sent` signal which NetworkEntity nodes are connected to. These updates are sent unreliably because we're sending them frequently enough that missing a few shouldn't cause concern.

### **NetworkEntity**

Node to add as a child of any node with properties that should be state-managed. State-managed entities only have one optional requirement, an `init(params)` function to initialise the state of the node.

To manage properties of the parent node as part of the global state, variable names can be added to the exported props Array. These variables are accessed via the `Object::get_indexed` function meaning it can manage a node's nested variables such as `global_transform:origin` in this example.

Upon receiving the `state_sent` signal from the NetworkSync, NetworkEntity will check if there are any changes between the state of its parent at the last update versus now. If there is a change, it will be added to the global state using NetworkSync's `register_state` function.

# Noteworthy Limitations

* No interpolation (compensates by defaulting to 120 ticks per second)
* Flat structure, all nodes are instantiated on the same "map_scene" for design simplicity

MIT License

Copyright (c) 2022 feetuh