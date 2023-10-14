extends Node

var savePath = "user://save.dat"

var saveGameDict = {
	# Game version, usefull for upgrades
	"version" : 1,
	"new_values" : {},
	
	"rated" : false,
	"shared" : false,
	"facebookShared" : false,
	"twitterShared" : false,
	"lastDailyRewardDate" : 1627391355,
	
	# Game params
	"musicEnabled" : true,
	"soundEnabled" : true,
	"coins" : 0,
	"maxUnlockedLevel" : 1,
	"multiplier" : 1,
	
	# Player params
	"playerHealth" : 200,
	"playerAtk" : 10,
	"playerDef" : 10,
	"playerCriticalHitPercent" : 1,
	"playerDodgePercent" : 1,
	
	# Potions
	"healingPotionCount" : 0,
	"powerUpPotionCount" : 0,
	"powerTilePotionCount" : 0,
	"longestWordFinderCount" : 0,
	"freeShuffleCount" : 5,
	"purifyPotionCount" : 0,
	
	# Potions Upgrade
	"healingPotionHP" : 50,
	"powerUpPotionHP" : 50,
	
	# Tile upgardes
	"powerUpTileHP" : 20,
	"freezeTileHP" : 10,
	"healTileHP" : 20,
	"burnTilePercent" : 20,
	"paralyzeTilePercentage" : 20,
	
	# Reward Chest
	"firstChestClaimed" : false,
	"secondChestClaimed" : false,
	"thirdChestClaimed" : false,
	"fourthChestClaimed" : false,
	"fifthChestClaimed" : false,
	"sixthChestClaimed" : false
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var _load_staus_check = load_game_state()


func save_game_state():
	var file = File.new()
	var error = file.open_encrypted_with_pass(savePath, File.WRITE, "wordCharmerMadeWithGodot1")
	if error == OK:
		file.store_var(saveGameDict)
		file.close()
		GooglePlay.save_game()
	else:
		print("Issue while opening the save game file")
	
func load_game_state():
	var file = File.new()
	if file.file_exists(savePath):
		var error = file.open_encrypted_with_pass(savePath, File.READ, "wordCharmerMadeWithGodot1")
		if error == OK:
			saveGameDict = file.get_var()
			file.close()
			return true
		else:
			print("Error while opening the save game file")
			return false
	else:
		print("Save file doesn't exist, trying to load from Google Play Games Services")
		#GooglePlay.sync_google_play = true
		return false
