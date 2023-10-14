extends Node2D

var unlockedDict = {
	"questionMarkTileUnlocked" : ["? Tile","res://Resources/UI Elements/GridButtons/questionMarkTile.png" , "- Substitues for any alphabet in a word\n- Spawns on creating 4+ length words\n- Can get only one at a time"],
	"powerUpTileUnlocked" : ["Power Tile", "res://Resources/UI Elements/GridButtons/powerupTile.png", "- Increases tile damage by 20\n- Spawns on creating 5+ length words\n- Can be upgraded from the Shop"],
	"healTileUnlocked" : ["Heal Tile","res://Resources/UI Elements/GridButtons/healTile.png" , "- Heals the wizard's health by 20 HP\n- Spawns on creating 6+ length words\n- Can be upgraded from the Shop"],
	"freezeTileUnlocked" : ["Freeze Tile","res://Resources/UI Elements/GridButtons/freezeTile.png" , "- Freezes the enemy for one turn\n- Deals extra damage of 10\n- Spawns on creating 7+ length words\n- Can be upgraded from the Shop"],
	"burnTileUnlocked" : ["Burn Tile","res://Resources/UI Elements/GridButtons/burnTile.png" , "- Deals extra damage of 20% of enemy's current health\n- Spawns on creating 8+ length words\n- Can be upgraded from the Shop"],
	"paralyzeTileUnlocked" : ["Paralyze Tile","res://Resources/UI Elements/GridButtons/paralyseTile.png" , "- Reduces enemy's all stats permanently by 20%\n- Spawns on creating 9+ length words\n- Can be upgraded from the Shop"],
	"bleedTileUnlocked" : ["Bleed Tile", "res://Resources/UI Elements/GridButtons/decreaseHealthTile.png", "- This is an Enemy's Tile\n- It reduces Wizard's health when used\n- Use purify potion to remove it"],
	"noDamageTileUnlocked" : ["Cracked Tile", "res://Resources/UI Elements/GridButtons/noDamageTile.png", "- This is an Enemy's Tile\n- This tile doesn't deal any damage to the enemy\n- Use purify potion to remove it"]
}


func _ready():
	pass


func unlock(_unlockedTile):
	var tileList = unlockedDict[_unlockedTile]
	var tileName = tileList[0]
	var tileImage = load(tileList[1])
	var tileDescription = tileList[2]
	
	find_node("TileImage").texture = tileImage
	find_node("TileName").text = tileName
	find_node("TileDescription").text = tileDescription
	
	find_node("UnlockWindow").visible = true


func check_unlock():
	var currentLevel = int(SavedGames.saveGameDict["maxUnlockedLevel"])
	
	if currentLevel == 1 and Global.level == 1:
		unlock("questionMarkTileUnlocked")
	elif currentLevel == 2 and Global.level == 2:
		unlock("powerUpTileUnlocked")
	elif currentLevel == 3 and Global.level == 3:
		unlock("healTileUnlocked")
	elif currentLevel == 4 and Global.level == 4:
		unlock("freezeTileUnlocked")
	elif currentLevel == 5 and Global.level == 5:
		unlock("burnTileUnlocked")
	elif currentLevel == 6 and Global.level == 6:
		unlock("paralyzeTileUnlocked")
	elif currentLevel == 7 and Global.level == 7:
		unlock("bleedTileUnlocked")
	elif currentLevel == 8 and Global.level == 8:
		unlock("noDamageTileUnlocked")


func _on_OK_button_up():
	if SavedGames.saveGameDict["soundEnabled"]:
		$CanvasLayer/UnlockWindow/NormalButtonClick.play()
	find_node("UnlockWindow").visible = false
