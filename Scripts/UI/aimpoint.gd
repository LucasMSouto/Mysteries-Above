extends Node

func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		$".".visible = true
	else:
		$".".visible = false
