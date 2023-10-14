extends Control

var dialog = [
	'Congratulations, We have finally defeated all the enemies',
	'Thank you for your help in eradicating all the evil forces from my magical world, now I can happily live in this world',
	'Now try to triump over your peers by defeating as many enemies as possible in Endless mode and topping the leaderboard charts',
	'I wish you Good Luck!!!'
]

var dialog_index = 0
var finished = false

func _process(_delta):
	$"NextButton".visible = finished

func _ready():
	if SavedGames.saveGameDict["musicEnabled"]:
		$BackgroundMusic.play()
	load_dialog()

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
		queue_free()
		Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", self)
	dialog_index += 1


func _on_Tween_tween_completed(object, key):
	finished = true


func _on_NextButton_button_up():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()
	load_dialog()
