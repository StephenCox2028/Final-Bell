extends GutTest

var locker_menu

func before_each() -> void:
	locker_menu = preload("res://Scenes/locker_room.tscn").instantiate()
	add_child_autofree(locker_menu) 
	#makes the locker scene a child for this test 
	#meaning GUT will be able to interact with it
	

func after_each() -> void:
	locker_menu.queue_free() #delets the locker node from the memory once the test is completed
	# assert checks what you got and what you expected, the message for fails


func test_upgrade_button() -> void:
	locker_menu._on_upgrade_button_pressed()
	assert_eq(locker_menu.choice, 1, "Go to the Upgrade Scene")

func test_continue_button() -> void:
	locker_menu._on_continue_button_pressed()
	assert_eq(locker_menu.choice, 2, "Combat Scene")

func test_quit_button() -> void:
	locker_menu._on_quit_button_pressed()
	assert_eq(locker_menu.choice, 3, "Goes back to the start")
	
func test_coaches_button() -> void:
	locker_menu._on_coaches_button_pressed()
	assert_eq(locker_menu.choice, 4, "Go to coaches menu")	

func test_secret_button() -> void:
	locker_menu.check1on = true
	locker_menu.check2on = true
	locker_menu.check3on = true
	locker_menu._on_secret_button_pressed()
	assert_eq(locker_menu.choice, 5, "Admin menu")
