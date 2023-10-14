extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", self)

