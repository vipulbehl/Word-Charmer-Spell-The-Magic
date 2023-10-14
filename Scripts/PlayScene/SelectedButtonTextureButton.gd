extends TextureButton

func _ready():
	pass # Replace with function body.


func simulate_selected_texture_button_press():
	_on_SelectedButtonTextureButton_pressed()

# Iterate over the grid and find the node. For every node after that restore gird
# find on grid, enable, texture_normal
# clear in selectedletterGrid
func _on_SelectedButtonTextureButton_pressed():
#	#self = is the SelectedButtonTextureButton
	var centerContainer = self.get_parent() #SelectedButtonCenterContainer
	var selectedLettersGrid : GridContainer = self.get_parent().get_parent()
	var sceneRoot = selectedLettersGrid.get_parent()
	var selectedLetters : Label = sceneRoot.get_node("SelectedLetters")
	var buttonsControl = sceneRoot.get_node("Buttons")
	
#	#Iterate over the Letters in SelectedLettersGrid
	for i in range(0, selectedLettersGrid.get_child_count()):
		#Iterate untill you find the Container from which this button was clicked
		if  selectedLettersGrid.get_child(i) != centerContainer:
			continue
#		#Iterate all the letters in the SelectedLetter from this point
		for j in range(i, selectedLettersGrid.get_child_count()):
			var centerControl = selectedLettersGrid.get_child(j)
			
#			#Iterate over the Buttons Control and activate them
			for k in range(0, buttonsControl.get_child_count()):
				var centerContainerChild = buttonsControl.get_child(k)
				var textureButton : TextureButton = centerContainerChild.get_node("TextureButton")
				var label = centerContainerChild.get_node("Label")
				var buttonRarity = centerContainerChild.find_node("ButtonRarity")
				if centerContainerChild.get("pos") == centerControl.get("pos"):
					textureButton.disabled = false
					buttonRarity.visible = true
					label.add_color_override("font_color", Color(0,0,0,1))
					break
	var found = false
	#Iterate over the selectedLettersGrid and delete them
	for k in selectedLettersGrid.get_children():
		if k == centerContainer:
			found = true
		if found :
			selectedLettersGrid.remove_child(k)
			k.queue_free()
	selectedLetters.text = ""
#	Iterate over the selectedLettersGrid and get remaining letters
#
	for k in selectedLettersGrid.get_children():
		var label : Label = k.get_node("SelectedButtonLabel")
		selectedLetters.text += label.text
	
	#Since these singal cannot be directly linked to playerscene.gd scripts
	#Creating an intermediary function in SelectedLettersGrid and emitting the
	#signal from there
	selectedLettersGrid._emitValidateWordSignal()
