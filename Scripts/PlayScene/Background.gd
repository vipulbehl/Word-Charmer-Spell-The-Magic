extends ParallaxBackground


var scrollingSpeed
var moveBackgroundFlag = false
var pixels
var currentPos

func _ready():
	var backgroundPath = "res://Resources/Sprites/Background/%s.jpg" % (Global.level%20)
	find_node("Sprite").texture = load(backgroundPath)
	find_node("Sprite2").texture = load(backgroundPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moveBackgroundFlag:
		if abs(abs(scroll_offset.x) - abs(currentPos)) <= pixels:
			scroll_offset.x -= scrollingSpeed * delta
		else:
			moveBackgroundFlag = false

func move_background(_pixels, _scrollingSpeed):
	scrollingSpeed = _scrollingSpeed
	pixels = _pixels
	currentPos = scroll_offset.x
	moveBackgroundFlag = true
