extends CenterContainer

signal validate_word
# Button Properties
export var multiplier = 1
export var special_effect = "Simple"
export var damage = 10
#Position in grid
export var pos = 1


onready var selectedLetterButton = preload("res://Scenes/Play/SelectedButton.tscn")

var rarity_dict = {
	"A" : 8.3, "B" : 2.2, "C" : 4.5, "D" : 3.4, "E" :10.8, "F" : 1.9, "G" : 2.5,
	"H" : 3.0, "I" : 7.4, "J" : 0.4, "K" : 1.2, "L" : 5.4, "M" : 3.1, "N" : 6.5, 
	"O" : 7.0, "P" : 3.2, "Q" : 0.4, "R" : 7.4, "S" : 5.6, "T" : 6.8, "U" : 3.7,
	"V" :1.1, "W" : 1.4, "X" : 0.5, "Y" : 1.9, "Z" : 0.4
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#initialize()


func initialize(_base_damage, _special_effect, _pos):
	damage = _base_damage
	pos = _pos
	special_effect = _special_effect
	$Label.text = get_random_letter()
	set_multiplier()
	set_button_image_and_power_tile_damage()

func get_random_letter():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_integer = rng.randf_range(0.0,100.0)
	var probability_counter = 0.0
	for alphabet in rarity_dict:
		probability_counter += rarity_dict[alphabet]
		if probability_counter >= random_integer:
			return alphabet
	return "A"


func set_multiplier():
	var rarity_index = rarity_dict[$Label.text]
	if  rarity_index > 3.2:
		self.multiplier = 1
	elif rarity_index >= 1.9 and rarity_index <= 3.2: 
		self.multiplier = 1.2
	else:
		self.multiplier = 1.5


func set_button_image_and_power_tile_damage():
	if special_effect == "Freeze":
		#damage += SavedGames.saveGameDict["freezeTileHP"]
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/freezeTile.png")
	elif special_effect == "Powerup":
		#damage += SavedGames.saveGameDict["powerUpTileHP"]
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/powerupTile.png")
	elif special_effect == "Burn":
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/burnTile.png")
	elif special_effect == "Heal":
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/healTile.png")
	elif special_effect == "Paralyse":
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/paralyseTile.png")
	elif special_effect == "QuestionMark":
		$Label.text = "?"
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/questionMarkTile.png")
	elif special_effect == "noDamageTile":
		damage = 0
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/noDamageTile.png")
	elif special_effect == "decreaseHealthTile":
		$TextureButton.texture_normal = load("res://Resources/UI Elements/GridButtons/decreaseHealthTile.png")
	else:
		$TextureButton.texture_normal = load("res://Resources/UI Elements/Buttons/Cartoon RPG UI_Slot - Item.png")
	
	# Setting button rarity image at the bottom of the button
	var rarity_index = rarity_dict.get($Label.text,0)
	if rarity_index > 2.2:
		$ButtonRarity.texture = load("res://Resources/UI Elements/GridButtons/bronze.png")
	elif rarity_index > 1.1 and rarity_index < 2.5:
		$ButtonRarity.texture = load("res://Resources/UI Elements/GridButtons/silver.png")
	else:
		$ButtonRarity.texture = load("res://Resources/UI Elements/GridButtons/gold.png")

# 1. Append the SelectedLetters with the new pressed button's value
# 2. Change button texture to texture_disabled
# 3. Disable the button
# 4. Create a selectedTexture Button instance and add it to the SelectedLettersGrid
#		a. Get the texture on the old button
#		b. Get the value on the old button
#		c. get the position on the old button
#		d. Copy these values to the newly created button and insert it into SelectedLettersGrid
#
# 
func _on_TextureButton_pressed():
	# Playing button click audio
	if SavedGames.saveGameDict["soundEnabled"]:
		$ButtonClickAudio.play()
	
	var buttonRoot = self.get_parent()
	#sceneRoot is the reference to playScene
	var sceneRoot = buttonRoot.get_parent()
	var buttonValue = self.get_node("Label").text
	
	var newBtn = selectedLetterButton.instance()
	var textureButton = self.get_node("TextureButton")
	
	# Hiding the texture button, rarity image and button text
	textureButton.disabled = true
	$ButtonRarity.visible = false
	get_node("Label").add_color_override("font_color", Color(0,0,0,0))
	
	# Adding button to Selected Button Grid
	var oldTextureButton: TextureButton = textureButton
	newBtn.get_node("SelectedButtonTextureButton").texture_normal = oldTextureButton.texture_normal
	newBtn.get_node("SelectedButtonLabel").text = buttonValue
	newBtn.set("pos", self.get("pos"))
	sceneRoot.get_node("SelectedLettersGrid").add_child(newBtn)
	
	emit_signal("validate_word")


func simulate_texture_button_press():
	_on_TextureButton_pressed()
