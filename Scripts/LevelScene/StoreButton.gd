extends CenterContainer

var isSmallAnimation = false
var isSmallNum = false

var buttonTypes = {
	# Potions
	"healPotion" : "res://Resources/UI Elements/Buttons/Potion/HealthPotion.png",
	"powerUpPotion" : "res://Resources/UI Elements/Buttons/Potion/PowerPotion.png",
	"magicTilePotion" : "res://Resources/UI Elements/Buttons/Potion/MagicTilePotion.png",
	"longestWordFinder" : "res://Resources/UI Elements/Buttons/Potion/LongestWordPotion.png",
	"shufflePotion" : "res://Resources/UI Elements/Buttons/shufflerotate.png",
	"purifyPotion" : "res://Resources/UI Elements/Buttons/Potion/PurifyPotion.png",
	
	# Wizard Stats
	"health" : "res://Resources/UI Elements/Buttons/Cartoon RPG UI_Game Icon - Life.png",
	"attack" : "res://Resources/UI Elements/Buttons/Cartoon RPG UI_Game Icon - Attack.png",
	"defense" : "res://Resources/UI Elements/Buttons/Cartoon RPG UI_Game Icon - Defense.png",
	"criticalHitPercent" :"res://Resources/UI Elements/Buttons/Stats/CriticalHit2.png" ,
	"dodgePercent" : "res://Resources/UI Elements/Buttons/Stats/Dodge1.png",
	
	# Tiles
	"powerTile" : "res://Resources/UI Elements/GridButtons/powerupTile.png",
	"healTile" :"res://Resources/UI Elements/GridButtons/healTile.png" ,
	"freezeTile": "res://Resources/UI Elements/GridButtons/freezeTile.png" ,
	"burnTile" : "res://Resources/UI Elements/GridButtons/burnTile.png",
	"paralyzeTile": "res://Resources/UI Elements/GridButtons/paralyseTile.png",
	"questionMarkTile" :"res://Resources/UI Elements/GridButtons/questionMarkTile.png",
	"noDamageTile" : "res://Resources/UI Elements/GridButtons/noDamageTile.png",
	"bleedTile" : "res://Resources/UI Elements/GridButtons/decreaseHealthTile.png",
	
	# Coins
	"coins" : "res://Resources/UI Elements/Buttons/Cartoon RPG UI_Game Icon - Coin.png",
	"coins_1" : "res://Resources/UI Elements/Buttons/Coins_2.png",
	"coins_2" : "res://Resources/UI Elements/Buttons/Coins_3.png",
	"coins_3" : "res://Resources/UI Elements/Buttons/Coins_4.png",
	"video" : "res://Resources/UI Elements/Buttons/video_shop.png",
	"multiplier" : "res://Resources/UI Elements/Buttons/X3_2.png"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func initialize(_buttonType, _price="-1", _count=-1):
	$Button.texture_normal = load(buttonTypes[str(_buttonType)])
	
	if str(_price) != "-1":
		find_node("PriceLabel").text = str(_price)
	else:
		find_node("PriceLabel").visible = false
		find_node("CoinImage").visible = false
	
	if _count != -1:
		find_node("Count").visible = true
		find_node("Count").text = "x" + str(_count)
	else:
		find_node("Count").visible = false

func update_price(_newPrice):
	find_node("PriceLabel").text = str(_newPrice)

func hide_coins_image():
	find_node("CoinImage").visible = false

func update_count(_count):
	find_node("Count").text = "x" + str(_count)
	find_node("CountUpdateAnimation").play("UpdateCount")

func selected_animation():
	if isSmallAnimation:
		$SmallAnimation.visible = true
		$SmallAnimation/SmallAnimationPlayer.play("SmallSelectedAnim")
	elif isSmallNum:
		$SmallAnimationNum.visible = true
		$SmallAnimationNum/SmallAnimationPlayerNum.play("SmallSelectedAnim")
	else:
		$Sprite.visible = true
		$Sprite/AnimationPlayer.play("SelectedAnim")
	
func deselect():
	if isSmallAnimation:
		$SmallAnimation.visible = false
		$SmallAnimation/SmallAnimationPlayer.stop()
	elif isSmallNum:
		$SmallAnimationNum.visible = false
		$SmallAnimationNum/SmallAnimationPlayerNum.stop()
	else:
		$Sprite.visible = false
		$Sprite/AnimationPlayer.stop()

