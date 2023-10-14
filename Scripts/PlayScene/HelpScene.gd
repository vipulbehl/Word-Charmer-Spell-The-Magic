extends Node2D

var toggleMenu = false
var playScene
var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")

# Button References
var powerTileScene
var healTileScene
var freezeTileScene
var burnTileScene
var paralyseTileScene
var questionMarkTileScene
var noDamageTileScene
var bleedTileScene


# Tile information strings
var powerupTileString = "Increase the attack of the tile by %s HP"
var healTileString = "Heals wizard by %s HP"
var freezeTileString = "Freezes the enemy and deals extra damage of %s HP"
var burnTileString = "Deals extra %s%% damage of enemy's health"
var paralyzeTileString = "Decreases all stats of the enemy by %s%%"
var questionMarkTileString = "This tile automatically replaces with any other letter(a-z) when used while making a word. You can use only one ? tile in a word"
var noDamageTileString = "This is an Enemy tile, when used this tile doesn't deal any damage to the enemy"
var bleedTileString = "This is an Enemy Tile, using this tile will lead to wizard losing some of his health"


func _ready():
	playScene = get_parent()
	initialize_all_buttons()
	_on_power_tile(true)

func start():
	_on_power_tile(true)

func initialize_all_buttons():
	powerTileScene = storeButtonScene.instance()
	powerTileScene.initialize("powerTile")
	powerTileScene.isSmallAnimation = true
	powerTileScene.find_node("Button").connect("button_up",self,"_on_power_tile")
	powerTileScene.connect("gui_input",self,"_on_power_tile_container")
	find_node("GridContainer").add_child(powerTileScene)
	
	
	healTileScene = storeButtonScene.instance()
	healTileScene.initialize("healTile")
	healTileScene.isSmallAnimation = true
	healTileScene.find_node("Button").connect("button_up",self,"_on_heal_tile")
	healTileScene.connect("gui_input",self,"_on_heal_tile_container")
	find_node("GridContainer").add_child(healTileScene)
	
	
	freezeTileScene = storeButtonScene.instance()
	freezeTileScene.initialize("freezeTile")
	freezeTileScene.isSmallAnimation = true
	freezeTileScene.find_node("Button").connect("button_up",self,"_on_freeze_tile")
	freezeTileScene.connect("gui_input",self,"_on_freeze_tile_container")
	find_node("GridContainer").add_child(freezeTileScene)
	
	
	burnTileScene = storeButtonScene.instance()
	burnTileScene.initialize("burnTile")
	burnTileScene.isSmallAnimation = true
	burnTileScene.find_node("Button").connect("button_up",self,"_on_burn_tile")
	burnTileScene.connect("gui_input",self,"_on_burn_tile_container")
	find_node("GridContainer").add_child(burnTileScene)
	
	paralyseTileScene = storeButtonScene.instance()
	paralyseTileScene.initialize("paralyzeTile")
	paralyseTileScene.isSmallAnimation = true
	paralyseTileScene.find_node("Button").connect("button_up",self,"_on_paralyze_tile")
	paralyseTileScene.connect("gui_input",self,"_on_paralyze_tile_container")
	find_node("GridContainer").add_child(paralyseTileScene)
	
	questionMarkTileScene = storeButtonScene.instance()
	questionMarkTileScene.initialize("questionMarkTile")
	questionMarkTileScene.isSmallAnimation = true
	questionMarkTileScene.find_node("Button").connect("button_up",self,"_on_question_mark_tile")
	questionMarkTileScene.connect("gui_input",self,"_on_question_mark_tile_container")
	find_node("GridContainer").add_child(questionMarkTileScene)
	
	noDamageTileScene = storeButtonScene.instance()
	noDamageTileScene.initialize("noDamageTile")
	noDamageTileScene.isSmallAnimation = true
	noDamageTileScene.find_node("Button").connect("button_up",self,"_on_no_damage_tile")
	noDamageTileScene.connect("gui_input",self,"_on_no_damage_tile_container")
	find_node("GridContainer").add_child(noDamageTileScene)
	
	bleedTileScene = storeButtonScene.instance()
	bleedTileScene.initialize("bleedTile")
	bleedTileScene.isSmallAnimation = true
	bleedTileScene.find_node("Button").connect("button_up",self,"_on_bleed_tile")
	bleedTileScene.connect("gui_input",self,"_on_bleed_tile_container")
	find_node("GridContainer").add_child(bleedTileScene)


func potion_selected_options(_heading, _description):
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	find_node("TileHeading").text = str(_heading)
	find_node("TileDescription").text = str(_description)


# Button callbacks
func _on_power_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_power_tile()

func _on_power_tile(_from_load=false):
	if not _from_load:
		playScene.play_button_click_sound()
	currentSelectedButton = powerTileScene
	potion_selected_options("Power-up Tile",powerupTileString%(SavedGames.saveGameDict["powerUpTileHP"]))

func _on_heal_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_heal_tile()

func _on_heal_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = healTileScene
	potion_selected_options("Heal Tile", healTileString%SavedGames.saveGameDict["healTileHP"])

func _on_freeze_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_freeze_tile()

func _on_freeze_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = freezeTileScene
	potion_selected_options("Freeze Tile", freezeTileString%SavedGames.saveGameDict["freezeTileHP"])

func _on_burn_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_burn_tile()

func _on_burn_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = burnTileScene
	potion_selected_options("Burn Tile", burnTileString%SavedGames.saveGameDict["burnTilePercent"])

func _on_paralyze_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_paralyze_tile()

func _on_paralyze_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = paralyseTileScene
	potion_selected_options("Paralyse Tile", paralyzeTileString%SavedGames.saveGameDict["paralyzeTilePercentage"])

func _on_question_mark_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_question_mark_tile()

func _on_question_mark_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = questionMarkTileScene
	potion_selected_options("? Tile", questionMarkTileString)

func _on_no_damage_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_no_damage_tile()

func _on_no_damage_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = noDamageTileScene
	potion_selected_options("Cracked Tile", noDamageTileString)

func _on_bleed_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_bleed_tile()

func _on_bleed_tile():
	playScene.play_button_click_sound()
	currentSelectedButton = bleedTileScene
	potion_selected_options("Bleed Tile", bleedTileString)



func _on_Close_button_up():
	playScene.play_button_click_sound()
	toggle_menu()


func toggle_menu():
	toggleMenu = not toggleMenu
	find_node("Control").visible = toggleMenu
	get_node("CanvasLayer2/Background").visible = toggleMenu
	#get_tree().paused = toggleMenu
