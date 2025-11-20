func Actions(boss_node):
	print(boss_node.health, boss_node.stamina, boss_node.power)
	var action = randi_range(1, 3)
	match action:# these play anmations but we dont gottem yet
		1:
			boss_node.animation_player.play("idle")
			pass
		2:
			boss_node.animation_player.play("block")
			pass
		3:
			boss_node.animation_player.play("block")
			pass
