extends Spatial

func _make_rand_rotation() -> Vector3:
	return Vector3(rand_range(0, 360), rand_range(0, 360), rand_range(0, 360))

func _make_rand_albedo() -> Color:
	return Color(randf(), randf(), randf())

func _ready():
	if not get_tree().is_network_server():
		self.set_process_input(false)

func _input(event):
	if event.is_action_pressed("move_forward"):
		NetworkSync.make(NetworkSync.Product.BOX, {
			"position": $Spawn_1.global_transform.origin,
			"rotation_degrees": _make_rand_rotation(),
			"albedo": _make_rand_albedo()
		})
