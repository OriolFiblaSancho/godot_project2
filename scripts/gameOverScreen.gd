extends CanvasLayer

func _ready():
	self.hide()

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func game_over():
	get_node("../GUI").hide()
	get_tree().paused = true
	self.show()
