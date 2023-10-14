extends Control

var sceneRoot
var maxHealth
var spriteReference

# Called when the node enters the scene tree for the first time.
func _ready():
	sceneRoot = get_parent().get_parent()

func _process(_delta):
	find_node("HealthVal").text = str(spriteReference.health) + "/" + str(maxHealth)

func initialize(_heading, _health, _attack, _def, _criticalHitPercent, _dodgePercent, _spriteReference):
	maxHealth = _health
	spriteReference = _spriteReference
	find_node("StatsHeading").text = str(_heading)
	find_node("HealthVal").text = str(_health)
	find_node("DefenseVal").text = str(_def)
	find_node("AttackVal").text = str(_attack)
	find_node("CriticalHitVal").text = str(_criticalHitPercent)
	find_node("DodgeVal").text = str(_dodgePercent)

func pause_game():
	self.visible = true
	sceneRoot.find_node("BackgroundTint").visible = true
	#get_tree().paused = true


func _on_OkButton_button_up():
	sceneRoot.get_parent().get_parent().get_parent().play_button_click_sound()
	unpause()

func unpause():
	self.visible = false
	sceneRoot.find_node("BackgroundTint").visible = false
	#get_tree().paused = false
