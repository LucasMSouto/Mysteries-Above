extends ColorRect

@onready var buttonPlay = $CenterContainer/VBoxContainer/Play
@onready var buttonSettigns = $CenterContainer/VBoxContainer/Settings
@onready var buttonCredits = $CenterContainer/VBoxContainer/Credits
@onready var buttonQuit = $CenterContainer/VBoxContainer/Quit

func _ready():
	pass


func _on_play_pressed() -> void:
	$"/root/SceneLoader".changeToScene("res://Scenes/HookerLevelTest.tscn")

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
