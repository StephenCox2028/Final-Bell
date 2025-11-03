extends Node
func Actions(boss_node):
	print(boss_node.health, boss_node.stamina, boss_node.power)
	var action = randi_range(1, 3)
	match action:# these play anmations but we dont gottem yet
		1:
			pass
		2:
			pass
		3:
			pass
