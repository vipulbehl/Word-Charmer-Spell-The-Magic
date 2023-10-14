extends Node2D

var playScene
var visibleVal = false

func _ready():
	playScene = get_parent()


func toggle_Popup():
	visibleVal = not visibleVal
	find_node("AdWatchWindow").visible = visibleVal
	find_node("BackgroundTint").visible = visibleVal


func _on_WatchAd_button_up():
	playScene.play_button_click_sound()
	
	if playScene.admob.is_rewarded_video_loaded():
		playScene.admob.show_rewarded_video()
		playScene.findWordAd = true
	else:
		var currentTime = OS.get_ticks_msec()
		
		if currentTime - playScene.lastAdRequestTime > 60000:
			playScene.admob.load_rewarded_video()
			playScene.lastAdRequestTime = OS.get_ticks_msec()
			print("new load ad requested")
		else:
			print("no new ad requested")
		playScene.adNotLoadedRef.toggle()
	
	toggle_Popup()



func _on_CloseButton_button_up():
	playScene.play_button_click_sound()
	toggle_Popup()
