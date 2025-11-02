extends Node3D

func deactivate_particles() -> void:
	self.visible = false

func activate_particles():
	self.visible = true
