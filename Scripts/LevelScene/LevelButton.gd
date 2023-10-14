extends CenterContainer

var levelNumber
signal selectLevel


func _ready():
	pass 

# Write code here to disable the levels which are yet to be unlocked
func _process(_delta):
	if find_node("TextureButton").disabled:
		find_node("LevelNumber").visible = false
	else:
		find_node("LevelNumber").visible = true

func initialize(_levelNumber):
	levelNumber = _levelNumber
	find_node("LevelNumber").text = str(_levelNumber)
	self.add_to_group("levelSelected")
	
	if SavedGames.saveGameDict["maxUnlockedLevel"] == int(_levelNumber):
		var currentLevelIcon = load("res://Resources/UI Elements/Buttons/orange_selection.png")
		find_node("TextureButton").texture_normal = currentLevelIcon


func _on_TextureButton_button_up():
	emit_signal("selectLevel",levelNumber)


func simulate_button_press():
	_on_TextureButton_button_up()
