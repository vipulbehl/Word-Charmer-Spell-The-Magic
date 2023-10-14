extends Control

var bar_red = preload("res://Resources/Buttons/barHorizontal_red.png")
var bar_green = preload("res://Resources/Buttons/barHorizontal_green.png")
var bar_yellow = preload("res://Resources/Buttons/barHorizontal_yellow.png")

var player_sprite = preload("res://Resources/Sprites/Ninja/wizard_ice_cs4_18.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_sprites():
	var sceneRoot = get_parent()
	for i in range(1,6):
		get_node("ProgressBar/"+str(i)).set_texture(sceneRoot.enemySpriteDictionary[str(i)])

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	pass

func set_value(value):
	$ProgressBar.value = value
	get_node("ProgressBar/"+str(value)).modulate = Color(0,0,0)
