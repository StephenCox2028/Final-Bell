func Actions(enemy_node):
	print(enemy_node.health, enemy_node.strength, enemy_node.power)
	var action = randi_range(1, 3)
	print 
	match action:
		1:
			enemy_node.animation_player.play("Dodge")# change the animation player to also change their hittability
		2:
			enemy_node.animation_player.play("Smack")
		3:
			enemy_node.animation_player.play("Block")
