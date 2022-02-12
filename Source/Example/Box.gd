extends RigidBody

func init(params):
	self.global_transform.origin = params.position
	self.rotation_degrees = params.rotation_degrees
	var mat := SpatialMaterial.new()
	mat.albedo_color = params.albedo
	$Spatial.set_material_override(mat)

func _on_Timer_timeout():
	if get_tree().is_network_server():
		NetworkSync.delete_from_state(self.name)
