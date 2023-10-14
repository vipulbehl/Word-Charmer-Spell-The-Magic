extends Control

var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")
var storeSceneRef

# Button References
var healPotionScene
var powerUpPotionScene
var magicTilePotionScene
var longestWordFinderScene
var shufflePotionScene
var purifyPotionScene

# String formats for store string values
var healPotionString = "[center]Heals health by [color=#0091FF]%s HP[/color][/center]"
var powerupPotionString = "[center]Increases total damage by [color=#0091FF]%s%%[/color][/center]"


# Potions prices
var healPotionPrice = {"50":200,"70":210,"100":300,"130":390,"160":480,"200":600,"250":750,"300":900,"350":1050,"400":1200,"450":1350,"500":1500,"600":1800,"700":2100,"800":2400,"1000":3000}
var powerupPotionPrice = {"50":200,"60":300,"70":350,"80":480,"90":540,"100":700,"120":840,"140":1120,"160":1280,"180":1620,"200":2000}
var powerTilePotionPrice = 200 + int(12 * SavedGames.saveGameDict["maxUnlockedLevel"])
var longestWordPrice = 1000 + int(40 * SavedGames.saveGameDict["maxUnlockedLevel"])
var freeShufflePrice = 100 + int(9 * SavedGames.saveGameDict["maxUnlockedLevel"])
var purifyPotionPrice = 500 + int(10 * SavedGames.saveGameDict["maxUnlockedLevel"])


# Called when the node enters the scene tree for the first time.
func _ready():
	storeSceneRef = get_parent().get_parent().get_parent()
	initialize_all_buttons()
	_on_heal_potion(true)
	
func _process(_delta):
	healPotionScene.update_price(healPotionPrice[str(SavedGames.saveGameDict["healingPotionHP"])])
	powerUpPotionScene.update_price(powerupPotionPrice[str(SavedGames.saveGameDict["powerUpPotionHP"])])

func start():
	_on_heal_potion(true)

func update_potions_count():
	healPotionScene.update_count(SavedGames.saveGameDict["healingPotionCount"])
	powerUpPotionScene.update_count(SavedGames.saveGameDict["powerUpPotionCount"])
	magicTilePotionScene.update_count(SavedGames.saveGameDict["powerTilePotionCount"])
	longestWordFinderScene.update_count(SavedGames.saveGameDict["longestWordFinderCount"])
	shufflePotionScene.update_count(SavedGames.saveGameDict["freeShuffleCount"])
	purifyPotionScene.update_count(SavedGames.saveGameDict["purifyPotionCount"])
	
	
func initialize_all_buttons():
	healPotionScene = storeButtonScene.instance()
	healPotionScene.initialize("healPotion", healPotionPrice[str(SavedGames.saveGameDict["healingPotionHP"])], SavedGames.saveGameDict["healingPotionCount"])
	healPotionScene.find_node("Button").connect("button_up",self,"_on_heal_potion")
	healPotionScene.connect("gui_input",self,"_on_heal_potion_container")
	$GridContainer.add_child(healPotionScene)
	
	powerUpPotionScene = storeButtonScene.instance()
	powerUpPotionScene.initialize("powerUpPotion", powerupPotionPrice[str(SavedGames.saveGameDict["powerUpPotionHP"])], SavedGames.saveGameDict["powerUpPotionCount"])
	powerUpPotionScene.find_node("Button").connect("button_up",self,"_on_power_up_potion")
	powerUpPotionScene.connect("gui_input",self,"_on_power_up_potion_container")
	$GridContainer.add_child(powerUpPotionScene)
	
	magicTilePotionScene = storeButtonScene.instance()
	magicTilePotionScene.initialize("magicTilePotion",powerTilePotionPrice, SavedGames.saveGameDict["powerTilePotionCount"])
	magicTilePotionScene.find_node("Button").connect("button_up",self,"_on_magic_tile_potion")
	magicTilePotionScene.connect("gui_input",self,"_on_magic_tile_potion_container")
	$GridContainer.add_child(magicTilePotionScene)
	
	longestWordFinderScene = storeButtonScene.instance()
	longestWordFinderScene.initialize("longestWordFinder", longestWordPrice, SavedGames.saveGameDict["longestWordFinderCount"])
	longestWordFinderScene.find_node("Button").connect("button_up",self,"_on_longest_word_finder")
	longestWordFinderScene.connect("gui_input",self,"_on_longest_word_finder_container")
	$GridContainer.add_child(longestWordFinderScene)
	
	purifyPotionScene = storeButtonScene.instance()
	purifyPotionScene.initialize("purifyPotion", purifyPotionPrice, SavedGames.saveGameDict["purifyPotionCount"])
	purifyPotionScene.find_node("Button").connect("button_up",self,"_on_purify_potion")
	purifyPotionScene.connect("gui_input",self,"_on_purify_potion_container")
	$GridContainer.add_child(purifyPotionScene)
	
	shufflePotionScene = storeButtonScene.instance()
	shufflePotionScene.initialize("shufflePotion", freeShufflePrice, SavedGames.saveGameDict["freeShuffleCount"])
	shufflePotionScene.find_node("Button").connect("button_up",self,"_on_shuffle_potion")
	shufflePotionScene.connect("gui_input",self,"_on_shuffle_potion_container")
	$GridContainer.add_child(shufflePotionScene)
	

func potion_selected_options(_heading):
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	$PotionHeading.text = _heading

# Button Callbacks
func _on_heal_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_heal_potion()
	
func _on_heal_potion(_from_load=false):
	if not _from_load:
		_play_button_click_sound()
	currentSelectedButton = healPotionScene
	potion_selected_options("Heal Potion")
	$PotionDescription.bbcode_text = healPotionString % SavedGames.saveGameDict["healingPotionHP"]

func _on_power_up_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_power_up_potion()

func _on_power_up_potion():
	_play_button_click_sound()
	currentSelectedButton = powerUpPotionScene
	potion_selected_options("Power-up Potion")
	$PotionDescription.bbcode_text = powerupPotionString % SavedGames.saveGameDict["powerUpPotionHP"]

func _on_magic_tile_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_magic_tile_potion()

func _on_magic_tile_potion():
	_play_button_click_sound()
	currentSelectedButton = magicTilePotionScene
	potion_selected_options("Magic Tile Potion")
	$PotionDescription.bbcode_text = "[center]Randomly adds one magic tile to your grid[/center]"

func _on_longest_word_finder_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_longest_word_finder()

func _on_longest_word_finder():
	_play_button_click_sound()
	currentSelectedButton = longestWordFinderScene
	potion_selected_options("Longest Word Finder")
	$PotionDescription.bbcode_text = "[center]Finds the longest word in the current grid, auto shuffles if no word is found[/center]"

func _on_shuffle_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_shuffle_potion()

func _on_shuffle_potion():
	_play_button_click_sound()
	currentSelectedButton = shufflePotionScene
	potion_selected_options("Shuffle Potion")
	$PotionDescription.bbcode_text = "[center]Shuffles the grid without losing your turn[/center]"

func _on_purify_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_purify_potion()

func _on_purify_potion():
	_play_button_click_sound()
	currentSelectedButton = purifyPotionScene
	potion_selected_options("Purify Potion")
	$PotionDescription.bbcode_text = "[center]Removes all enemy tiles present in the grid[/center]"


func _potions_buy(_potion_type, _potion_price):
	if SavedGames.saveGameDict["coins"] >= _potion_price:
		SavedGames.saveGameDict["coins"] -= _potion_price
		SavedGames.saveGameDict[_potion_type] += 1
		SavedGames.save_game_state()
		get_parent().get_parent().get_parent().play_coins_sound()
		currentSelectedButton.update_count(SavedGames.saveGameDict[_potion_type])
	else:
		storeSceneRef.noCoinsRef.toggle()


func _play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()

func _on_BuyButton_button_up():
	
	if SavedGames.saveGameDict["soundEnabled"]:
		$BuyButtonSound.play()
	
	if currentSelectedButton == healPotionScene:
		_potions_buy("healingPotionCount",healPotionPrice[str(SavedGames.saveGameDict["healingPotionHP"])])
	elif currentSelectedButton == powerUpPotionScene:
		_potions_buy("powerUpPotionCount",powerupPotionPrice[str(SavedGames.saveGameDict["powerUpPotionHP"])])
	elif currentSelectedButton == magicTilePotionScene:
		_potions_buy("powerTilePotionCount",powerTilePotionPrice)
	elif currentSelectedButton == longestWordFinderScene:
		_potions_buy("longestWordFinderCount",longestWordPrice)
	elif currentSelectedButton == shufflePotionScene:
		_potions_buy("freeShuffleCount",freeShufflePrice)
	else:
		_potions_buy("purifyPotionCount",purifyPotionPrice)
