class_name NetworkEntity
extends Node

export(NodePath) onready var entity_path = ".."
onready var entity := get_node(entity_path)
export(Array, String) onready var props

var prop_dict: Dictionary = {}

func _ready():
	for prop in props:
		prop_dict[prop] = entity.get_indexed(prop)
	if get_tree().is_network_server():
		NetworkSync.connect("state_sent", self, "_on_state_update_request")
	else:
		entity.set_physics_process(false)
		entity.mode = RigidBody.MODE_STATIC

func _on_state_update_request(state):
	var updates_since_last_request: Dictionary = {}
	for prop in props:
		var prop_value = entity.get_indexed(prop)
		if prop_dict[prop] != prop_value:
			updates_since_last_request[prop] = prop_value
			prop_dict[prop] = prop_value
	if not updates_since_last_request.empty():
		state.register_state(entity.name, prop_dict)

func update_entity(params):
	for param in params:
		entity.set_indexed(param, params[param])
