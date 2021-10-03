extends Node

export(PackedScene) var main_menu_scene
var main_menu : Control

export(PackedScene) var restaurant_scene
var restaurant : Spatial

var initialPlayerTransform : Transform

# Called when the node enters the scene tree for the first time.
func _ready():
    # load Main Menu
    if not main_menu_scene == null:
        main_menu = main_menu_scene.instance() as Control
        add_child(main_menu)
        
    # load Restaurant
    if not restaurant_scene == null:
        var restaurant_parent = restaurant_scene.instance() as Spatial
        if not restaurant_parent == null:
            add_child(restaurant_parent)
            restaurant = restaurant_parent.get_child(0)
            var player = restaurant.player
            player.hud.hide()
            get_tree().root.find_node("CameraMainMenu", true, false).make_current()
            initialPlayerTransform = restaurant.player.global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func start_game():
    Game.started = true
    if not main_menu == null:
        main_menu.hide()
    if not restaurant == null:
        restaurant.player.hud.show()
        restaurant.player.game_finished = false
        get_tree().root.find_node("Camera", true, false).make_current()
        restaurant.player.global_transform = initialPlayerTransform
        restaurant.player.last_velocity = Vector3(0.0, 0.0, 0.0)
        restaurant.customerManager.ValidateCustomers()
        
        
func stop_game():
    Game.started = false
    if not main_menu == null:
        main_menu.show()
    if not restaurant == null:
        restaurant.player.hud.hide()
        restaurant.player.tray.reset()
        get_tree().root.find_node("CameraMainMenu", true, false).make_current()
