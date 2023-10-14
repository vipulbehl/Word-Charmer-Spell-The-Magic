extends Control

# Ad params
onready var admob = $AdMob
var reviveWizardAd = false
var doubleCoinsAd = false
var storeGetCoinsAd = false
var findWordAd = false
var lastAdRequestTime = OS.get_ticks_msec()

const SPEED = 200

var dictionary = {}
var enemySpriteDictionary = {}

# Parameters particular to enemy container moving
var enemyContainerOriginalX
var MOVING_PIXELS
var enemyMoveFlag = false

var enemyCount = 1

# Turn true corresponds to player's turn and false to enemy's turn
var turn = true

var gridButton = preload("res://Scenes/Play/GridButton.tscn")
var enemyScene = preload("res://Scenes/Play/EnemyMinoTaur.tscn")
var playerScene = preload("res://Scenes/Play/NinjaScene.tscn")
var pauseScene = preload("res://Scenes/Play/PauseMenu.tscn")
var helpScene = preload("res://Scenes/Play/HelpScene.tscn")
var levelCompleteScene = preload("res://Scenes/Play/LevelComplete.tscn")
var gameOverScene = preload("res://Scenes/Play/GameOver.tscn")
var potionsScene = preload("res://Scenes/Play/Potions.tscn")
var hintAdWatchScene = preload("res://Scenes/Play/HintAdWatch.tscn")
var adNotLoadedScene = preload("res://Scenes/Play/AdNotLoaded.tscn")

# Object Refrences
var enemyRef
var playerRef
var pauseRef
var helpRef
var levelCompleteRef
var gameOverRef
var potionsRef
var hintAdWatchRef
var adNotLoadedRef

var attackWordLength
var isEnemyFreeze = false
var isEnemyBurn = false
var isEnemyParalyze = false
var isNoDamageTile = false
var isDecreaseHealthTile = false

# Player Parameters
var playerHealth
var playerDef
var buttonBaseDamage
var playerCriticalHitPercent
var playerDodgePercent

# Enemy Parameters
var enemyHealth
var enemyAttack
var enemyDef
var enemyCriticalHitPercent
var enemyDodgePercent


var enemyAnim
var enemyCoins # Coins that each enemy gives
var coinsEarned = 0

# Potions parameters
var isPowerupPotionSet = false

func _ready():
	admob.load_rewarded_video()
	
	dictionary = Global.dictionary
	_set_level_params()
	
	#Loading enemy sprites and setting up progress bar sprites
	enemy_sprite_dictionary()
	
	if not Global.isEndlessMode:
		$ProgressBar.set_sprites()
	else:
		$ProgressBar.visible = false
		$EndlessModeEnemyCount.visible = true
	
	# Initilizing Grid
	var buttons = $Buttons
	initialize_grid_buttons()
	
	# Initilizing Player
	playerRef = playerScene.instance()
	playerRef.initialize(playerHealth,buttonBaseDamage,playerDef, playerCriticalHitPercent, playerDodgePercent)
	playerRef.connect("player_dead",self,"_on_player_dead")
	$PlayerContainer.add_child(playerRef)
	$PlayerHealthBar.initialize(playerHealth,"Player")
	
	# Initializing dialogue boxes
	pauseRef = pauseScene.instance()
	helpRef = helpScene.instance()
	potionsRef = potionsScene.instance()
	levelCompleteRef = levelCompleteScene.instance()
	gameOverRef = gameOverScene.instance()
	hintAdWatchRef = hintAdWatchScene.instance()
	adNotLoadedRef = adNotLoadedScene.instance()
	add_child(pauseRef)
	add_child(helpRef)
	add_child(levelCompleteRef)
	add_child(gameOverRef)
	add_child(potionsRef)
	add_child(hintAdWatchRef)
	add_child(adNotLoadedRef)
	
	play_background_sound()
	
	# Initilizing Enemy
	_create_new_enemy()
	
	# Mapping signals
	for i in buttons.get_child_count():
		var node = buttons.get_child(i)
		node.connect("validate_word",self, "_on_validate_word")
	
	$SelectedLettersGrid.connect("validate_word",self,"_on_validate_word")
	$Attack.connect("remove_selected_buttons",self,"_on_remove_selected_buttons")
	$ShuffleButton.connect("remove_selected_buttons",self,"_on_remove_selected_buttons")
	
	# Tutorial Loading and hiding help button on first level
	if int(SavedGames.saveGameDict["maxUnlockedLevel"]) == 1:
		$TutorialNode.visible = true
		$HelpButton.visible = false
		$TutorialNode.find_node("DialogBox").load_dialog()
	else:
		if not Global.isEndlessMode:
			find_node("StageNumber").text = "Stage "+str(Global.level)
			find_node("StageNumberAnimation").play("show_stage")

func _process(delta):
	find_node("ShuffleCount").text = str(SavedGames.saveGameDict["freeShuffleCount"])
	
	# Setting enemy count in endless mode
	if Global.isEndlessMode:
		$EndlessModeEnemyCount.text = "Enemies Killed : %s" % int(enemyCount-1)
	
	if enemyMoveFlag:
		if $EnemyContainer.rect_position.x > MOVING_PIXELS:
			$EnemyContainer.rect_position.x -= delta * SPEED
		else:
			enemyMoveFlag = false
			self.get_node("HideButtons").visible = false
	
	# Toggling power up potion checked
	if isPowerupPotionSet:
		$PowerupPotion.disabled = false
	else:
		$PowerupPotion.disabled = true

func enemy_sprite_dictionary():
	var numberOfEnemies = Global.levelResourceDict[str(Global.level)].size() + 1
	for i in range(1,numberOfEnemies):
		# Loading enemy sprite sheet
		var animationValue = Global.levelResourceDict[str(Global.level)][str(i)]["animation"]
		var eachEnemyScene = load("res://Scenes/Enemy/" + str(animationValue))
		enemySpriteDictionary[str(animationValue)] = eachEnemyScene
		
		# Loading progress sprite images
		var progressAnimValue = Global.levelResourceDict[str(Global.level)][str(i)]["progressSprite"]
		var progressAnim = load("res://Resources/Sprites/Enemy/progress/" + str(progressAnimValue))
		enemySpriteDictionary[str(i)] = progressAnim

func initialize_grid_buttons():
	for i in 15:
		var gridButtonRef = gridButton.instance()
		gridButtonRef.initialize(buttonBaseDamage, "Simple", i)
		$Buttons.add_child(gridButtonRef)

#When validate_word signal is recieved, validate against dictionary.
func _on_validate_word():
	var letters = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
	var selectedLettersGrid : GridContainer = $SelectedLettersGrid
	var stringToValidate = selectedLettersGrid._getSelectedLetters().to_lower()
	
	if "?" in stringToValidate:
		for item in range(0,len(letters)):
			var _string = stringToValidate.replace("?",str(letters[item]))
			if dictionary.get(_string,false) and stringToValidate.length() >= 2:
				$Attack.disabled = false
				get_tree().call_group("animate_selected","animate_buttons",true)
				break
			else:
				$Attack.disabled = true
				get_tree().call_group("animate_selected","animate_buttons",false)
	else:
		var result = dictionary.get(stringToValidate)
		if result != null and stringToValidate.length() >= 2 :
			$Attack.disabled = false
			get_tree().call_group("animate_selected","animate_buttons",true)
		elif result == null or stringToValidate.length() < 2 :
			$Attack.disabled = true
			get_tree().call_group("animate_selected","animate_buttons",false)

func _on_remove_selected_buttons():
	var selectedLettersGrid : GridContainer = self.get_node("SelectedLettersGrid")
	attackWordLength = selectedLettersGrid.get_child_count()
	for n in selectedLettersGrid.get_children():
		selectedLettersGrid.remove_child(n)
		n.queue_free()

func _on_enemy_dead():
	coinsEarned += (enemyCoins * int(SavedGames.saveGameDict["multiplier"]))
	SavedGames.saveGameDict["coins"] += enemyCoins * int(SavedGames.saveGameDict["multiplier"])
	SavedGames.save_game_state()
	Global.show_floating_text(self,"+%s"%str(enemyCoins * int(SavedGames.saveGameDict["multiplier"]) ),"coin", Vector2(0,-100))
	play_coin_sound()
	
	# Setting progressbar value if not endless mode else setting high score
	if not Global.isEndlessMode:
		$ProgressBar.set_value(enemyCount)
		GooglePlay.increment_achievement(GooglePlay.KILL_5_ENEMIES_STORY,1)
		GooglePlay.increment_achievement(GooglePlay.KILL_10_ENEMIES_STORY,1)
		GooglePlay.increment_achievement(GooglePlay.KILL_25_ENEMIES_STORY,1)
	else:
		GooglePlay.increment_achievement(GooglePlay.KILL_50_ENEMIES_ENDLESS,1)
		
		var currentHighScore = SavedGames.saveGameDict["new_values"].get("high_score",0)
		if currentHighScore < enemyCount:
			SavedGames.saveGameDict["new_values"]["high_score"] = enemyCount
		
		#if enemyCount % 5 == 0:
		#	GooglePlay.submit_leaderboard_score(enemyCount)
	
	var numberOfEnemies = Global.levelResourceDict[str(Global.level)].size()
	if enemyCount < numberOfEnemies:
		$EnemyContainer.rect_position.x = enemyContainerOriginalX
		enemyCount += 1
		self.get_node("HideButtons").visible = true
		_create_new_enemy()
	else:
		enemyRef.queue_free()
		
		# Unlocking achievement to end level with full health
		if playerRef.health == playerHealth:
			GooglePlay.unlock_achievement(GooglePlay.COMPLETE_STAGE_FULL_HEALTH)
		
		# Unlocking achievement for completing 10,20,30,50 stages
		if Global.level == 10:
			GooglePlay.unlock_achievement(GooglePlay.COMPLETE_10_STAGES)
		elif Global.level == 20:
			GooglePlay.unlock_achievement(GooglePlay.COMPLETE_20_STAGES)
		elif Global.level == 30:
			GooglePlay.unlock_achievement(GooglePlay.COMPLETE_30_STAGES)
		elif Global.level == 50:
			GooglePlay.unlock_achievement(GooglePlay.COMPLETE_STORY_MODE)
		
		$BackgroundMusic.stop()
		yield(get_tree().create_timer(1), "timeout")
		levelCompleteRef.find_node("MenuPopup").end_level()

func _on_player_dead():
	if Global.isEndlessMode:
		GooglePlay.submit_leaderboard_score(enemyCount)
	
	gameOverRef.game_over()


func _create_new_enemy():
	# Deleting old enemy if available
	if is_instance_valid(enemyRef):
		enemyRef.queue_free()
		$EnemyHealthBar.set_health_value(enemyHealth)
		yield(get_tree().create_timer(1), "timeout")
	
	_set_enemy_params()
	
	#Creating new enemy
	enemyRef = enemyScene.instance()
	enemyRef.connect("enemy_dead",self,"_on_enemy_dead")
	$EnemyContainer.add_child(enemyRef)
	enemyRef.initialize(enemyHealth,enemyAttack,enemyDef,enemyCriticalHitPercent,enemyDodgePercent,enemyAnim)
	
	# Making 5th enemy, boss bigger
	if enemyCount==5 and not Global.isEndlessMode:
		enemyRef.enemySceneRef.scale.y += enemyRef.enemySceneRef.scale.y * 0.2
		enemyRef.enemySceneRef.scale.x += enemyRef.enemySceneRef.scale.x * 0.2
		enemyRef.enemySceneRef.position.x -= 40
	
	$EnemyHealthBar.initialize(enemyHealth,"Enemy")
	
	MOVING_PIXELS = $EnemyContainer.rect_size.x + 52
	enemyContainerOriginalX = $EnemyContainer.rect_position.x 
	
	#Moving animation
	playerRef.walkAnimationFlag = true
	playerRef.start_walk_timer(1)
	$ParallaxBackground.move_background(MOVING_PIXELS,SPEED)
	MOVING_PIXELS = $EnemyContainer.rect_position.x - MOVING_PIXELS
	enemyMoveFlag = true
	

func _set_level_params():
	playerHealth = int(SavedGames.saveGameDict["playerHealth"])
	playerDef = int(SavedGames.saveGameDict["playerDef"])
	buttonBaseDamage = int(SavedGames.saveGameDict["playerAtk"])
	playerCriticalHitPercent = float(SavedGames.saveGameDict["playerCriticalHitPercent"])
	playerDodgePercent = float(SavedGames.saveGameDict["playerDodgePercent"])

func _set_enemy_params():
	var currentEnemyNumber = enemyCount
	if Global.isEndlessMode:
		currentEnemyNumber = enemyCount + SavedGames.saveGameDict["maxUnlockedLevel"]
	
	var enemyStatsDict = Global.levelResourceDict[str(Global.level)][str(currentEnemyNumber)]
	enemyHealth = int(enemyStatsDict["enemyHealth"])
	enemyAttack = int(enemyStatsDict["enemyAttack"])
	enemyDef = int(enemyStatsDict["enemyDef"])
	enemyCriticalHitPercent = float(enemyStatsDict["enemyCriticalHitPercent"])
	enemyDodgePercent = float(enemyStatsDict["enemyDodgePercent"])
	enemyAnim = enemyStatsDict["animation"]
	enemyCoins = int(enemyStatsDict["coins"])
	

func _on_PauseButton_button_down():
	play_button_click_sound()
	pauseRef.find_node("MenuPopup").pause_game()

func _on_EnemyContainer_gui_input(event):
	if event is InputEventMouseButton and not event["pressed"]:
		play_button_click_sound()
		enemyRef.statsDialogueRef.find_node("PlayerStats").pause_game()


func _on_PlayerContainer_gui_input(event):
	if event is InputEventMouseButton and not event["pressed"]:
		play_button_click_sound()
		playerRef.statsDialogueRef.find_node("PlayerStats").pause_game()

func _on_PotionsButton_button_down():
	play_button_click_sound()
	potionsRef.find_node("Potions").toggle_menu()
	potionsRef.find_node("Potions").start()


func _on_PowerupPotion_button_up():
	isPowerupPotionSet = false
	SavedGames.saveGameDict["powerUpPotionCount"] += 1
	SavedGames.save_game_state()
	potionsRef.find_node("Potions").powerUpPotionScene.update_count(SavedGames.saveGameDict["powerUpPotionCount"])


func _on_HelpButton_button_up():
	play_button_click_sound()
	helpRef.toggle_menu()
	helpRef.start()

func _on_FindWordAd_button_up():
	play_button_click_sound()
	hintAdWatchRef.toggle_Popup()

# Handling back button press
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		pauseRef.find_node("MenuPopup").pause_game()


func play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()

func play_background_sound():
	if SavedGames.saveGameDict["musicEnabled"]:
		 $BackgroundMusic.play()
	else:
		$BackgroundMusic.stop()

func play_hit_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$HitSound.play()

func play_die_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$DieSound.play()

func play_attack_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$AttackSound.play()
		
func play_coin_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$CoinsSound.play()

# Admob callbacks
func _on_AdMob_rewarded(_currency, _ammount):
	print("ad reward from play scene")
	
	# Game over options
	if reviveWizardAd:
		reviveWizardAd = false
		gameOverRef.resume_game()
		playerRef.visible = true
		playerRef.health = int(playerHealth * 0.25)
		playerRef.reviveAnimationFlag = true
		Global.show_floating_text(playerRef, "+%s"%playerRef.health,"heal",Vector2(100,0))
		get_node("PlayerHealthBar").set_health_value(playerRef.health)
		get_node("HideButtons").visible = false
		admob.load_rewarded_video()
	
	# Level completed options
	elif doubleCoinsAd:
		doubleCoinsAd = false
		levelCompleteRef.find_node("CoinsEarned").text = "Coins Earned : %s" % (coinsEarned*2)
		levelCompleteRef.find_node("DoubleCoinsVideo").disabled = true
		SavedGames.saveGameDict["coins"] += coinsEarned
		SavedGames.save_game_state()
		play_coin_sound()
		
	# Adding coins from store
	elif storeGetCoinsAd:
		storeGetCoinsAd = false
		var coins = int(sqrt(float(SavedGames.saveGameDict["maxUnlockedLevel"])) * 500)
		SavedGames.saveGameDict["coins"] += coins
		SavedGames.save_game_state()
		play_coin_sound()
		
	# Finding longest word upto 9 letters
	elif findWordAd:
		findWordAd = false
		#hintAdWatchRef.toggle_Popup()
		potionsRef.find_node("Potions").find_longest_word(true)
		admob.load_rewarded_video()



