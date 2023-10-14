extends KinematicBody2D

signal player_dead

var throwable = preload("res://Scenes/Play/ThrowableAttack.tscn")
var statsDialogue = preload("res://Scenes/Play/Stats.tscn")
var statsDialogueRef
var sceneRoot

var _damage

# Player parameters
var maxHealth
var health setget set_health, get_health
var def
var criticalHitPercent
var dodgePercent

# Animation Flags
var attackAnimationFlag = false
var deadAnimationFlag = false
var hurtAnimationFlag = false
var walkAnimationFlag = false
var reviveAnimationFlag = false

func initialize(_health, _attack, _def, _playerCriticalHitPercent, _playerDodgePercent):
	maxHealth = _health
	health = _health
	def = _def
	criticalHitPercent = _playerCriticalHitPercent
	dodgePercent = _playerDodgePercent
	
	# Loading dialogue box
	statsDialogueRef = statsDialogue.instance()
	statsDialogueRef.find_node("PlayerStats").initialize("Wizard Stats", health, _attack, def, criticalHitPercent, dodgePercent, self)
	add_child(statsDialogueRef)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	sceneRoot = get_parent().get_parent()
	sceneRoot.get_node("Attack").connect("player_attack",self,"_on_player_attack")
	
	$AnimatedSprite.find_node("AnimationPlayer").get_animation("Attack").loop = false
	$AnimatedSprite.find_node("AnimationPlayer").get_animation("Hurt").loop = false
	$AnimatedSprite.find_node("AnimationPlayer").get_animation("Die").loop = false
	
	$AnimatedSprite.find_node("AnimationPlayer").connect("animation_finished",self,"_on_animation_finished")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	if attackAnimationFlag:
		$AnimatedSprite.find_node("AnimationPlayer").play("Attack")
		sceneRoot.play_attack_sound()
	elif deadAnimationFlag:
		$AnimatedSprite.find_node("AnimationPlayer").play("Die")
	elif hurtAnimationFlag:
		$AnimatedSprite.find_node("AnimationPlayer").play("Hurt")
	elif walkAnimationFlag:
		$AnimatedSprite.find_node("AnimationPlayer").play("Run")
	elif reviveAnimationFlag:
		$AnimatedSprite.find_node("AnimationPlayer").play_backwards("Die")
	else:
		$AnimatedSprite.find_node("AnimationPlayer").play("Idle")

	if health > maxHealth:
		health = maxHealth

func _on_player_attack(damage):
	attackAnimationFlag = true
	_damage = damage

func _on_animation_finished(_animation_name):
	if attackAnimationFlag:
		attackAnimationFlag = false
		
		var _throw_animation = _find_throwable_animation()
		# Setting up throwable Object (all after attack options are set there)
		var throwableRef = throwable.instance()
		throwableRef.initialize(str(_throw_animation),1,int(_damage))
		sceneRoot.add_child(throwableRef)
		throwableRef.position = $Position2D.global_position
		
	if deadAnimationFlag:
		deadAnimationFlag = false
		self.visible = false
		emit_signal("player_dead")
	if hurtAnimationFlag:
		hurtAnimationFlag = false
	if reviveAnimationFlag:
		reviveAnimationFlag = false

func dead_animation():
	deadAnimationFlag = true

func set_health(newHealth):
	health = newHealth
	
func get_health():
	return health


func _find_throwable_animation():
	var _special_attacks = {}
	var buttons = sceneRoot.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		
		if textureButton.disabled and centerContainer.special_effect != "Simple":
			_special_attacks[centerContainer.special_effect] = 1
	if _special_attacks.get("Paralyse", false):
		return "Paralyse"
	elif _special_attacks.get("Burn", false):
		return "Burn"
	elif _special_attacks.get("Freeze", false):
		return "Freeze"
	elif _special_attacks.get("Heal", false):
		return "Heal"
	elif _special_attacks.get("Powerup", false):
		return "Powerup"
	elif _special_attacks.get("QuestionMark", false):
		return "QuestionMark"
	else:
		return "fireball"

func start_walk_timer(_timeout=2):
	$WalkTimer.start(_timeout)

func _on_WalkTimer_timeout():
	walkAnimationFlag = false
	$WalkTimer.stop()
