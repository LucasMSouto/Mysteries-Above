extends Node


func changeToScene(screneName: String) -> void:
	get_tree().change_scene_to_file(screneName)
	
