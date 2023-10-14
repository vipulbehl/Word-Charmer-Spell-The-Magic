extends Node

#Global variables
var isEndlessMode = false
var level
var levelResourceDict
var upgradeDict
var damageText = preload("res://Scenes/Play/DamageFloatingText.tscn")
var dictionary = {}
var isLevelScene = false
var rateButtonShown = false
var shareButtonShown = false
var loadGameShown = false

var _populateDictionaryThread
var _levelResourceLoaded = false
var _upgradeResourceLoaded = false
var _dictionaryLoaded = false

func _ready():
	pass

export var max_load_time = 10000

func goto_scene(path, current_scene):
	current_scene.queue_free()
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("Resource loader is unable to load the scene")
		return
	
	var loading_bar = load("res://Scenes/LoadingBar.tscn").instance()
	get_tree().get_root().call_deferred('add_child',loading_bar)
	
	var start_time = OS.get_ticks_msec()
	while OS.get_ticks_msec() - start_time < max_load_time:
		var status = loader.poll()
		if status == ERR_FILE_EOF:
			#Loading is complete
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred('add_child',resource.instance())
			
			loading_bar.queue_free()
			break
		elif status == OK:
			#Still loading
			var progress = float(loader.get_stage())/loader.get_stage_count()
			loading_bar.find_node("ProgressBar").value = progress * 100
			loading_bar.find_node("Label1").text = str(int(progress*100)) + "%"
		else:
			print("Error while loading the scene")
			break
		yield(get_tree(),"idle_frame")

func show_floating_text(_obj, _string, _type, _position=null):
	var damageTextObj = damageText.instance()
	if _position == null:
		_position = Vector2(100,100)#get_viewport().size/2 - Vector2(100,200)
	damageTextObj.set_position(_position)
	_obj.add_child(damageTextObj)
	damageTextObj.find_node("Label").show_value(_string,_type)

func set_level_resource_dict():
	if not _levelResourceLoaded:
		var file = File.new()
		file.open("res://Data/EnemyData.txt", file.READ)
		levelResourceDict = JSON.parse(file.get_as_text()).result
		file.close()
		_levelResourceLoaded = true

func set_upgrade_dict():
	if not _upgradeResourceLoaded:
		var file = File.new()
		file.open("res://Data/UpgradesData.txt", file.READ)
		upgradeDict = JSON.parse(file.get_as_text()).result
		file.close()
		_upgradeResourceLoaded = true
		

func populate_dictionary():
	if not _dictionaryLoaded:
		var file = File.new()
		file.open("res://Data/Dictionary.txt", file.READ)
		var counter = 0
		#and counter < 174494
		while !file.eof_reached():
			var word = file.get_csv_line()
			Global.dictionary[str(word[0]).to_lower()] = word[1]
			counter = counter + 1
		file.close()
		_dictionaryLoaded = true
