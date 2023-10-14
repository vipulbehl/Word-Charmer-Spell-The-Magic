extends Control

var currentSelectedButton

var storeButtonScene = preload("res://Scenes/Level/StoreButton.tscn")

# Button References
var videoScene
var multiplierScene
var tenKCoinsScene
var twentyKCoinsScene
var fiftyKCoinsScene
var hundredKCoinsScene

var watchVideoImage = preload("res://Resources/UI Elements/Buttons/BeforeClick/video1_blue.png")
var watchVideoImageClicked = preload("res://Resources/UI Elements/Buttons/Clicked/video1_blue.png")
var makePurchaseImage = preload("res://Resources/UI Elements/Buttons/BeforeClick/purchase_green.png")
var makePurchaseImageClicked = preload("res://Resources/UI Elements/Buttons/Clicked/purchase_green.png")


var payment
var paymentDict = {}
var priceDict = {}

func _ready():
	initialize_all_buttons()
	
	_setup_google_billing()
	
	_on_watch_video(true)

func _process(_delta):
	if currentSelectedButton == null or currentSelectedButton == videoScene:
		find_node("BuyButton").texture_normal = watchVideoImage
		find_node("BuyButton").texture_pressed = watchVideoImageClicked
	else:
		find_node("BuyButton").texture_normal = makePurchaseImage
		find_node("BuyButton").texture_pressed = makePurchaseImageClicked
		
	multiplierScene.update_price(priceDict.get("coin_multiplier","100"))
	tenKCoinsScene.update_price(priceDict.get("buy_10k_coins","100")) 
	twentyKCoinsScene.update_price(priceDict.get("buy_22k_coins","200"))
	fiftyKCoinsScene.update_price(priceDict.get("buy_50k_coins","400"))
	hundredKCoinsScene.update_price(priceDict.get("buy_1l_coins","500"))

func start():
	_on_watch_video(true)

func _setup_google_billing():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		
		# These are all signals supported by the API
		# You can drop some of these based on your needs
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.startConnection()
	else:
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")

func initialize_all_buttons():
	videoScene = storeButtonScene.instance()
	videoScene.initialize("video","Ad")
	videoScene.hide_coins_image()
	videoScene.find_node("Button").connect("button_up",self,"_on_watch_video")
	videoScene.connect("gui_input",self,"_on_watch_video_container")
	$GridContainer.add_child(videoScene)
	
	multiplierScene = storeButtonScene.instance()
	multiplierScene.initialize("multiplier",100)
	multiplierScene.hide_coins_image()
	multiplierScene.find_node("Button").connect("button_up",self,"_on_multiplier")
	multiplierScene.connect("gui_input",self,"_on_multiplier_container")
	$GridContainer.add_child(multiplierScene)

	tenKCoinsScene = storeButtonScene.instance()
	tenKCoinsScene.initialize("coins", 100)
	tenKCoinsScene.hide_coins_image()
	tenKCoinsScene.find_node("Button").connect("button_up",self,"_on_tenK_coins")
	tenKCoinsScene.connect("gui_input",self,"_on_tenK_coins_container")
	$GridContainer.add_child(tenKCoinsScene)
	
	twentyKCoinsScene = storeButtonScene.instance()
	twentyKCoinsScene.initialize("coins_1", 200)
	twentyKCoinsScene.hide_coins_image()
	twentyKCoinsScene.find_node("Button").connect("button_up",self,"_on_twentyK_coins")
	twentyKCoinsScene.connect("gui_input",self,"_on_twentyK_coins_container")
	$GridContainer.add_child(twentyKCoinsScene)
	
	
	fiftyKCoinsScene = storeButtonScene.instance()
	fiftyKCoinsScene.initialize("coins_2", 400)
	fiftyKCoinsScene.hide_coins_image()
	fiftyKCoinsScene.find_node("Button").connect("button_up",self,"_on_fiftyK_coins")
	fiftyKCoinsScene.connect("gui_input",self,"_on_fiftyK_coins_container")
	$GridContainer.add_child(fiftyKCoinsScene)
	
	
	hundredKCoinsScene = storeButtonScene.instance()
	hundredKCoinsScene.initialize("coins_3", 500)
	hundredKCoinsScene.hide_coins_image()
	hundredKCoinsScene.find_node("Button").connect("button_up",self,"_on_hundredK_coins")
	hundredKCoinsScene.connect("gui_input",self,"_on_hundredK_coins_container")
	$GridContainer.add_child(hundredKCoinsScene)
	
	
func potion_selected_options(_heading):
	find_node("BuyButton").disabled = false
	get_tree().call_group("deselect", "deselect")
	yield(get_tree().create_timer(0.05), "timeout")
	currentSelectedButton.selected_animation()
	$StatHeading.text = _heading
	

# Google Play Billing Callbacks
func _on_connected():
	payment.querySkuDetails(["coin_multiplier","buy_10k_coins","buy_22k_coins","buy_50k_coins","buy_1l_coins"], "inapp")

func _on_connect_error(_val1=1,_val2=""):
	print("Unable to make a connection to purchase api")
	print(_val1)
	print(_val2)


func _on_sku_details_query_completed(sku_details):
	for avail in sku_details:
		paymentDict[str(avail["sku"])] = str(avail["price_currency_code"]) +" "+ str(avail["price"])
		var _price_val = str(avail["price"]).split(".",true,1)
		if _price_val.size()>0:
			priceDict[str(avail["sku"])] = _price_val[0]
		else:
			priceDict[str(avail["sku"])] = str(avail["price_currency_code"]) +" "+ str(avail["price"])

func _on_sku_details_query_error(_val1=1, _val2="", _val3=""):
	print("Error while querying sku, printing details")
	print(_val1)
	print(_val2)
	print(_val3)

func _on_purchases_updated(_items):
	for item in _items:
		if !item.is_acknowledged:
			payment.acknowledgePurchase(item.purchase_token)
		
	var itemToken
	var itemSku
	if _items.size() > 0:
		var currentItem = _items[_items.size() - 1]
		itemToken = currentItem.purchase_token
		itemSku = currentItem.sku
	
	if itemToken == null:
		print("Error while making a purchase")
	else:
		print("Printing consumed icon token %s"%itemToken)
		print("Item purchased = %s"%itemSku)
		payment.consumePurchase(itemToken)
		
		if itemSku == "coin_multiplier":
			SavedGames.saveGameDict["multiplier"] *= 3
			SavedGames.save_game_state()
		elif itemSku == "buy_10k_coins":
			SavedGames.saveGameDict["coins"] += 10000
			SavedGames.save_game_state()
		elif itemSku == "buy_22k_coins":
			SavedGames.saveGameDict["coins"] += 22000
			SavedGames.save_game_state()
		elif itemSku == "buy_50k_coins":
			SavedGames.saveGameDict["coins"] += 50000
			SavedGames.save_game_state()
		elif itemSku == "buy_1l_coins":
			SavedGames.saveGameDict["coins"] += 100000
			SavedGames.save_game_state()

func _on_purchase_acknowledged(_token):
	print("Purchase was acknowledged ! " + _token)

func _on_purchase_acknowledgement_error(_token):
	print("Error while acknowledging " + _token)

func _on_purchase_consumed(_token):
	print("Item was consumed " + _token)

func _on_purchase_consumption_error(_token):
	print("Error while consuming " + _token)

# Button Callbacks
func _on_watch_video_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_watch_video()

func _on_watch_video(_from_load=false):
	if not _from_load:
		_play_button_click_sound()
		
	currentSelectedButton = videoScene
	potion_selected_options("Watch Video")
	find_node("StatDescription").bbcode_text = "[center]Watch video ad to earn [color=#0091FF]%s coins[/color][/center]" % str(int(sqrt(float(SavedGames.saveGameDict["maxUnlockedLevel"])) * 500))

func _on_multiplier_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_multiplier()

func _on_multiplier():
	_play_button_click_sound()
	currentSelectedButton = multiplierScene
	potion_selected_options("Buy Multiplier")
	find_node("StatDescription").bbcode_text = "[center]Buy for [color=#0091FF]%s[/color], Triples all the coins earned by defeating enemies.[/center]" % paymentDict.get("coin_multiplier","Rs. 100")

func _on_tenK_coins_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_tenK_coins()

func _on_tenK_coins():
	_play_button_click_sound()
	currentSelectedButton = tenKCoinsScene
	potion_selected_options("Small Pile of Coins")
	find_node("StatDescription").bbcode_text = "[center]Buy 10,000 coins for %s[/center]" %  paymentDict.get("buy_10k_coins","Rs. 100")

func _on_twentyK_coins_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_twentyK_coins()

func _on_twentyK_coins():
	_play_button_click_sound()
	currentSelectedButton = twentyKCoinsScene
	potion_selected_options("Medium Pile of Coins")
	find_node("StatDescription").bbcode_text = "[center]Buy 22,000 coins for %s[/center]" % paymentDict.get("buy_22k_coins","Rs. 200")

func _on_fiftyK_coins_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_fiftyK_coins()

func _on_fiftyK_coins():
	_play_button_click_sound()
	currentSelectedButton = fiftyKCoinsScene
	potion_selected_options("Big Pile of Coins")
	find_node("StatDescription").bbcode_text = "[center]Buy 50,000 coins for %s[/center]" % paymentDict.get("buy_50k_coins","Rs. 400")

func _on_hundredK_coins_container(event):
	if event is InputEventMouseButton and not event["pressed"]:
		_on_hundredK_coins()

func _on_hundredK_coins():
	_play_button_click_sound()
	currentSelectedButton = hundredKCoinsScene
	potion_selected_options("Humongous Pile of Coins")
	find_node("StatDescription").bbcode_text = "[center]Buy 1,00,000 coins from %s[/center]" % paymentDict.get("buy_1l_coins","Rs. 500")


func _play_button_click_sound():
	if SavedGames.saveGameDict["soundEnabled"]:
		$NormalButtonClick.play()

func _on_BuyButton_button_up():
	if SavedGames.saveGameDict["soundEnabled"]:
		$BuySound.play()
	
	if currentSelectedButton == videoScene:
		# This parent is the object to home scene root
		var parent = get_parent().get_parent().get_parent().get_parent()
		if parent.get("storeGetCoinsAd") == null:
			parent = parent.playScene
		
		if parent.admob.is_rewarded_video_loaded():
			parent.admob.show_rewarded_video()
			parent.storeGetCoinsAd = true
		else:
			#parent.admob.load_rewarded_video()
			parent.adNotLoadedRef.toggle()
		pass
	elif currentSelectedButton == multiplierScene:
		# on successfull purchase do the following
		#SavedGames.saveGameDict["multiplier"] *= 2
		payment.purchase("coin_multiplier")
	elif currentSelectedButton == tenKCoinsScene:
		payment.purchase("buy_10k_coins")
	elif currentSelectedButton == twentyKCoinsScene:
		payment.purchase("buy_22k_coins")
	elif currentSelectedButton == fiftyKCoinsScene:
		payment.purchase("buy_50k_coins")
	else:
		payment.purchase("buy_1l_coins")
