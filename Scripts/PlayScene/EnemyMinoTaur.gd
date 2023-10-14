extends KinematicBody2D

signal enemy_dead

var throwable = preload("res://Scenes/Play/ThrowableAttack.tscn")
var statsDialogue = preload("res://Scenes/Play/Stats.tscn")
var statsDialogueRef
var sceneRoot
var enemySceneRef

# Enemy variables
var health setget set_health, get_health
var atk
var def
var criticalHitPercent
var dodgePercent
var maxHealth

# Animation Flags
var attackAnimationFlag = false
var deadAnimationFlag = false
var hurtAnimationFlag = false
var startAttack = false

func initialize(_health, _atk, _def, _enemyCriticalHitPercent, _enemyDodgePercent, _enemyAnim):
	maxHealth = _health
	health = _health
	atk = _atk
	def = _def
	criticalHitPercent = _enemyCriticalHitPercent
	dodgePercent = _enemyDodgePercent
	
	var enemyScene = sceneRoot.enemySpriteDictionary[str(_enemyAnim)]
	enemySceneRef = enemyScene.instance()
	add_child(enemySceneRef)
	enemySceneRef.find_node("AnimationPlayer").connect("animation_finished",self,"_on_animation_finished")
	enemySceneRef.find_node("AnimationPlayer").get_animation("Attack").loop = false
	enemySceneRef.find_node("AnimationPlayer").get_animation("Hurt").loop = false
	enemySceneRef.find_node("AnimationPlayer").get_animation("Die").loop = false
	
	# Loading dialogue box
	statsDialogueRef = statsDialogue.instance()
	statsDialogueRef.find_node("PlayerStats").initialize("Enemy Stats",health, atk, def,criticalHitPercent,dodgePercent, self)
	add_child(statsDialogueRef)


func _ready():
	sceneRoot = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if attackAnimationFlag:
		enemySceneRef.find_node("AnimationPlayer")
		enemySceneRef.find_node("AnimationPlayer").play("Attack")
		sceneRoot.play_attack_sound()
	elif deadAnimationFlag:
		enemySceneRef.find_node("AnimationPlayer").play("Die")
	elif hurtAnimationFlag:
		enemySceneRef.find_node("AnimationPlayer").play("Hurt")
	else:
		enemySceneRef.find_node("AnimationPlayer").play("Idle")
	
	if health > maxHealth:
		health = maxHealth

func enemy_attack():
	attackAnimationFlag = true
	sceneRoot.get_node("HideButtons").visible = false

func _on_animation_finished(_temp):
	enemySceneRef.find_node("AnimationPlayer").stop()
	if attackAnimationFlag:
		attackAnimationFlag = false
		var _damage = atk
		
		_damage = (_damage * _damage) / sceneRoot.playerRef.def
		
		var throwableRef = throwable.instance()
		
		# Partial player skip here, rest on throwableattack in ninjahit
		# No damage tile initialize here
		# Health decrease tile
		var _values = _get_attack_type()
		var attackType = _values[0]
		var specialAttackDict = _values[1]

		if attackType == "powerAttack":
			_damage += specialAttackDict["powerAttack"][1]
		elif attackType == "hpHeal":
			Global.show_floating_text(self,"+ %s HP"%specialAttackDict["hpHeal"][1], "heal", Vector2(-100,0))
			health += specialAttackDict["hpHeal"][1]
			sceneRoot.get_node("EnemyHealthBar").set_health_value(health)
		elif attackType == "playerSkip":
			throwableRef.playerTurnSkip = true
		elif attackType == "noDamageTile":
			sceneRoot.isNoDamageTile = true
		elif attackType == "decreaseHealthTile":
			sceneRoot.isDecreaseHealthTile = true
		
		var animationCountEndless = sceneRoot.enemyCount
		if Global.isEndlessMode:
			animationCountEndless += SavedGames.saveGameDict["maxUnlockedLevel"]
		
		var throwableAnimationName = str(Global.levelResourceDict[str(Global.level)][str(animationCountEndless)]["animation"]).to_lower().left(8).replace(".","")
		throwableRef.initialize(throwableAnimationName,-1,int(_damage))
		sceneRoot.add_child(throwableRef)
		throwableRef.position = $Position2D.global_position
	
	if deadAnimationFlag:
		emit_signal("enemy_dead")
		enemySceneRef.queue_free()
		deadAnimationFlag = false
	if hurtAnimationFlag:
		hurtAnimationFlag = false
		if startAttack:
			startAttack = false
			attackAnimationFlag = true

func dead_animation():
	deadAnimationFlag = true

func set_health(newHealth):
	health = newHealth
	
func get_health():
	return health


func _get_attack_type():
	var _specialAttackDict = Global.levelResourceDict[str(Global.level)][str(sceneRoot.enemyCount)]["specialAttack"]
	var simpleAttack = _specialAttackDict["simple"][0]
	var powerAttack = simpleAttack + _specialAttackDict["powerAttack"][0]
	var playerSkip = powerAttack + _specialAttackDict["playerSkip"][0]
	var hpHeal = playerSkip + _specialAttackDict["hpHeal"][0]
	var noDamageTile = hpHeal + _specialAttackDict["noDamageTile"][0]
	var decreaseHealthTile = noDamageTile + _specialAttackDict["decreaseHealthTile"][0]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_integer = rng.randf_range(0.0,100.0)
	if random_integer <= simpleAttack and _specialAttackDict["simple"][0] != 0:
		return ["simple", _specialAttackDict]
	elif random_integer <= powerAttack and _specialAttackDict["powerAttack"][0] != 0:
		return ["powerAttack", _specialAttackDict]
	elif random_integer <= playerSkip and _specialAttackDict["playerSkip"][0] != 0:
		return ["playerSkip", _specialAttackDict]
	elif random_integer <= hpHeal and _specialAttackDict["hpHeal"][0] != 0:
		return ["hpHeal", _specialAttackDict]
	elif random_integer <= noDamageTile and _specialAttackDict["noDamageTile"][0] != 0:
		return ["noDamageTile", _specialAttackDict]
	elif random_integer <= decreaseHealthTile and _specialAttackDict["decreaseHealthTile"][0] != 0:
		return ["decreaseHealthTile", _specialAttackDict]
	else:
		return ["simple", _specialAttackDict]
