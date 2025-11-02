extends Node3D

@export var range: float = 200
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
	ray_cast_3d.target_position = Vector3.FORWARD * range

func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		if Input.is_action_just_pressed("act"):
			hookableSurfaceCheck()
			

func hookableSurfaceCheck() -> void:
	if ray_cast_3d.is_colliding():
		print("HOOKABLE")
