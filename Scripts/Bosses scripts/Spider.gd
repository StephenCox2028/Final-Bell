extends Node
func Actions(boss_node):
	print(boss_node.health, boss_node.strength, boss_node.power)
	var action = randi_range(1, 3)
	print 
	match action:# these play anmations but we dont gottem yet
		1:
			boss_node.change_sprite_texture("res://Sprites/bear.jpg")
		2:
			#enemy_node.animation_player.play("")
			boss_node.change_sprite_texture("res://Sprites/pider.jpg")
		3:
			#enemy_node.animation_player.play("")
			boss_node.change_sprite_texture("res://Sprites/image0racoon.jpg")
