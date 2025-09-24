func Actions(enemy_node):
	var action = randi_range(1, 3)
	match action:
		1:
			enemy_node.animation_player.play("Dodge")# change the animation player to also change their hittability
		2:
			enemy_node.animation_player.play("Smack")
		3:
			enemy_node.animation_player.play("Block")
	print("1")
