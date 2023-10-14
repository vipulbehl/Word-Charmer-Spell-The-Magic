extends Control

var bar_red = preload("res://Resources/Buttons/barHorizontal_red.png")
var bar_green = preload("res://Resources/Buttons/barHorizontal_green.png")
var bar_yellow = preload("res://Resources/Buttons/barHorizontal_yellow.png")

var player_sprite = preload("res://Resources/Sprites/Ninja/wizard_ice_cs4_18.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func initialize(_maxHealth, _sprite_type):
	$HealthBar.max_value = _maxHealth
	set_health_value(_maxHealth)
	if _sprite_type == "Player":
		$Sprite2.visible = false
	else:
		$Sprite.visible = false
		$HealthBar.fill_mode = 1
		#var sceneRoot = get_parent()
		#$Sprite2.set_texture(sceneRoot.enemySpriteDictionary[str(sceneRoot.enemyCount)])

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if $HealthBar.value <= $HealthBar.max_value * 1:
		$HealthBar.texture_progress = bar_green
	if $HealthBar.value < $HealthBar.max_value * 0.6:
		$HealthBar.texture_progress = bar_yellow
	if $HealthBar.value < $HealthBar.max_value * 0.3:
		$HealthBar.texture_progress = bar_red
		
	if int($HealthValue.text) < 0:
		$HealthValue.text = str(0)

func set_health_value(value):
	if value <= $HealthBar.max_value :
		$HealthBar.value = value
		$HealthValue.text = str(value)
	else:
		$HealthBar.value = $HealthBar.max_value
		$HealthValue.text = str($HealthBar.max_value)
