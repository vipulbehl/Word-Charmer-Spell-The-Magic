extends TextureButton

var throwable = preload("res://Scenes/Play/ThrowableAttack.tscn")

signal remove_selected_buttons

var shuffleAnimation = false

func _ready():
	$ShuffleSprite.connect("animation_finished",self,"_on_animation_finished")

func _on_ShuffleButton_pressed(_longest_word_shuffle=false):
	$ShuffleSprite.play("shuffle")
	var sceneRoot = self.get_parent()
	var buttons = sceneRoot.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	
	# Disable attack button
	sceneRoot.get_node("Attack").disabled = true
	sceneRoot.get_node("HideButtons").visible = true
	
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		centerContainer.initialize(SavedGames.saveGameDict["playerAtk"], centerContainer.special_effect, centerContainer.pos)
		centerContainer.find_node("Label").add_color_override("font_color", Color(0,0,0,1))
		centerContainer.find_node("ButtonRarity").visible = true
		
		# Clear the Text Field
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		textureButton.disabled = false
		
		# Clear the SelectedLetters Grid
		emit_signal("remove_selected_buttons")
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	# Logic to shuffle the grid from longest word finder
	if _longest_word_shuffle:
		sceneRoot.get_node("HideButtons").visible = false
		return
	
	# Enemy Attacks if player doesn't have enough shuffle potions
	if SavedGames.saveGameDict["freeShuffleCount"] < 1:
		var enemyMinotaurRef = sceneRoot.get_node("EnemyContainer").get_child(0)
		enemyMinotaurRef.attackAnimationFlag = true
	else :
		SavedGames.saveGameDict["freeShuffleCount"] -= 1
		SavedGames.save_game_state()
		sceneRoot.get_node("HideButtons").visible = false
	
func simulate_suffle_button_press():
	_on_ShuffleButton_pressed(true)


func _on_animation_finished():
	$ShuffleSprite.play("default")
