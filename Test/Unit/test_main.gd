extends GutTest

var start_menu

#locker part
#kinda like a precondition
#for each option
func before_each() -> void:
	start_menu = preload("res://Scenes/main_menu.tscn").instantiate()
	add_child_autofree(start_menu)
	
func after_each() -> void:
	start_menu.queue_free()

func test_startbutton() -> void:
	start_menu._on_start_button_pressed()
	assert_eq(start_menu.choice, 1, "Goes to locker menu")
	
	
func test_optionsbutton() -> void:
	start_menu._on_options_button_pressed()
	assert_eq(start_menu.choice, 2, "Options going to options menu")
	
func test_quitbutton() -> void:
	start_menu._on_quit_button_pressed()
	assert_eq(start_menu.choice, 3, "Quit goes so exit")

func test_story1Button() -> void:
	start_menu._on_story_pressed()
	assert_eq(start_menu.choice, 4, "Story part 1")
	
