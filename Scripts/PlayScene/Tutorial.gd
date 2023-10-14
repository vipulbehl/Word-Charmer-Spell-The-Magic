extends Control

var playSceneRef
var dialog = [
	'Hi, I am your buddy Wizard. Help me eradicate all the evil forces from my magical world.',
	'Use the grid to create a valid word, longer words deal more damage.',
	'Attack button will be enabled as soon as you create a valid word.',
	'You can deselect a letter by clicking on the selected letter.',
	'Use the "Shuffle" button to change the letters of the grid.',
	'Can\'t find a word?? Use the search button to automatically find a word',
	'You can view the Wizard\'s and Enemy\'s stats by clicking on them. Stats can be upgraded from the store.',
	'Lets get started!!!'
]

var dialog_index = 0
var finished = false

func _ready():
	hide_all_animation_buttons()
	playSceneRef = get_parent().get_parent()

func _process(_delta):
	$"next-indicator".visible = finished

func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		get_parent().queue_free()
	dialog_index += 1


func _on_Tween_tween_completed(_object, _key):
	finished = true
	dialog_options()


func _on_nextindicator_button_up():
	playSceneRef.play_button_click_sound()
	hide_all_animation_buttons()
	load_dialog()


func dialog_options():
	hide_all_animation_buttons()
	if dialog_index == 2:
		find_node("GridButton").visible = true
		find_node("ArrowAnimation").play("grid_animation")
	elif dialog_index == 3:
		# Call find longest word here
		playSceneRef.potionsRef.find_node("Potions").find_longest_word(true)
		find_node("AttackButton").visible = true
		find_node("ArrowAnimation").play("attack_animation")
	elif dialog_index == 4:
		find_node("SelectedButton").visible = true
		find_node("ArrowAnimation").play("selected_animation")
	elif dialog_index == 5:
		# Call shuffle button press here
		playSceneRef.find_node("ShuffleButton").simulate_suffle_button_press()
		find_node("ShuffleButton").visible = true
		find_node("ArrowAnimation").play("shuffle_animation")
	# This condition is for find a word button
	elif dialog_index == 6:
		find_node("SearchButton").visible = true
		find_node("ArrowAnimation").play("search_animation")
	elif dialog_index == 7:
		find_node("WizardButton").visible = true
		find_node("ArrowAnimation").play("wizard_animation")

func hide_all_animation_buttons():
	find_node("GridButton").visible = false
	find_node("AttackButton").visible = false
	find_node("SelectedButton").visible = false
	find_node("ShuffleButton").visible = false
	find_node("WizardButton").visible = false
	find_node("SearchButton").visible = false
