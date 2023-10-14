extends Control

var levelButton = preload("res://Scenes/Level/LevelButton.tscn")
var rewardChestScene = preload("res://Scenes/Level/ChestUnlock.tscn")
var gridSelected = 1
var toggleMenu = false
var sceneRoot
var parentScene
var chestSceneRef

var levelButtonDict = {}

func _process(_delta):
	if gridSelected == 1:
		$PreviousLevelList.visible = false
	else:
		$PreviousLevelList.visible = true
	
	if gridSelected == 6:
		$NextLevelList.visible = false
	else:
		$NextLevelList.visible = true
	

func _ready():
	sceneRoot = get_parent().get_parent()
	parentScene = sceneRoot.get_parent()
	_hide_all_grids()
	initialize_buttons()
	initialize_active_grid()
	
	chestSceneRef = rewardChestScene.instance()
	add_child(chestSceneRef)
	
	show_reward_chest()
	

func initialize_buttons():
	for btn in range(1,51):
		var levelButtonRef = levelButton.instance()
		levelButtonRef.initialize(str(btn))
		
		levelButtonDict[btn] = levelButtonRef
		
		# Disabling the button if the level isn't unlocked
		if btn > SavedGames.saveGameDict["maxUnlockedLevel"]:
			levelButtonRef.find_node("TextureButton").disabled = true
		
		levelButtonRef.connect("selectLevel",self,"_on_level_select_button_pressed")
		
		var container
		if btn <= 9:
			container = find_node("GridContainer1")
		elif btn <= 18:
			container = find_node("GridContainer2")
		elif btn <= 27:
			container = find_node("GridContainer3")
		elif btn <= 36:
			container = find_node("GridContainer4")
		elif btn <= 45:
			container = find_node("GridContainer5")
		else:
			container = find_node("GridContainer6")
		container.add_child(levelButtonRef)


func show_reward_chest():
	var reward_unlock_dict = {
		1 : "firstChestClaimed", 2 : "secondChestClaimed", 3:"thirdChestClaimed",
		4 : "fourthChestClaimed", 5 : "fifthChestClaimed", 6 : "sixthChestClaimed"
	}
	
	var reward_number = int(SavedGames.saveGameDict["maxUnlockedLevel"])/9
	if reward_number > 0 and not SavedGames.saveGameDict.get(str(reward_unlock_dict.get(reward_number,false)),false):
		find_node("RewardChest").visible = true


func _on_RewardChest_button_up():
	find_node("RewardChest").visible = false
	var reward_number = int(SavedGames.saveGameDict["maxUnlockedLevel"])/9
	
	var unlock_dict = {
		"Coins" : 0, 
		"Healing Potion" : 0, "Longest Word Finder" : 0, "Magic Tile Potion" : 0,
		"Purify Potion" : 0, "Shuffle Potion" : 0, "Power-up Potion" : 0
	}
	if reward_number >= 1 and not SavedGames.saveGameDict["firstChestClaimed"]:
		SavedGames.saveGameDict["firstChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 3000
		SavedGames.saveGameDict["healingPotionCount"] += 1
		SavedGames.saveGameDict["longestWordFinderCount"] += 1
		
		unlock_dict["Coins"] += 3000
		unlock_dict["Healing Potion"] += 1
		unlock_dict["Longest Word Finder"] += 1
		
	
	if reward_number >= 2 and not SavedGames.saveGameDict["secondChestClaimed"]:
		SavedGames.saveGameDict["secondChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 6000
		SavedGames.saveGameDict["powerTilePotionCount"] += 1
		SavedGames.saveGameDict["purifyPotionCount"] += 1
		
		unlock_dict["Coins"] += 6000
		unlock_dict["Magic Tile Potion"] += 1
		unlock_dict["Purify Potion"] += 1
	
	if reward_number >= 3 and not SavedGames.saveGameDict["thirdChestClaimed"]:
		SavedGames.saveGameDict["thirdChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 9000
		SavedGames.saveGameDict["freeShuffleCount"] += 1
		SavedGames.saveGameDict["longestWordFinderCount"] += 1
		
		unlock_dict["Coins"] += 9000
		unlock_dict["Shuffle Potion"] += 1
		unlock_dict["Longest Word Finder"] += 1
	
	if reward_number >= 4 and not SavedGames.saveGameDict["fourthChestClaimed"]:
		SavedGames.saveGameDict["fourthChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 12000
		SavedGames.saveGameDict["powerTilePotionCount"] += 2
		SavedGames.saveGameDict["longestWordFinderCount"] += 1
		
		unlock_dict["Coins"] += 12000
		unlock_dict["Magic Tile Potion"] += 2
		unlock_dict["Longest Word Finder"] += 1
	
	if reward_number >= 5 and not SavedGames.saveGameDict["fifthChestClaimed"]:
		SavedGames.saveGameDict["fifthChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 15000
		SavedGames.saveGameDict["purifyPotionCount"] += 2
		SavedGames.saveGameDict["longestWordFinderCount"] += 2
		
		unlock_dict["Coins"] += 15000
		unlock_dict["Purify Potion"] += 2
		unlock_dict["Longest Word Finder"] += 2
	
	if int(SavedGames.saveGameDict["maxUnlockedLevel"]) >= 50 and not SavedGames.saveGameDict["sixthChestClaimed"]:
		SavedGames.saveGameDict["sixthChestClaimed"] = true
		SavedGames.saveGameDict["coins"] += 30000
		SavedGames.saveGameDict["healingPotionCount"] += 5
		SavedGames.saveGameDict["powerUpPotionCount"] += 5
		
		unlock_dict["Coins"] += 30000
		unlock_dict["Healing Potion"] += 5
		unlock_dict["Longest Word Finder"] += 5
		
	SavedGames.save_game_state()
	parentScene.storeRef.find_node("PotionsScreen").update_potions_count()
	
	chestSceneRef.unlock_chest(unlock_dict)
	

func _hide_all_grids():
	find_node("GridContainer1").visible = false
	find_node("GridContainer2").visible = false
	find_node("GridContainer3").visible = false
	find_node("GridContainer4").visible = false
	find_node("GridContainer5").visible = false
	find_node("GridContainer6").visible = false


func initialize_active_grid():
	var gridActive = float(SavedGames.saveGameDict["maxUnlockedLevel"]) / float(9)
	var gridSelectedTemp = float(gridActive)
	gridSelected = ceil(gridSelectedTemp)
	if gridSelected < 1:
		gridSelected = 1
	elif gridSelected >=6 :
		gridSelected = 6
	$AnimationPlayer.play("GridContainer"+str(gridSelected))

func _on_level_select_button_pressed(_level):
	_play_button_click_sound()
	Global.level = int(_level)
	Global.isEndlessMode = false
	Global.goto_scene("res://Scenes/Play/PlayScene.tscn", parentScene)


func _on_BackButton_button_up():
	_play_button_click_sound()
	toggle_menu()


func _on_StoreButton_button_up():
	_play_button_click_sound()
	parentScene.storeRef.toggle_menu()


func _on_PreviousLevelList_button_up():
	_play_button_click_sound()
	if gridSelected > 1:
		_hide_all_grids()
		gridSelected -= 1
		$AnimationPlayer.play("GridContainer"+str(gridSelected))


func _on_NextLevelList_button_up():
	_play_button_click_sound()
	if gridSelected < 6:
		_hide_all_grids()
		gridSelected += 1
		$AnimationPlayer.play("GridContainer"+str(gridSelected))
		

func _play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$DefaultButtonClick.play()

func toggle_menu():
	toggleMenu = not toggleMenu
	sceneRoot.find_node("Level").visible = toggleMenu
	sceneRoot.find_node("Background").visible = toggleMenu
