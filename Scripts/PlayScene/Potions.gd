extends Control

var toggleMenu = false
var sceneRoot
var playScene

var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")

# Button References
var healPotionScene
var powerUpPotionScene
var magicTilePotionScene
var longestWordFinderScene
var purifyPotionScene

# String formats for store string values
var healPotionString = "Heals health by %s HP"
var powerupPotionString = "Increases total damage by %s%% for one turn"
var magicTilePotionString = "Adds 1 magic tile to your grid"
var longestWordFinderString = "Finds the longest word in the current grid"
var purifyPotionString = "Removes all the enemy tiles from the grid"


var letterMapping = {
	"e":2, "a":3, "i":5,"r":7,"o":11,"t":13,"n":17,"s":19,"l":23,
	"c":29,"u":31,"d":37,"p":41,"m":43,"h":47,"g":53,"b":59,
	"f":61,"y":67,"w":71,"k":73,"v":79,"x":83,"j":89,"q":97,"z":101, "?" : 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneRoot = get_parent().get_parent()
	playScene = sceneRoot.get_parent()
	initialize_all_buttons()
	_on_heal_potion(true)

func start():
	_on_heal_potion(true)

func initialize_all_buttons():
	healPotionScene = storeButtonScene.instance()
	healPotionScene.initialize("healPotion", "-1", SavedGames.saveGameDict["healingPotionCount"])
	healPotionScene.isSmallNum = true
	healPotionScene.find_node("Button").connect("button_up",self,"_on_heal_potion")
	healPotionScene.connect("gui_input",self,"_on_heal_potion_container")
	$GridContainer.add_child(healPotionScene)
	
	powerUpPotionScene = storeButtonScene.instance()
	powerUpPotionScene.initialize("powerUpPotion", "-1", SavedGames.saveGameDict["powerUpPotionCount"])
	powerUpPotionScene.isSmallNum = true
	powerUpPotionScene.find_node("Button").connect("button_up",self,"_on_power_up_potion")
	powerUpPotionScene.connect("gui_input",self,"_on_power_up_potion_container")
	$GridContainer.add_child(powerUpPotionScene)
	
	magicTilePotionScene = storeButtonScene.instance()
	magicTilePotionScene.initialize("magicTilePotion","-1", SavedGames.saveGameDict["powerTilePotionCount"])
	magicTilePotionScene.isSmallNum = true
	magicTilePotionScene.find_node("Button").connect("button_up",self,"_on_magic_tile_potion")
	magicTilePotionScene.connect("gui_input",self,"_on_magic_tile_potion_container")
	$GridContainer.add_child(magicTilePotionScene)
	
	longestWordFinderScene = storeButtonScene.instance()
	longestWordFinderScene.initialize("longestWordFinder", "-1", SavedGames.saveGameDict["longestWordFinderCount"])
	longestWordFinderScene.isSmallNum = true
	longestWordFinderScene.find_node("Button").connect("button_up",self,"_on_longest_word_finder")
	longestWordFinderScene.connect("gui_input",self,"_on_longest_word_finder_container")
	$GridContainer.add_child(longestWordFinderScene)
	
	purifyPotionScene = storeButtonScene.instance()
	purifyPotionScene.initialize("purifyPotion", "-1", SavedGames.saveGameDict["purifyPotionCount"])
	purifyPotionScene.isSmallNum = true
	purifyPotionScene.find_node("Button").connect("button_up",self,"_on_purify_potion")
	purifyPotionScene.connect("gui_input",self,"_on_purify_potion_container")
	$GridContainer.add_child(purifyPotionScene)


func potion_selected_options(_heading, _description, _count):
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	$PotionHeading.text = _heading
	$PotionDescription.text = _description
	
	if int(_count) > 0 :
		$Use.visible = true
	else:
		$Use.visible = false

# Button Callbacks
func _on_heal_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_heal_potion()

func _on_heal_potion(_from_load=false):
	if not _from_load:
		playScene.play_button_click_sound()
	currentSelectedButton = healPotionScene
	potion_selected_options("Heal Potion", healPotionString % SavedGames.saveGameDict["healingPotionHP"], SavedGames.saveGameDict["healingPotionCount"])

func _on_power_up_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_power_up_potion()

func _on_power_up_potion():
	playScene.play_button_click_sound()
	currentSelectedButton = powerUpPotionScene
	potion_selected_options("Power-up Potion", powerupPotionString % SavedGames.saveGameDict["powerUpPotionHP"], SavedGames.saveGameDict["powerUpPotionCount"])

func _on_magic_tile_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_magic_tile_potion()

func _on_magic_tile_potion():
	playScene.play_button_click_sound()
	currentSelectedButton = magicTilePotionScene
	potion_selected_options("Magic Tile Potion", magicTilePotionString, SavedGames.saveGameDict["powerTilePotionCount"])

func _on_longest_word_finder_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_longest_word_finder()

func _on_longest_word_finder():
	playScene.play_button_click_sound()
	currentSelectedButton = longestWordFinderScene
	potion_selected_options("Longest Word Finder", longestWordFinderString, SavedGames.saveGameDict["longestWordFinderCount"])

func _on_purify_potion_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_purify_potion()

func _on_purify_potion():
	playScene.play_button_click_sound()
	currentSelectedButton = purifyPotionScene
	potion_selected_options("Purify Potion", purifyPotionString, SavedGames.saveGameDict["purifyPotionCount"])


func _on_Use_button_up():
	playScene.play_button_click_sound()
	find_node("PotionUseSound").play()
	
	if currentSelectedButton == healPotionScene:
		_on_HealthPotionUse_button_up()
		currentSelectedButton.update_count(SavedGames.saveGameDict["healingPotionCount"])
		disable_use_button(SavedGames.saveGameDict["healingPotionCount"])
	elif currentSelectedButton == powerUpPotionScene:
		_on_PowerupPotionUse_button_up()
		currentSelectedButton.update_count(SavedGames.saveGameDict["powerUpPotionCount"])
		disable_use_button(SavedGames.saveGameDict["powerUpPotionCount"])
	elif currentSelectedButton == magicTilePotionScene:
		_on_PowerTileUse_button_up()
		currentSelectedButton.update_count(SavedGames.saveGameDict["powerTilePotionCount"])
		disable_use_button(SavedGames.saveGameDict["powerTilePotionCount"])
	elif currentSelectedButton == longestWordFinderScene:
		_on_LongestWordFinderUse_button_up()
		currentSelectedButton.update_count(SavedGames.saveGameDict["longestWordFinderCount"])
		disable_use_button(SavedGames.saveGameDict["longestWordFinderCount"])
	else:
		_on_PurifyPotionUse_button_up()
		currentSelectedButton.update_count(SavedGames.saveGameDict["purifyPotionCount"])
		disable_use_button(SavedGames.saveGameDict["purifyPotionCount"])


func update_all_counts():
	healPotionScene.update_count(SavedGames.saveGameDict["healingPotionCount"])
	powerUpPotionScene.update_count(SavedGames.saveGameDict["powerUpPotionCount"])
	magicTilePotionScene.update_count(SavedGames.saveGameDict["powerTilePotionCount"])
	longestWordFinderScene.update_count(SavedGames.saveGameDict["longestWordFinderCount"])
	purifyPotionScene.update_count(SavedGames.saveGameDict["purifyPotionCount"])

func disable_use_button(_count):
	if _count == 0:
		$Use.visible = false

	
func toggle_menu():
	toggleMenu = not toggleMenu
	self.visible = toggleMenu
	sceneRoot.find_node("BackgroundTint").visible = toggleMenu
	#get_tree().paused = toggleMenu


func _on_CloseButton_button_up():
	playScene.play_button_click_sound()
	toggle_menu()

func _on_PowerupPotionUse_button_up():
	toggle_menu()
	
	# Updating the powerup potion count
	SavedGames.saveGameDict["powerUpPotionCount"] -= 1
	SavedGames.save_game_state()
	
	playScene.isPowerupPotionSet = true


func find_longest_word(is_ad=false):
	# Getting the current letters of the grid
	var longestCount = 9223372036854775807
	var gridMultiplication = 1
	
	# Deselecting the selected buttons grid
	var selectedButtons = playScene.find_node("SelectedLettersGrid")
	if selectedButtons.get_child_count() >= 1:
		var selectedCenterContainer = selectedButtons.get_child(0)
		var selectedTextureButton = selectedCenterContainer.get_node("SelectedButtonTextureButton")
		selectedTextureButton.simulate_selected_texture_button_press()
	
	#Getting the grid buttons and calculating the multiplication
	var multiplicationList = []
	var buttons = playScene.find_node("Buttons")
	for iter in buttons.get_child_count():
		var centerContainer = buttons.get_child(iter)
		var letter = str(centerContainer.find_node("Label").text).to_lower()
		multiplicationList.append(letterMapping[letter])
	multiplicationList.sort()
	for listItem in multiplicationList:
		if gridMultiplication < (longestCount/listItem):
			gridMultiplication *= listItem
		else:
			break
	
	# Finding the longest word
	var longestWord = ""
	for dictWord in playScene.dictionary.keys():
		if is_ad and len(dictWord) > 8:
			continue
		var dictWordValue = int(playScene.dictionary[str(dictWord)])
		if dictWordValue !=0:
			var divisionVal = int(gridMultiplication / dictWordValue)
			if divisionVal*dictWordValue == gridMultiplication:
				longestWord = dictWord
				break
	
	# Logic to shuffle the grid and find again if no longest word was found
	# For Find a word button
	if len(longestWord) < 5 and is_ad:
		playScene.find_node("ShuffleButton").simulate_suffle_button_press()
		return find_longest_word(is_ad)
	
	# For Longest Word Finder
	if len(longestWord) < 7 and not is_ad:
		playScene.find_node("ShuffleButton").simulate_suffle_button_press()
		return find_longest_word(is_ad)
	
	
	# Finding the buttons in the grid and clicking them
	for character in longestWord:
		for iter in buttons.get_child_count():
			var centerContainer = buttons.get_child(iter)
			var textureButtonRef = centerContainer.find_node("TextureButton")
			var letter = str(centerContainer.find_node("Label").text).to_lower()
			if letter == character and !textureButtonRef.disabled:
				centerContainer.simulate_texture_button_press()
				yield(get_tree().create_timer(0.05), "timeout")
				break
	return true


func _on_LongestWordFinderUse_button_up():
	toggle_menu()
	
	playScene.find_node("HideButtons").visible = true
	
	if find_longest_word():
		SavedGames.saveGameDict["longestWordFinderCount"] -= 1
		SavedGames.save_game_state()
	
	playScene.find_node("HideButtons").visible = false


func _get_tile_type():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_integer = rng.randf_range(0.0,100.0)
	
	var tile_type = "Simple"
	if random_integer < 10:
		tile_type = "Powerup"
	elif random_integer >= 10 and random_integer < 30:
		tile_type = "Heal"
	elif random_integer >= 30 and random_integer < 60:
		tile_type = "Freeze"
	elif random_integer >= 60 and random_integer < 70:
		# Condition to ensure that we don't end up with two ? tiles on the grid
		var buttons = playScene.get_node("Buttons")
		var buttonsControlCount = buttons.get_child_count()
		for iter in buttonsControlCount:
			var centerContainer = buttons.get_child(iter)
			var textureButton : TextureButton = centerContainer.find_node("TextureButton")
			if not textureButton.disabled and centerContainer.find_node("Label").text=="?":
				return _get_tile_type()
		tile_type = "QuestionMark"
	elif random_integer >= 70 and random_integer < 90:
		tile_type = "Burn"
	else:
		tile_type = "Paralyse"
	
	return tile_type

func _on_PowerTileUse_button_up():
	toggle_menu()
	var _tile_type = _get_tile_type()
	var buttons = playScene.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		if not textureButton.disabled and centerContainer.special_effect == "Simple":
			var previousText = centerContainer.find_node("Label").text
			centerContainer.initialize(playScene.buttonBaseDamage, _tile_type, centerContainer.pos)
			if centerContainer.special_effect != "QuestionMark":
				centerContainer.find_node("Label").text = str(previousText)
			SavedGames.saveGameDict["powerTilePotionCount"] -= 1
			SavedGames.save_game_state()
			#Global.show_floating_text(playScene,_tile_type+" added to grid","")
			return
	


func _on_HealthPotionUse_button_up():
	toggle_menu()
	
	# Updating the healing potion count
	SavedGames.saveGameDict["healingPotionCount"] -= 1
	SavedGames.save_game_state()
	
	# Updating the health
	if (playScene.playerRef.health+SavedGames.saveGameDict["healingPotionHP"]) <= playScene.playerHealth:
		playScene.playerRef.health += SavedGames.saveGameDict["healingPotionHP"]
	else:
		playScene.playerRef.health = playScene.playerHealth
	playScene.get_node("PlayerHealthBar").set_health_value(playScene.playerRef.health)
	Global.show_floating_text(playScene.playerRef, "+%s"%SavedGames.saveGameDict["healingPotionHP"],"heal",Vector2(100,0))


func _on_PurifyPotionUse_button_up():
	toggle_menu()
	var buttons = playScene.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	var tilesPurified = false
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		if centerContainer.special_effect == "noDamageTile" or centerContainer.special_effect == "decreaseHealthTile":
			var previousText = centerContainer.find_node("Label").text
			centerContainer.initialize(playScene.buttonBaseDamage, "Simple", centerContainer.pos)
			centerContainer.find_node("Label").text = str(previousText)
			tilesPurified = true
	
	if tilesPurified:
		SavedGames.saveGameDict["purifyPotionCount"] -= 1
		SavedGames.save_game_state()
		Global.show_floating_text(playScene,"Enemy Tile Removed","",Vector2(-100,-100))
	else:
		Global.show_floating_text(playScene,"No Enemy Tiles","",Vector2(-100,-100))
