extends Node2D
var rewardCoins = 1000

var noCoinsScene = preload("res://Scenes/Level/NoCoinsScene.tscn")
var noCoinsRef

var toggleMenu = false

func _ready():
	find_node("PotionScreenAnimation").play("appear")
	
	noCoinsRef = noCoinsScene.instance()
	noCoinsRef.connect("get_coins",self,"_on_get_coins")
	add_child(noCoinsRef)


func _process(_delta):
	find_node("Coins").text = str(SavedGames.saveGameDict["coins"])

func _hide_all_windows():
	find_node("PotionsScreen").visible = false
	find_node("WizardScreen").visible = false
	find_node("UpgradeScreen").visible = false
	find_node("CoinsScreen").visible = false

func toggle_menu():
	toggleMenu = not toggleMenu
	find_node("StoreMenu").visible = toggleMenu
	find_node("BackgroundTint").visible = toggleMenu
	#if get_parent().get("storeGetCoinsAd") != null:
	#	get_tree().paused = toggleMenu


func _on_PotionsHeading_button_up():
	_play_button_click_sound()
	_hide_all_windows()
	find_node("PotionScreenAnimation").play("appear")
	find_node("PotionsScreen").start()


func _on_WizardHeading_button_up():
	_play_button_click_sound()
	_hide_all_windows()
	find_node("WizardScreenAnimation").play("appear")
	find_node("WizardScreen").start()


func _on_UpgradeHeading_button_up():
	_play_button_click_sound()
	_hide_all_windows()
	find_node("UpgradeScreenAnimation").play("appear")
	find_node("UpgradeScreen").start()


func _on_CoinsHeading_button_up():
	_play_button_click_sound()
	_hide_all_windows()
	find_node("CoinsScreenAnimation").play("appear")
	find_node("CoinsScreen").start()


func _on_BackButton_button_up():
	_play_button_click_sound()
	toggle_menu()


func _on_get_coins():
	_play_button_click_sound()
	_hide_all_windows()
	find_node("CoinsScreenAnimation").play("appear")
	find_node("CoinsScreen").start()

func _play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$CanvasLayer/StoreMenu/CoinsScreen/NormalButtonClick.play()
		
func play_coins_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("CoinsSound").play()
