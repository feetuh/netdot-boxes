extends Control

var port = 25565

const lobby_scene: PackedScene = preload("res://Source/Menu/Lobby/Lobby.tscn")

func _on_ButtonHost_pressed():
	var network = NetworkedMultiplayerENet.new()
	network.create_server(port, 2)
	get_tree().network_peer = network
	var lobby = lobby_scene.instance()
	get_tree().get_root().add_child(lobby)
	self.hide()

func _on_ButtonJoin_pressed():
	var network = NetworkedMultiplayerENet.new()
	var err = network.create_client($HSplitContainer/TextEdit.text ,port)
	if err != OK:
		return
	get_tree().network_peer = network
	var lobby = lobby_scene.instance()
	get_tree().get_root().add_child(lobby)
	self.hide()
