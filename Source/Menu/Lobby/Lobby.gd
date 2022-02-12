extends Control

const example_scene = preload("res://Source/Example/Example.tscn")

remotesync func _start_game():
	var level = example_scene.instance()
	NetworkSync.map_scene = level
	if (get_tree().is_network_server()):
		NetworkSync._run_update_state_timer()
	get_tree().get_root().add_child(level)
	self.hide()

func _on_ButtonStart_pressed():
	if get_tree().is_network_server():
		rpc("_start_game")
