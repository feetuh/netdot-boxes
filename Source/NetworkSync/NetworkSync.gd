extends Node

signal state_sent(Node)

const TICK_RATE = 1.0 / 120 # 120 ticket per second

enum Product {
	BOX
}

var product_paths: Dictionary = {
	Product.BOX: preload("res://Source/Example/Box.tscn") 
}

var uuid_to_index: Dictionary = {}

var state = []
var next_update: Dictionary = {}

var map_scene: Node = null
var timer: Timer = null

func _run_update_state_timer():
	timer = Timer.new()
	timer.wait_time = TICK_RATE
	timer.connect("timeout", self, "update_state")
	timer.autostart = true
	get_tree().get_root().add_child(timer)

func make(product_enum: int, params={}):
	var product: Node = product_paths[product_enum].instance()
	var uuid = UUID.v4()
	product.name = uuid
	var network_entity = product.get_node("NetworkEntity")
	var uuid_idx = state.size()
	state.append(network_entity)
	uuid_to_index[uuid] = uuid_idx
	rpc("make_peers", product_enum, uuid, uuid_idx, params)
	map_scene.add_child(product)
	if product.has_method("init"):
		product.init(params)

remote func make_peers(product_enum: int, uuid: String, uuid_idx: int, params={}):
	var product: Node = product_paths[product_enum].instance()
	product.name = uuid
	uuid_to_index[uuid] = uuid_idx
	var network_entity = product.get_node("NetworkEntity")
	state.append(network_entity)
	map_scene.add_child(product)
	if product.has_method("init"):
		product.init(params)

func register_state(uuid, params):
	var index = uuid_to_index[uuid]
	next_update[index] = params

func delete_from_state(uuid):
	var index = uuid_to_index[uuid]
	state[index].get_parent().queue_free()
	rpc("delete_from_state_peer", index)
	
remote func delete_from_state_peer(index):
	state[index].get_parent().queue_free()

func update_state():
	if not next_update.empty():
		rpc_unreliable("update_peer", next_update)
		next_update.clear()
	emit_signal("state_sent", self)

remote func update_peer(next_state):
	for index in next_state:
		var network_entity = state[index]
		if not is_instance_valid(network_entity):
			continue
		network_entity.update_entity(next_state[index])
