extends TextureButton

signal remove_selected_buttons
signal player_attack(damage)

var enemy_attack_flag = false
var enemy_attack_after_effects = false

func _process(_delta):
	if self.disabled:
		$AttackSprite.play("disabled")
	else:
		$AttackSprite.play("enabled")


func _on_Attack_pressed():
	var sceneRoot = self.get_parent()
	
	# Removing the buttons from selected buttons grid
	emit_signal("remove_selected_buttons")
	
	# Disable attack button
	self.disabled = true
	
	#Hiding all the other buttons by making HideButtons texture rectangle visible
	sceneRoot.get_node("HideButtons").visible = true
	
	_special_tile_options(sceneRoot)
	
	# Player Attack animation, handled in NinjaScene.gd
	var totalDamage = calculate_damage()
	if sceneRoot.isPowerupPotionSet:
		totalDamage += int( int(totalDamage) * int(SavedGames.saveGameDict["powerUpPotionHP"])/100)
		sceneRoot.isPowerupPotionSet = false
	
	emit_signal("player_attack", totalDamage)

func calculate_damage():
	var sceneRoot = self.get_parent()
	var buttons = sceneRoot.get_node("Buttons")
	var buttonsControlCount = buttons.get_child_count()
	var totalDamage = 0
	for iter in buttonsControlCount:
		var centerContainer = buttons.get_child(iter)
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		if textureButton.disabled:
			var damage = centerContainer.damage * centerContainer.multiplier
			damage = (damage * damage) / sceneRoot.enemyRef.def
			totalDamage += damage
			
			# Conditions for freezetile and poweruptile damage
			if centerContainer.special_effect == "Freeze":
				totalDamage += SavedGames.saveGameDict["freezeTileHP"]
			if centerContainer.special_effect == "Powerup":
				totalDamage += SavedGames.saveGameDict["powerUpTileHP"]
	
	return int(totalDamage)

func _special_tile_options(_sceneRoot):
	var buttons = _sceneRoot.get_node("Buttons")
	var _is_bleed_tile_encountered = false
	var _bleed_tile_encountered_damage = 0
	var _is_heal_tile_encountered = false
	var _heal_tile_health = 0
	
	for iter in buttons.get_child_count():
		var centerContainer = buttons.get_child(iter)
		var textureButton : TextureButton = centerContainer.find_node("TextureButton")
		if textureButton.disabled:
			var tileType = centerContainer.special_effect
			if tileType == "Heal":
				_is_heal_tile_encountered = true
				_heal_tile_health += SavedGames.saveGameDict["healTileHP"]
			elif tileType == "Freeze":
				_sceneRoot.isEnemyFreeze = true
			elif tileType == "Paralyse":
				_sceneRoot.isEnemyParalyze = true
			elif tileType == "Burn":
				_sceneRoot.isEnemyBurn = true
			elif tileType == "decreaseHealthTile":
				var _playerObj = _sceneRoot.playerRef
				_playerObj.health -= centerContainer.damage
				_sceneRoot.get_node("PlayerHealthBar").set_health_value(_playerObj.health)
				_is_bleed_tile_encountered = true
				_bleed_tile_encountered_damage += centerContainer.damage
	
	if _is_bleed_tile_encountered:
		Global.show_floating_text(_sceneRoot.playerRef,"-%s Bleed"%str(_bleed_tile_encountered_damage),"damage",Vector2(150,30))
	
	if _is_heal_tile_encountered:
		_heal_player(_sceneRoot,_heal_tile_health)


func _heal_player(_sceneRoot, _health):
	var _playerObj = _sceneRoot.playerRef
	_playerObj.health += _health
	_sceneRoot.get_node("PlayerHealthBar").set_health_value(_playerObj.health)
	
	var floatingString = "+ "+str(_health)
	Global.show_floating_text(_playerObj, floatingString, "heal", Vector2(100,0))
