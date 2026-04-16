extends GutTest

var upgrade_menu

var original_health:  int
var original_stamina: int
var original_power:   int
var original_xp:      int

const ENOUGH_XP := 9999

func before_each() -> void:
	upgrade_menu = preload("res://Scenes/Upgrade.tscn").instantiate()
	add_child_autofree(upgrade_menu)

	# Give the player plenty of XP so every upgrade test can proceed
	Global.playerStats.totalXP = ENOUGH_XP

	# Snapshot state AFTER setting XP so diffs are accurate
	original_health  = Global.playerStats.maxHealth
	original_stamina = Global.playerStats.maxStamina
	original_power   = Global.playerStats.maxPower
	original_xp      = Global.getTotalXP()

# Stat increases by exactly 1
func test_health_button_increases_health() -> void:
	await upgrade_menu._on_health_button_pressed()
	assert_eq(Global.getMaxPlayerHealth() - original_health, 1,
		"Max health should increase by 1")

# XP is deducted
func test_health_button_deducts_xp() -> void:
	await upgrade_menu._on_health_button_pressed()
	assert_lt(Global.getTotalXP(), original_xp,
		"XP should decrease after health upgrade")

# Cost increases so the next upgrade is more expensive
func test_health_button_raises_cost() -> void:
	var cost_before = Global.getHealthCost()
	await upgrade_menu._on_health_button_pressed()
	assert_gt(Global.getHealthCost(), cost_before,
		"Health upgrade cost should increase after purchase")

# Blocked when XP is zero
func test_health_button_blocked_when_no_xp() -> void:
	Global.playerStats.totalXP = 0
	await upgrade_menu._on_health_button_pressed()
	assert_eq(Global.getMaxPlayerHealth(), original_health,
		"Health should NOT increase when player has no XP")

# isPlaying flag prevents double-upgrading on rapid presses
func test_health_button_no_double_upgrade_on_rapid_press() -> void:
	# Fire twice without awaiting — second call should be blocked by isPlaying
	upgrade_menu._on_health_button_pressed()
	upgrade_menu._on_health_button_pressed()
	await upgrade_menu.spitAnim.animation_finished
	assert_eq(Global.getMaxPlayerHealth() - original_health, 1,
		"Health should only increase by 1 even if button is pressed twice quickly")
		
func test_stamina_button_increases_stamina() -> void:
	await upgrade_menu._on_stamina_button_pressed()
	assert_eq(Global.getMaxPlayerStamina() - original_stamina, 1,
		"Max stamina should increase by 1")

func test_stamina_button_deducts_xp() -> void:
	await upgrade_menu._on_stamina_button_pressed()
	assert_lt(Global.getTotalXP(), original_xp,
		"XP should decrease after stamina upgrade")

func test_stamina_button_raises_cost() -> void:
	var cost_before = Global.getStaminaCost()
	await upgrade_menu._on_stamina_button_pressed()
	assert_gt(Global.getStaminaCost(), cost_before,
		"Stamina upgrade cost should increase after purchase")

func test_stamina_button_blocked_when_no_xp() -> void:
	Global.playerStats.totalXP = 0
	await upgrade_menu._on_stamina_button_pressed()
	assert_eq(Global.getMaxPlayerStamina(), original_stamina,
		"Stamina should NOT increase when player has no XP")

func test_stamina_button_no_double_upgrade_on_rapid_press() -> void:
	upgrade_menu._on_stamina_button_pressed()
	upgrade_menu._on_stamina_button_pressed()
	await upgrade_menu.spitAnim.animation_finished
	assert_eq(Global.getMaxPlayerStamina() - original_stamina, 1,
		"Stamina should only increase by 1 even if button is pressed twice quickly")

func test_power_button_increases_power() -> void:
	await upgrade_menu._on_power_button_pressed()
	assert_eq(Global.getMaxPlayerPower() - original_power, 1,
		"Max power should increase by 1")

func test_power_button_deducts_xp() -> void:
	await upgrade_menu._on_power_button_pressed()
	assert_lt(Global.getTotalXP(), original_xp,
		"XP should decrease after power upgrade")

func test_power_button_raises_cost() -> void:
	var cost_before = Global.getPowerCost()
	await upgrade_menu._on_power_button_pressed()
	assert_gt(Global.getPowerCost(), cost_before,
		"Power upgrade cost should increase after purchase")

func test_power_button_blocked_when_no_xp() -> void:
	Global.playerStats.totalXP = 0
	await upgrade_menu._on_power_button_pressed()
	assert_eq(Global.getMaxPlayerPower(), original_power,
		"Power should NOT increase when player has no XP")

func test_power_button_no_double_upgrade_on_rapid_press() -> void:
	upgrade_menu._on_power_button_pressed()
	upgrade_menu._on_power_button_pressed()
	await upgrade_menu.spitAnim.animation_finished
	assert_eq(Global.getMaxPlayerPower() - original_power, 1,
		"Power should only increase by 1 even if button is pressed twice quickly")

func test_health_upgrade_does_not_affect_stamina_or_power() -> void:
	await upgrade_menu._on_health_button_pressed()
	assert_eq(Global.getMaxPlayerStamina(), original_stamina,
		"Stamina should be unchanged after health upgrade")
	assert_eq(Global.getMaxPlayerPower(), original_power,
		"Power should be unchanged after health upgrade")

func test_stamina_upgrade_does_not_affect_health_or_power() -> void:
	await upgrade_menu._on_stamina_button_pressed()
	assert_eq(Global.getMaxPlayerHealth(), original_health,
		"Health should be unchanged after stamina upgrade")
	assert_eq(Global.getMaxPlayerPower(), original_power,
		"Power should be unchanged after stamina upgrade")

func test_power_upgrade_does_not_affect_health_or_stamina() -> void:
	await upgrade_menu._on_power_button_pressed()
	assert_eq(Global.getMaxPlayerHealth(), original_health,
		"Health should be unchanged after power upgrade")
	assert_eq(Global.getMaxPlayerStamina(), original_stamina,
		"Stamina should be unchanged after power upgrade")
		
func test_health_upgrade_succeeds_when_xp_exactly_equals_cost() -> void:
	Global.playerStats.totalXP = Global.getHealthCost()
	await upgrade_menu._on_health_button_pressed()
	assert_eq(Global.getMaxPlayerHealth() - original_health, 1,
		"Health upgrade should succeed when XP == cost exactly")

func test_stamina_upgrade_succeeds_when_xp_exactly_equals_cost() -> void:
	Global.playerStats.totalXP = Global.getStaminaCost()
	await upgrade_menu._on_stamina_button_pressed()
	assert_eq(Global.getMaxPlayerStamina() - original_stamina, 1, 
		"Stamina upgrade should succeed when XP == cost exactly")

func test_power_upgrade_succeeds_when_xp_exactly_equals_cost() -> void:
	Global.playerStats.totalXP = Global.getPowerCost()
	await upgrade_menu._on_power_button_pressed()
	assert_eq(Global.getMaxPlayerPower() - original_power, 1, 
		"Power upgrade should succeed when XP == cost exactly")
