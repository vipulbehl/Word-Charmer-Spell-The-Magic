extends Node2D

var toggleMenu = false

func _ready():
	pass

func give_reward():
	var amount = int(sqrt(float(SavedGames.saveGameDict["maxUnlockedLevel"])) * 1000)
	find_node("Label2").text = str(amount)
	
	toggle_menu()
	
	if SavedGames.saveGameDict["soundEnabled"]:
		find_node("ChestUnlockSound").play()
	
	SavedGames.saveGameDict["coins"] += amount
	SavedGames.saveGameDict["lastDailyRewardDate"] = OS.get_unix_time()
	SavedGames.save_game_state()
	
	# Commenting out the code to send notifications, since it was crashing after upgrading godot to 3.5.2
	# If you need this feature the future upgrade to a different library

	#if Engine.has_singleton("LocalNotification"):
	#	var notif = Engine.get_singleton("LocalNotification")
	#	notif.showLocalNotification("Collect your daily reward and resume your quest","Daily Reward Unlocked",86400,1)

func toggle_menu():
	toggleMenu = not toggleMenu
	find_node("Control").visible = toggleMenu
	find_node("ColorRect").visible = toggleMenu

func _on_TextureButton_button_up():
	toggle_menu()
