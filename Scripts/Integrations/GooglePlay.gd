extends Node

var play_games_services = null
var sync_google_play = false
var save_game_name = "WordCharmerSavedGames"

const LEADERBOARD_ID = ""

# Achievements
const KILL_5_ENEMIES_STORY = ""
const KILL_10_ENEMIES_STORY = ""
const KILL_25_ENEMIES_STORY = ""
const KILL_50_ENEMIES_ENDLESS = ""
const COMPLETE_STAGE_FULL_HEALTH = ""
const COMPLETE_10_STAGES = ""
const COMPLETE_20_STAGES = ""
const COMPLETE_30_STAGES = ""
const COMPLETE_STORY_MODE = ""


func _ready():
	save_game_name = save_game_name + str(SavedGames.saveGameDict.get("version","1"))
	_init()
	_connect_signals()
	#sign_in()

func sign_in() -> void:
	if play_games_services:
		play_games_services.signIn()

func sign_out() -> void:
	if play_games_services:
		play_games_services.signOut()


func check_if_signed_in() -> void:
	if play_games_services:
		var is_signed_in: bool = play_games_services.isSignedIn()
		print("Signed in: %s"%is_signed_in)

func log_in_from_buttons():
	if play_games_services:
		if play_games_services.isSignedIn():
			print("already signed in")
		else:
			sign_in()
	else:
		print("Google play services are not available")

func save_game() -> void:
	if play_games_services:
		play_games_services.saveSnapshot(save_game_name, to_json(SavedGames.saveGameDict), "This is a saved game file for Word Charmer game")


func load_saved_games() -> void:
	if play_games_services:
		play_games_services.loadSnapshot(save_game_name)
		#play_games_services.showSavedGames("WordCharmerSavedGames", true, true, 5)

func _init() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")
		#play_games_services.init(true)
		#play_games_services.initWithSavedGames(true, "WordCharmerSavedGames")
		play_games_services.initWithSavedGames(true, save_game_name,false, false, "")
		

func _connect_signals() -> void:
	if play_games_services:
		play_games_services.connect("_on_sign_in_success",self, "_on_sign_in_success")
		play_games_services.connect("_on_sign_in_failed",self, "_on_sign_in_failed")
		play_games_services.connect("_on_sign_out_success", self, "_on_sign_out_success")
		play_games_services.connect("_on_sign_out_failed", self, "_on_sign_out_failed")
		
		play_games_services.connect("_on_game_saved_success", self, "_on_game_saved_success")
		play_games_services.connect("_on_game_saved_fail", self, "_on_game_saved_fail")
		play_games_services.connect("_on_game_load_success", self, "_on_game_load_success")
		play_games_services.connect("_on_game_load_fail", self, "_on_game_load_fail")
		play_games_services.connect("_on_create_new_snapshot", self, "_on_create_new_snapshot")
		
		# Leaderbord connections
		play_games_services.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted")
		play_games_services.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed")
		
		# Achievement connections
		play_games_services.connect("_on_achievement_unlocked", self, "_on_achievement_unlocked")
		play_games_services.connect("_on_achievement_unlocking_failed", self, "_on_achievement_unlocking_failed")
		play_games_services.connect("_on_achievement_incremented", self, "_on_achievement_incremented")
		play_games_services.connect("_on_achievement_incrementing_failed", self, "_on_achievement_incrementing_failed")
		play_games_services.connect("_on_achievement_steps_set", self, "_on_achievement_steps_set")
		play_games_services.connect("_on_achievement_steps_setting_failed", self, "_on_achievement_steps_setting_failed")

# Sign in callbacks
func _on_sign_in_success(account_id : String):
	print("Successful sign in %s" % account_id)
	if sync_google_play:
		print("Calling google play load game function")
		load_saved_games()
		sync_google_play = false

func _on_sign_in_failed(error_code : int):
	print("Failed to sign in with error code %s" % error_code)
	
func _on_sign_out_success() -> void:
	print("Sign out success")

func _on_sign_out_failed() -> void:
	print("Sign out failed")

# Save games callback
func _on_game_saved_success():
	print("Game saved success")

func _on_game_saved_fail():
	print("Game saved fail")

func _on_game_load_success(data):
	var _game_data = parse_json(data)
	print("Printing game data")
	print(_game_data)
	print(_game_data["version"])
	print(_game_data["coins"])
	
	assert(typeof(_game_data) == TYPE_DICTIONARY, str("Unable to parse : ", _game_data))
	assert(typeof(_game_data["new_values"]) == TYPE_DICTIONARY, str("Unable to parse : ", _game_data))
	
	# Checking if there is any null value in the retrieved dictionary
	#if _game_data["version"] == null or _game_data["version"] == "Null" or _game_data["coins"] == null or _game_data["coins"] == "Null":
	#	return
	
	# Overwriting the daily reward time, was causing issues, should be integer
	_game_data["lastDailyRewardDate"] = 1627391355
	
	SavedGames.saveGameDict = _game_data
	SavedGames.save_game_state()
	print("Game loaded successfully")

func _on_game_load_fail():
	print("Game load fail")

func _on_create_new_snapshot(name:String):
	print("Create new snapshot %s"%name)

# Leaderboards callbacks
func _on_leaderboard_score_submitted(leaderboard_id: String) -> void:
	print("LeaderBoard %s, score submitted"%leaderboard_id)

func _on_leaderboard_score_submitting_failed(leaderboard_id: String) -> void:
	print("LeaderBoard %s, score submitting failed"%leaderboard_id)


# Achievement callbacks
func _on_achievement_unlocked(achievement: String) -> void:
	print("Achievement %s unlocked"%achievement)

func _on_achievement_unlocking_failed(achievement: String) -> void:
	print("Achievement %s unlocking failed "%achievement)
	
func _on_achievement_incremented(achievement: String) -> void:
	print("Achievement %s incremented"%achievement)

func _on_achievement_incrementing_failed(achievement: String) -> void:
	print("Achievement %s incrementing failed"%achievement)

func _on_achievement_steps_set(achievement: String) -> void:
	print("Achievement %s steps set"%achievement)

func _on_achievement_steps_setting_failed(achievement: String) -> void:
	print("Achievement %s steps setting failed"%achievement)

# Leaderboards methods
func show_leaderboard() -> void:
	if play_games_services:
		play_games_services.showLeaderBoard(LEADERBOARD_ID) 


func show_all_leaderboards() -> void:
	if play_games_services:
		play_games_services.showAllLeaderBoards()


func submit_leaderboard_score(score) -> void:
	if play_games_services:
		play_games_services.submitLeaderBoardScore(LEADERBOARD_ID, score) 

# Achievement methods
func unlock_achievement(_unlock_achievement) -> void:
	if play_games_services:
		play_games_services.unlockAchievement(_unlock_achievement)

func increment_achievement(_increment_achievement,step) -> void:
	if play_games_services:
		play_games_services.incrementAchievement(_increment_achievement, step) 



func show_achievements() -> void:
	if play_games_services:
		play_games_services.showAchievements()
