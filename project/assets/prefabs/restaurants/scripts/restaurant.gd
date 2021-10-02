extends Spatial

func _ready():
    var foodSpawners = get_tree().get_nodes_in_group("food_spawner")
    var customerManagers = get_tree().get_nodes_in_group("customer_manager")
    var players = get_tree().get_nodes_in_group("player")
    
    if not players.empty() and not customerManagers.empty():
        customerManagers[0].HUD = players[0].hud
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
