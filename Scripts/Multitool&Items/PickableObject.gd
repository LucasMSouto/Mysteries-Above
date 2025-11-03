extends Node

#Shader/Particle Systems Proof of Concept Section
@export var pickableVisualizer: bool
@export_range(0, 255, 1) var transparency: float = 235

@onready var main_mat = self.material_override
@onready var outline_mat = self.material_overlay

@onready var partuclas = $TimeDematrializationParticles

func _process(delta: float) -> void:
	__debug()

func __debug():
	if(pickableVisualizer):
		timeDematrialization(true)
	else:
		timeDematrialization(false)

#This is not the final version but explain how the core concept on how the pickable objects will be rendered
func timeDematrialization(activate: bool) -> void:
	match activate:
		true:
			#When we want to visualize the pickable object we first...
			#Activate its outline and make it a bit transparent
			__fizzle_golden_shader()
			#And show the time dematrialization particles
			__show_time_dem_particles()
		false:
			__normal_shader()
			__hide_time_dem_particles()

func __fizzle_golden_shader() -> void:
	#Make the main material transparent
	main_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	main_mat.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	main_mat.albedo_color.a = transparency
	
	outline_mat.set_shader_parameter("showOutline",true)
	
func __normal_shader() -> void:
	main_mat.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	main_mat.albedo_color.a = 255
	
	outline_mat.set_shader_parameter("showOutline",false)

func __show_time_dem_particles() -> void:
	partuclas.show()
	
func __hide_time_dem_particles() -> void:
	partuclas.hide()
