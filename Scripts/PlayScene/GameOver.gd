extends Node2D

var storeScene = preload("res://Scenes/Level/Store.tscn")
var storeRef
var playScene


func _ready():
	playScene = get_parent()
	storeRef = storeScene.instance()
	add_child(storeRef)

func game_over():
	yield(get_tree().create_timer(0.5), "timeout")
	storeRef.find_node("PotionsScreen").update_potions_count()
	storeRef.find_node("PotionsScreen").start()
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("GameOverSound").play()
	find_node("GameOverAnimation").play("game_over")
	
	find_node("BackgroundTint").visible = true
	#get_tree().paused = true
	find_node("CoinsEarned").text = "Coins Earned : %s"%str(playScene.coinsEarned)
	find_node("CoinsMultiplier").text = "Coins Multiplier : %s"%str(SavedGames.saveGameDict["multiplier"])
	

func resume_game():
	find_node("MenuPopup").visible = false
	find_node("BackgroundTint").visible = false
	#get_tree().paused = false

func _on_HomeButton_button_up():
	playScene.play_button_click_sound()
	resume_game()
	Global.isLevelScene = true
	Global.goto_scene("res://Scenes/HomeScene/HomeScene.tscn", playScene)


func _on_ReplayButton_button_up():
	playScene.play_button_click_sound()
	resume_game()
	Global.goto_scene("res://Scenes/Play/IntermediateScene.tscn", playScene)


func _on_ShopButton_button_up():
	playScene.play_button_click_sound()
	storeRef.toggle_menu()


func _on_ReviveWizard_button_up():
	playScene.play_button_click_sound()
	
	#Updating all potions count 
	playScene.potionsRef.find_node("Potions").update_all_counts()
	
	if playScene.admob.is_rewarded_video_loaded():
		playScene.admob.show_rewarded_video()
		playScene.reviveWizardAd = true
	else:
		#playScene.admob.load_rewarded_video()
		playScene.adNotLoadedRef.toggle()
	
