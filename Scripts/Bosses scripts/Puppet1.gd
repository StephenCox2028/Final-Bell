var max_health = Global.bosses.health
var phase_2_initialized = false  # Prevent repeated phase 2 setup

func Actions(boss_node):
	print(Global.bosses.health, Global.bosses.stamina, Global.bosses.power)
	
	var action
	var half_hp = max_health / 2
	
	# Check for phase transition
	if Global.bosses.phase == 1 and Global.bosses.health <= half_hp:
		transition_to_phase_2(boss_node)
		return  # Exit early during transition
	
	# Phase 1 actions
	if Global.bosses.phase == 1:
		action = randi_range(1, 6)
		match action:
			1:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1Idle")
			2:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1left_punch")
			3:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1Block")
			4:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1right_punch")
			5:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1left_hook")
			6:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer1right_hook")
	
	# Phase 2 actions
	elif Global.bosses.phase == 2:
		action = randi_range(1, 4)
		match action:
			1:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Idle")
			2:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Jab")
			3:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Block")
			4:
				boss_node.get_node("AnimatedSprite2D").play("Puppeteer2Cross")

func transition_to_phase_2(boss_node):
	if phase_2_initialized:
		return  # Already transitioned
	
	phase_2_initialized = true
	Global.bosses.phase = 2
	Global.bosses.health = 50  # Heal to 50
	Global.bosses.power *= 1.5  # Increase power once
	boss_node.get_node("Timer").wait_time = 0.5
	
	# Play transition animations in sequence
	boss_node.get_node("AnimatedSprite2D").play("PuppeteerThrowP1")
