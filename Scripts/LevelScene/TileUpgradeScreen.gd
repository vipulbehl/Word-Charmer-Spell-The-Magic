extends Control

var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")
var storeSceneRef

# Button References
var healPotionScene
var powerupPotionScene
var powerTileScene
var healTileScene
var freezeTileScene
var burnTileScene
var paralyseTileScene

# Upgrade Strings
var healPotionUpgradeString = "[center]Heal health by [color=#0091FF]%s HP[/color][/center]"
var powerupPotionUpgradeString = "[center]Increase attack power by [color=#0091FF]%s%%[/color][/center]"
var powerupTileString = "[center]Increase tile damage by [color=#0091FF]%s HP[/color][/center]"
var healTileString = "[center]Heals wizard by [color=#0091FF]%s HP[/color][/center]"
var freezeTileString = "[center]Skips enemy's turn and increases tile damage by [color=#0091FF]%s HP[/color][/center]"
var burnTileString = "[center]Deals extra damage of [color=#0091FF]%s%%[/color] of enemy's health[/center]"
var paralyzeTileString = "[center]Decreases enemy's all stats by [color=#0091FF]%s%%[/color][/center]"

func _ready():
	storeSceneRef = get_parent().get_parent().get_parent()
	initialize_all_buttons()
	_on_heal_potion(true)
	
func start():
	_on_heal_potion(true)

func initialize_all_buttons():
	healPotionScene = storeButtonScene.instance()
	var healPotionVal = Global.upgradeDict[str("healingPotionHP")].get(str(SavedGames.saveGameDict["healingPotionHP"]),[0,"Max"])
	healPotionScene.initialize("healPotion", healPotionVal[1])
	healPotionScene.connect("gui_input",self,"_on_heal_potion_container")
	healPotionScene.find_node("Button").connect("button_up",self,"_on_heal_potion")
	$GridContainer.add_child(healPotionScene)
	
	
	powerupPotionScene = storeButtonScene.instance()
	var powerupPotionVal = Global.upgradeDict[str("powerUpPotionHP")].get(str(SavedGames.saveGameDict["powerUpPotionHP"]),[0,"Max"])
	powerupPotionScene.initialize("powerUpPotion", powerupPotionVal[1])
	powerupPotionScene.connect("gui_input",self,"_on_powerup_potion_container")
	powerupPotionScene.find_node("Button").connect("button_up",self,"_on_powerup_potion")
	$GridContainer.add_child(powerupPotionScene)
	
	
	powerTileScene = storeButtonScene.instance()
	var powerTileVal = Global.upgradeDict[str("powerUpTileHP")].get(str(SavedGames.saveGameDict["powerUpTileHP"]),[0,"Max"])
	powerTileScene.initialize("powerTile", powerTileVal[1])
	powerTileScene.connect("gui_input",self,"_on_power_tile_container")
	powerTileScene.find_node("Button").connect("button_up",self,"_on_power_tile")
	$GridContainer.add_child(powerTileScene)
	
	
	healTileScene = storeButtonScene.instance()
	var healTileVal = Global.upgradeDict[str("healTileHP")].get(str(SavedGames.saveGameDict["healTileHP"]),[0,"Max"])
	healTileScene.initialize("healTile", healTileVal[1])
	healTileScene.connect("gui_input",self,"_on_heal_tile_container")
	healTileScene.find_node("Button").connect("button_up",self,"_on_heal_tile")
	$GridContainer.add_child(healTileScene)
	
	
	freezeTileScene = storeButtonScene.instance()
	var freezeTileVal = Global.upgradeDict[str("freezeTileHP")].get(str(SavedGames.saveGameDict["freezeTileHP"]),[0,"Max"])
	freezeTileScene.initialize("freezeTile", freezeTileVal[1])
	freezeTileScene.connect("gui_input",self,"_on_freeze_tile_container")
	freezeTileScene.find_node("Button").connect("button_up",self,"_on_freeze_tile")
	$GridContainer.add_child(freezeTileScene)
	
	
	burnTileScene = storeButtonScene.instance()
	var burnTileVal = Global.upgradeDict[str("burnTilePercent")].get(str(SavedGames.saveGameDict["burnTilePercent"]),[0,"Max"])
	burnTileScene.initialize("burnTile", burnTileVal[1])
	burnTileScene.connect("gui_input",self,"_on_burn_tile_container")
	burnTileScene.find_node("Button").connect("button_up",self,"_on_burn_tile")
	$GridContainer.add_child(burnTileScene)
	
	
	paralyseTileScene = storeButtonScene.instance()
	var paralyseTileVal = Global.upgradeDict[str("paralyzeTilePercentage")].get(str(SavedGames.saveGameDict["paralyzeTilePercentage"]),[0,"Max"])
	paralyseTileScene.initialize("paralyzeTile", paralyseTileVal[1])
	paralyseTileScene.connect("gui_input",self,"_on_paralyze_tile_container")
	paralyseTileScene.find_node("Button").connect("button_up",self,"_on_paralyze_tile")
	$GridContainer.add_child(paralyseTileScene)
	

func potion_selected_options(_heading):
	find_node("UpgradeButton").visible = true
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	$StatHeading.text = _heading


# Button Callbacks
func _on_heal_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_heal_potion()

func _on_heal_potion(_from_load=false):
	
	if not _from_load:
		_play_button_click_sound()
		
	currentSelectedButton = healPotionScene
	potion_selected_options("Heal Potion")
	find_node("StatDescription").bbcode_text = healPotionUpgradeString % SavedGames.saveGameDict["healingPotionHP"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["healingPotionHP"].has(str(SavedGames.saveGameDict["healingPotionHP"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["healingPotionHP"][str(SavedGames.saveGameDict["healingPotionHP"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false
	

func _on_powerup_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_powerup_potion()

func _on_powerup_potion():
	_play_button_click_sound()
	currentSelectedButton = powerupPotionScene
	potion_selected_options("Power-up Potion")
	find_node("StatDescription").bbcode_text = powerupPotionUpgradeString % SavedGames.saveGameDict["powerUpPotionHP"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["powerUpPotionHP"].has(str(SavedGames.saveGameDict["powerUpPotionHP"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s%%[/color][/center]" % Global.upgradeDict["powerUpPotionHP"][str(SavedGames.saveGameDict["powerUpPotionHP"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false
	
func _on_power_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_power_tile()

func _on_power_tile():
	_play_button_click_sound()
	currentSelectedButton = powerTileScene
	potion_selected_options("Power Tile")
	find_node("StatDescription").bbcode_text = powerupTileString % SavedGames.saveGameDict["powerUpTileHP"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["powerUpTileHP"].has(str(SavedGames.saveGameDict["powerUpTileHP"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["powerUpTileHP"][str(SavedGames.saveGameDict["powerUpTileHP"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false

func _on_heal_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_heal_tile()

func _on_heal_tile():
	_play_button_click_sound()
	currentSelectedButton = healTileScene
	potion_selected_options("Heal Tile")
	find_node("StatDescription").bbcode_text = healTileString % SavedGames.saveGameDict["healTileHP"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["healTileHP"].has(str(SavedGames.saveGameDict["healTileHP"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["healTileHP"][str(SavedGames.saveGameDict["healTileHP"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false

func _on_freeze_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_freeze_tile()

func _on_freeze_tile():
	_play_button_click_sound()
	currentSelectedButton = freezeTileScene
	potion_selected_options("Freeze Tile")
	find_node("StatDescription").bbcode_text = freezeTileString % SavedGames.saveGameDict["freezeTileHP"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["freezeTileHP"].has(str(SavedGames.saveGameDict["freezeTileHP"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["freezeTileHP"][str(SavedGames.saveGameDict["freezeTileHP"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false

func _on_burn_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_burn_tile()

func _on_burn_tile():
	_play_button_click_sound()
	currentSelectedButton = burnTileScene
	potion_selected_options("Burn Tile")
	find_node("StatDescription").bbcode_text = burnTileString % SavedGames.saveGameDict["burnTilePercent"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["burnTilePercent"].has(str(SavedGames.saveGameDict["burnTilePercent"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s%%[/color][/center]" % Global.upgradeDict["burnTilePercent"][str(SavedGames.saveGameDict["burnTilePercent"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false

func _on_paralyze_tile_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_paralyze_tile()

func _on_paralyze_tile():
	_play_button_click_sound()
	currentSelectedButton = paralyseTileScene
	potion_selected_options("Paralyse Tile")
	find_node("StatDescription").bbcode_text = paralyzeTileString % SavedGames.saveGameDict["paralyzeTilePercentage"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["paralyzeTilePercentage"].has(str(SavedGames.saveGameDict["paralyzeTilePercentage"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s%%[/color][/center]" % Global.upgradeDict["paralyzeTilePercentage"][str(SavedGames.saveGameDict["paralyzeTilePercentage"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false


func _upgrade(_upgradeDict):
	var _upgradeVals = Global.upgradeDict[str(_upgradeDict)][str(SavedGames.saveGameDict[_upgradeDict])]
	if SavedGames.saveGameDict["coins"] >= int(_upgradeVals[1]):
		SavedGames.saveGameDict["coins"] -= int(_upgradeVals[1])
		SavedGames.saveGameDict[_upgradeDict] = int(_upgradeVals[0])
		SavedGames.save_game_state()
		
		return true
	else:
		storeSceneRef.noCoinsRef.toggle()
		return false


func _play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()

func _on_UpgradeButton_button_up():
	
	if SavedGames.saveGameDict["soundEnabled"]:
		$UpgradeSound.play()
	
	if currentSelectedButton == healPotionScene:
		if _upgrade("healingPotionHP"):
			_on_heal_potion()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerHealthVal = Global.upgradeDict[str("healingPotionHP")].get(str(SavedGames.saveGameDict["healingPotionHP"]),[0,"Max"])
			healPotionScene.update_price(playerHealthVal[1])
	
	elif currentSelectedButton == powerupPotionScene:
		if _upgrade("powerUpPotionHP"):
			_on_powerup_potion()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerAtkVal = Global.upgradeDict[str("powerUpPotionHP")].get(str(SavedGames.saveGameDict["powerUpPotionHP"]),[0,"Max"])
			powerupPotionScene.update_price(playerAtkVal[1])
	
	elif currentSelectedButton == powerTileScene:
		if _upgrade("powerUpTileHP"):
			_on_power_tile()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerDefVal = Global.upgradeDict[str("powerUpTileHP")].get(str(SavedGames.saveGameDict["powerUpTileHP"]),[0,"Max"])
			powerTileScene.update_price(playerDefVal[1])
	
	elif currentSelectedButton == healTileScene:
		if _upgrade("healTileHP"):
			_on_heal_tile()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerCriticalHitPercentVal = Global.upgradeDict[str("healTileHP")].get(str(SavedGames.saveGameDict["healTileHP"]),[0,"Max"])
			healTileScene.update_price(playerCriticalHitPercentVal[1])
	
	elif currentSelectedButton == freezeTileScene:
		if _upgrade("freezeTileHP"):
			_on_freeze_tile()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerCriticalHitPercentVal = Global.upgradeDict[str("freezeTileHP")].get(str(SavedGames.saveGameDict["freezeTileHP"]),[0,"Max"])
			freezeTileScene.update_price(playerCriticalHitPercentVal[1])
	
	elif currentSelectedButton == burnTileScene:
		if _upgrade("burnTilePercent"):
			_on_burn_tile()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerCriticalHitPercentVal = Global.upgradeDict[str("burnTilePercent")].get(str(SavedGames.saveGameDict["burnTilePercent"]),[0,"Max"])
			burnTileScene.update_price(playerCriticalHitPercentVal[1])
	
	else:
		if _upgrade("paralyzeTilePercentage"):
			_on_paralyze_tile()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerDodgePercentVal = Global.upgradeDict[str("paralyzeTilePercentage")].get(str(SavedGames.saveGameDict["paralyzeTilePercentage"]),[0,"Max"])
			paralyseTileScene.update_price(playerDodgePercentVal[1])
