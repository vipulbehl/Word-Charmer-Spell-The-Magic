extends Control

var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")
var storeSceneRef

# Button References
var playerHealthScene
var playerAtkScene
var playerDefScene
var playerCriticalHitPercentScene
var playerDodgePercentScene

# Upgrade Strings
var healthStatString = "[center]Current Health [color=#0091FF]%s HP[/color][/center]"
var attackStatString = "[center]Current Attack Power [color=#0091FF]%s HP[/color][/center]"
var defenseStatString = "[center]Current Defense [color=#0091FF]%s HP[/color][/center]"
var criticalHitStatString = "[center]Doubles the damage dealt\n Current Critical Hit [color=#0091FF]%s%%[/color][/center]"
var dodgeStatString = "[center]Dodges the enemy attack \n Current Dodge [color=#0091FF]%s%%[/color][/center]"

func _ready():
	storeSceneRef = get_parent().get_parent().get_parent()
	initialize_all_buttons()
	_on_health(true)

func start():
	_on_health(true)

func initialize_all_buttons():
	playerHealthScene = storeButtonScene.instance()
	var playerHealthVal = Global.upgradeDict[str("playerHealth")].get(str(SavedGames.saveGameDict["playerHealth"]),[0,"Max"])
	playerHealthScene.initialize("health", playerHealthVal[1])
	playerHealthScene.connect("gui_input",self,"_on_health_container")
	playerHealthScene.find_node("Button").connect("button_up",self,"_on_health")
	$GridContainer.add_child(playerHealthScene)
	
	playerAtkScene = storeButtonScene.instance()
	var playerAtkVal = Global.upgradeDict[str("playerAtk")].get(str(SavedGames.saveGameDict["playerAtk"]),[0,"Max"])
	playerAtkScene.initialize("attack", playerAtkVal[1])
	playerAtkScene.connect("gui_input",self,"_on_attack_container")
	playerAtkScene.find_node("Button").connect("button_up",self,"_on_attack")
	$GridContainer.add_child(playerAtkScene)
	
	playerDefScene = storeButtonScene.instance()
	var playerDefVal = Global.upgradeDict[str("playerDef")].get(str(SavedGames.saveGameDict["playerDef"]),[0,"Max"])
	playerDefScene.initialize("defense", playerDefVal[1])
	playerDefScene.connect("gui_input",self,"_on_defense_container")
	playerDefScene.find_node("Button").connect("button_up",self,"_on_defense")
	$GridContainer.add_child(playerDefScene)
	
	playerCriticalHitPercentScene = storeButtonScene.instance()
	var playerCriticalHitPercentVal = Global.upgradeDict[str("playerCriticalHitPercent")].get(str(SavedGames.saveGameDict["playerCriticalHitPercent"]),[0,"Max"])
	playerCriticalHitPercentScene.initialize("criticalHitPercent", playerCriticalHitPercentVal[1])
	playerCriticalHitPercentScene.connect("gui_input",self,"_on_critical_container")
	playerCriticalHitPercentScene.find_node("Button").connect("button_up",self,"_on_critical_hit")
	$GridContainer.add_child(playerCriticalHitPercentScene)
	
	playerDodgePercentScene = storeButtonScene.instance()
	var playerDodgePercentVal = Global.upgradeDict[str("playerDodgePercent")].get(str(SavedGames.saveGameDict["playerDodgePercent"]),[0,"Max"])
	playerDodgePercentScene.initialize("dodgePercent", playerDodgePercentVal[1])
	playerDodgePercentScene.connect("gui_input",self,"_on_dodge_container")
	playerDodgePercentScene.find_node("Button").connect("button_up",self,"_on_dodge")
	$GridContainer.add_child(playerDodgePercentScene)
	
	
func potion_selected_options(_heading):
	find_node("UpgradeButton").visible = true
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	$StatHeading.text = _heading

# Button Callbacks
func _on_health_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_health()

func _on_health(_from_load=false):
	if not _from_load:
		_play_button_click_sound()
	
	currentSelectedButton = playerHealthScene
	potion_selected_options("Health")
	find_node("StatDescription").bbcode_text = healthStatString % SavedGames.saveGameDict["playerHealth"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["playerHealth"].has(str(SavedGames.saveGameDict["playerHealth"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["playerHealth"][str(SavedGames.saveGameDict["playerHealth"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false

func _on_attack_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_attack()

func _on_attack():
	_play_button_click_sound()
	currentSelectedButton = playerAtkScene
	potion_selected_options("Attack")
	find_node("StatDescription").bbcode_text = attackStatString % SavedGames.saveGameDict["playerAtk"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["playerAtk"].has(str(SavedGames.saveGameDict["playerAtk"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["playerAtk"][str(SavedGames.saveGameDict["playerAtk"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false


func _on_defense_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_defense()
		

func _on_defense():
	_play_button_click_sound()
	currentSelectedButton = playerDefScene
	potion_selected_options("Defense")
	find_node("StatDescription").bbcode_text = defenseStatString % SavedGames.saveGameDict["playerDef"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["playerDef"].has(str(SavedGames.saveGameDict["playerDef"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s HP[/color][/center]" % Global.upgradeDict["playerDef"][str(SavedGames.saveGameDict["playerDef"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false


func _on_critical_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_critical_hit()

func _on_critical_hit():
	_play_button_click_sound()
	currentSelectedButton = playerCriticalHitPercentScene
	potion_selected_options("Critical Hit")
	find_node("StatDescription").bbcode_text = criticalHitStatString % SavedGames.saveGameDict["playerCriticalHitPercent"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["playerCriticalHitPercent"].has(str(SavedGames.saveGameDict["playerCriticalHitPercent"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s %%[/color][/center]" % Global.upgradeDict["playerCriticalHitPercent"][str(SavedGames.saveGameDict["playerCriticalHitPercent"])][0]
	else:
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"
		find_node("UpgradeButton").visible = false
	
func _on_dodge_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_dodge()
	
	
func _on_dodge():
	_play_button_click_sound()
	currentSelectedButton = playerDodgePercentScene
	potion_selected_options("Dodge Percent")
	find_node("StatDescription").bbcode_text = dodgeStatString % SavedGames.saveGameDict["playerDodgePercent"]
	var statsUpgradeDescription = find_node("StatUpgradeDescription")
	if Global.upgradeDict["playerDodgePercent"].has(str(SavedGames.saveGameDict["playerDodgePercent"])):
		statsUpgradeDescription.bbcode_text = "[center]Upgrade to [color=#0091FF]%s %%[/color][/center]" % Global.upgradeDict["playerDodgePercent"][str(SavedGames.saveGameDict["playerDodgePercent"])][0]
	else:
		find_node("UpgradeButton").visible = false
		statsUpgradeDescription.bbcode_text = "[center]Maxed Out[/center]"


func _upgrade(_upgradeDict):
	var _upgradeVals = Global.upgradeDict[str(_upgradeDict)][str(SavedGames.saveGameDict[_upgradeDict])]
	if SavedGames.saveGameDict["coins"] >= int(_upgradeVals[1]):
		SavedGames.saveGameDict["coins"] -= int(_upgradeVals[1])
		if "playerCriticalHitPercent" in _upgradeDict or "playerDodgePercent" in _upgradeDict:
			SavedGames.saveGameDict[_upgradeDict] = float(_upgradeVals[0])
		else:
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
		
	if currentSelectedButton == playerHealthScene:
		if _upgrade("playerHealth"):
			_on_health()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerHealthVal = Global.upgradeDict[str("playerHealth")].get(str(SavedGames.saveGameDict["playerHealth"]),[0,"Max"])
			playerHealthScene.update_price(playerHealthVal[1])
	elif currentSelectedButton == playerAtkScene:
		if _upgrade("playerAtk"):
			_on_attack()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerAtkVal = Global.upgradeDict[str("playerAtk")].get(str(SavedGames.saveGameDict["playerAtk"]),[0,"Max"])
			playerAtkScene.update_price(playerAtkVal[1])
	elif currentSelectedButton == playerDefScene:
		if _upgrade("playerDef"):
			_on_defense()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerDefVal = Global.upgradeDict[str("playerDef")].get(str(SavedGames.saveGameDict["playerDef"]),[0,"Max"])
			playerDefScene.update_price(playerDefVal[1])
	elif currentSelectedButton == playerCriticalHitPercentScene:
		if _upgrade("playerCriticalHitPercent"):
			_on_critical_hit()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerCriticalHitPercentVal = Global.upgradeDict[str("playerCriticalHitPercent")].get(str(SavedGames.saveGameDict["playerCriticalHitPercent"]),[0,"Max"])
			playerCriticalHitPercentScene.update_price(playerCriticalHitPercentVal[1])
	else:
		if _upgrade("playerDodgePercent"):
			_on_dodge()
			get_parent().get_parent().get_parent().play_coins_sound()
			var playerDodgePercentVal = Global.upgradeDict[str("playerDodgePercent")].get(str(SavedGames.saveGameDict["playerDodgePercent"]),[0,"Max"])
			playerDodgePercentScene.update_price(playerDodgePercentVal[1])
