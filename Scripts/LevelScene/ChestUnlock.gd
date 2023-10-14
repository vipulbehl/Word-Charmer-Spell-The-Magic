extends Node2D

var currentRow = 1

var imageDict = {
	"Coins" : preload("res://Resources/UI Elements/Buttons/Cartoon RPG UI_Game Icon - Coin.png"), 
	"Healing Potion" : preload("res://Resources/UI Elements/Buttons/Potion/HealthPotion.png"), 
	"Longest Word Finder" : preload("res://Resources/UI Elements/Buttons/Potion/LongestWordPotion.png"),
	"Magic Tile Potion" : preload("res://Resources/UI Elements/Buttons/Potion/MagicTilePotion.png"),
	"Purify Potion" : preload("res://Resources/UI Elements/Buttons/Potion/PurifyPotion.png"), 
	"Shuffle Potion" : preload("res://Resources/UI Elements/Buttons/Potion/ShufflePotion.png"),
	"Power-up Potion" : preload("res://Resources/UI Elements/Buttons/Potion/PowerPotion.png")
}


func _ready():
	pass # Replace with function body.


func unlock_chest(_unlockDict):
	for key in _unlockDict:
		if _unlockDict[key] == 0:
			continue
		find_node("row_%s_sprite"%str(currentRow)).texture = imageDict[key]
		find_node("row_%s_sprite"%str(currentRow)).visible = true
		
		find_node("row_%s_heading"%str(currentRow)).text = str(key)
		find_node("row_%s_heading"%str(currentRow)).visible = true
		
		find_node("row_%s_count"%str(currentRow)).text = str(_unlockDict[key])
		find_node("row_%s_count"%str(currentRow)).visible = true
		currentRow += 1
		
	find_node("BackgroundTint").visible = true
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("ChestUnlockSound").play()
	find_node("ChestUnlockAnimation").play("unlock_chest")


func _on_okButton_button_up():
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("NormalButtonClick").play()
	find_node("Control").visible = false
	find_node("BackgroundTint").visible = false
