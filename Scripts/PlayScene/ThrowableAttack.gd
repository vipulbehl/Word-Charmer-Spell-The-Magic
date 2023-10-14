extends Area2D

const SPEED = 900

var velocity = Vector2()
var throwableType
var direction
var damage
var playerTurnSkip = false

func _ready():
	pass
	
func initialize(_throwableType, _direction, _damage):
	direction = _direction
	throwableType = _throwableType
	damage = _damage
	
	if direction == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play(throwableType)


# When the throwable will collide with either player or enemy
func _on_ThrowableAttack_body_entered(spriteObj):
	self.visible = false
	
	var playSceneObj = spriteObj.get_parent().get_parent()
	
	# Setting the turn variable
	if playSceneObj.turn:
		playSceneObj.turn = false
	else:
		playSceneObj.turn = true
	
	if spriteObj.get_name() == "Ninja":
		#print("Ninja Hit")
		if not _dodge(spriteObj, "Ninja"):
			_critical_hit(playSceneObj.enemyRef, "Ninja", spriteObj)
			_hit(spriteObj,"Ninja")
			playSceneObj.get_node("PlayerHealthBar").set_health_value(spriteObj.health)
			if dead_action(spriteObj,playSceneObj):
				queue_free()
				return
		else:
			# Attack is dodged
			playerTurnSkip = false
		
		if playerTurnSkip:
			Global.show_floating_text(spriteObj,"Frozen","frozen",Vector2(150,60))
			playerTurnSkip = false
			yield(get_tree().create_timer(1.0), "timeout")
			playSceneObj.enemyRef.attackAnimationFlag = true
		else:
			replace_grid_used_buttons(playSceneObj)
			_add_enemy_tiles(playSceneObj)
			playSceneObj.get_node("HideButtons").visible = false
			playSceneObj.turn = true
	
	elif "EnemyMinotaur" in spriteObj.get_name():
		#print("Enemy Hit")
		if not _dodge(spriteObj, "Enemy"):
			_enemy_burn(spriteObj, playSceneObj)
			_critical_hit(playSceneObj.playerRef, "Enemy", spriteObj)
			_hit(spriteObj,"Enemy")
			_enemy_paralyze(spriteObj, playSceneObj)
			playSceneObj.get_node("EnemyHealthBar").set_health_value(spriteObj.health)
			if dead_action(spriteObj,playSceneObj):
				queue_free()
				return
			
			# Enemy Freezed action
			if playSceneObj.isEnemyFreeze:
				playSceneObj.isEnemyFreeze = false
				Global.show_floating_text(spriteObj,"Frozen","frozen", Vector2(-150,60))
				replace_grid_used_buttons(playSceneObj)
				playSceneObj.get_node("HideButtons").visible = false
				
				# Deleting the object as it is no longer required
				yield(get_tree().create_timer(1.0), "timeout")
				queue_free()
				return
			
			spriteObj.startAttack = true
		else:
			playSceneObj.isEnemyBurn = false
			playSceneObj.isEnemyFreeze = false
			playSceneObj.isEnemyParalyze = false
			spriteObj.attackAnimationFlag = true
	
	# Deleting the throwable object
	queue_free()

func _hit(_spriteObj, _type):
	_spriteObj.get_parent().get_parent().play_hit_sound()
	var position = Vector2(0,0)
	if _type == "Ninja":
		position = Vector2(100,0)
	Global.show_floating_text(_spriteObj,"-"+str(int(damage)),"damage",position)
	_spriteObj.hurtAnimationFlag = true
	_spriteObj.health -= int(damage)

func _critical_hit(_spriteObj, _type, _objHit):
	var position = Vector2(-150,30)
	if _type == "Ninja":
		position = Vector2(150,30)
	var _criticalHitPercent = _spriteObj.criticalHitPercent
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_integer = rng.randf_range(0.0,100.0)
	if random_integer <= _criticalHitPercent:
		damage *= 2
		Global.show_floating_text(_objHit,"Critical Hit", "bleed", position)

func _enemy_burn(_spriteObj, _playSceneObj):
	if _playSceneObj.isEnemyBurn:
		Global.show_floating_text(_spriteObj,"Burned","burn",Vector2(-150,-30))
		damage += (SavedGames.saveGameDict["burnTilePercent"] * _spriteObj.health)/100
		_playSceneObj.isEnemyBurn = false

func _enemy_paralyze(_enemyRef, _playSceneOjb):
	if _playSceneOjb.isEnemyParalyze:
		_enemyRef.atk -= int((_enemyRef.atk*SavedGames.saveGameDict["paralyzeTilePercentage"])/100)
		_enemyRef.def -= int((_enemyRef.def*SavedGames.saveGameDict["paralyzeTilePercentage"])/100)
		_enemyRef.criticalHitPercent -= float((_enemyRef.criticalHitPercent*SavedGames.saveGameDict["paralyzeTilePercentage"])/100)
		_enemyRef.dodgePercent -= float((_enemyRef.dodgePercent*SavedGames.saveGameDict["paralyzeTilePercentage"])/100)
		
		_enemyRef.statsDialogueRef.find_node("DefenseVal").text = str(_enemyRef.def)
		_enemyRef.statsDialogueRef.find_node("AttackVal").text = str(_enemyRef.atk)
		_enemyRef.statsDialogueRef.find_node("CriticalHitVal").text = str(_enemyRef.criticalHitPercent)
		_enemyRef.statsDialogueRef.find_node("DodgeVal").text = str(_enemyRef.dodgePercent)
		Global.show_floating_text(_enemyRef,"Paralysed\nStats -%s%%"%SavedGames.saveGameDict["paralyzeTilePercentage"],"paralyze",Vector2(-150,120))
		_playSceneOjb.isEnemyParalyze = false


func dead_action(spriteObj, playSceneObj):
	if spriteObj.health <=0:
		playSceneObj.play_die_sound()
		spriteObj.dead_animation()
		playSceneObj.get_node("HideButtons").visible = true
		playSceneObj.isEnemyFreeze = false
		playSceneObj.isEnemyBurn = false
		playSceneObj.isEnemyParalyze = false
		replace_grid_used_buttons(playSceneObj)
		return true
	else:
		return false

func replace_grid_used_buttons(playSceneObj):
	# Finding out power tile
	var tileType = _get_tile_type(playSceneObj.attackWordLength, playSceneObj)
	var buttons = playSceneObj.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		
		if textureButton.disabled:
			textureButton.disabled = false
			centerContainer.initialize(playSceneObj.buttonBaseDamage, tileType, centerContainer.pos)
			# Making tile type as simple so that only 1 power up tile appears
			tileType = "Simple"
			centerContainer.find_node("Label").add_color_override("font_color", Color(0,0,0,1))
			centerContainer.find_node("ButtonRarity").visible = true

func _add_enemy_tiles(_playSceneObj):
	var _specialAttackDict = Global.levelResourceDict[str(Global.level)][str(_playSceneObj.enemyCount)]["specialAttack"]
	if _playSceneObj.isNoDamageTile:
		_playSceneObj.isNoDamageTile = false
		_enemy_tile(_playSceneObj, "noDamageTile",_specialAttackDict["noDamageTile"][1])
	
	if _playSceneObj.isDecreaseHealthTile:
		_playSceneObj.isDecreaseHealthTile = false
		_enemy_tile(_playSceneObj, "decreaseHealthTile", _specialAttackDict["decreaseHealthTile"][1])


func _enemy_tile(_playSceneObj, _attackType, _count):
	for _i in range(0,_count):
		var buttons = _playSceneObj.get_node("Buttons")
		var buttonsControlCount = buttons.get_child_count()
		for iter in buttonsControlCount:
			var centerContainer = buttons.get_child(iter)
			if centerContainer.special_effect == "Simple":
				centerContainer.initialize(_playSceneObj.buttonBaseDamage, str(_attackType), centerContainer.pos)
				#Global.show_floating_text(_playSceneObj,str(_attackType)+" Tile Added","")
				break

func _get_tile_type(_wordLength, _playSceneObj):
	var _maxUnlockedLevel = SavedGames.saveGameDict["maxUnlockedLevel"]
	
	if _wordLength > 8 and _maxUnlockedLevel >= 7:
		return "Paralyse"
	elif _wordLength > 7 and _maxUnlockedLevel >= 6:
		return "Burn"
	elif _wordLength > 6 and _maxUnlockedLevel >= 5:
		return "Freeze"
	elif _wordLength > 5 and _maxUnlockedLevel >= 4:
		return "Heal"
	elif _wordLength > 4 and _maxUnlockedLevel >= 3:
		return "Powerup"
	elif _wordLength > 3 and _maxUnlockedLevel >=2:
		# Condition to ensure that we don't get 2 question mark tiles at once
		var buttons = _playSceneObj.get_node("Buttons")
		var buttonsControlCount = buttons.get_child_count()
		for iter in buttonsControlCount:
			var centerContainer = buttons.get_child(iter)
			var textureButton : TextureButton = centerContainer.find_node("TextureButton")
			if not textureButton.disabled and centerContainer.find_node("Label").text=="?":
				return "Simple"
		return "QuestionMark"
	else:
		return "Simple"
	

func _dodge(_spriteObj, _objType):
	var position
	if _objType == "Ninja":
		position = Vector2(150,0)
	else:
		position = Vector2(-150,0)
	var _dodgePercent = _spriteObj.dodgePercent
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_integer = rng.randf_range(0.0,100.0)
	if random_integer <= _dodgePercent:
		Global.show_floating_text(_spriteObj,"Attack Dodged", "dodge", position)
		return true
	else:
		return false
