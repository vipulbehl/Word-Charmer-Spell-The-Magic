extends Control

var tips = [
	'Use burn tile on enemies having full health will deal more damage',
	'Letters are of 3 types, bronze silver and gold. Gold ones deals the most damage',
	'Buy the X3 Multiplier from the shop to get more coins from each enemy',
	'Use the "Find a word" button if you are unable to make any word using the current grid',
	'Paralyze tile weakens the enemy, very useful against boss enemies',
	'Reviving your wizard after he dies will fill the health bar by 25%',
	'You can still shuffle the grid if you are out of free shuffles but you will lose your turn',
	'The cost of Heal Potion and Power Potion increases every time you upgrade them, so buy before upgrading',
	'Play the endless mode to show your true power and get a rank in the leaderboards',
	'Most of the Potions get costly as you reach higher level',
	'Upgrade the Magic Tiles in the shop to make them even more powerful',
	'Low on coins? You can buy them in the shop or get some by watching a video ad',
	'Sharing and Rating the app will give you free coins',
	'Try to combine potions and magic tiles in an attack to deal huge damage',
	'Endless mode unlocks at level 10. Play it to get more coins',
	'You can double your coins earned at the end of each level by watching a video ad',
	'You can replay any level to earn more coins',
	'Heal tile and bleed tile will show effect even if the attack gets dodged',
	'Critical Hit and Dodge can turn fights around. Upgrade them to increase your chances',
	'Upgrading your wizard is very crucial for winning at higher levels',
	'Sharing the game on Facebook and Twitter gives extra 5000 coins each'
]


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomTip = rng.randi_range(0, len(tips)-1)
	$Tip.text = "Tip : " + str(tips[randomTip])
