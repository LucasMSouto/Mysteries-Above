extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 1.0

#aim offsets
@export var cameraAimOfset: Vector3 = Vector3(1,0,0)
@onready var originalCameraPosition: Vector3 = $".".position

#aim camera FOV
@export_range(0,179,0.1,"degrees") var cameraFOV: float = 70
@export_range(0,179,0.1,"degrees") var aimFOV: float = 30

func _process(delta: float) -> void:
	var cameraAim = __aim(delta)
	position = lerp(position, spring_arm.position + cameraAim,delta*lerp_power)
	
#aim input
func __aim(delta: float) -> Vector3:
	#aim
	if Input.is_action_pressed("aim"):
		$".".fov = lerp($".".fov,aimFOV,delta*lerp_power)
		return cameraAimOfset
	else:
		$".".fov = lerp($".".fov,cameraFOV,delta*lerp_power)
		return Vector3.ZERO
		
