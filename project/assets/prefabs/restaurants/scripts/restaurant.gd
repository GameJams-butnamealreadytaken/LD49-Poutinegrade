extends Spatial

func _ready():
    var foodSpawners = get_tree().get_nodes_in_group("food_spawner")
    var customerManagers = get_tree().get_nodes_in_group("customer_manager")
    var players = get_tree().get_nodes_in_group("player")
    
    if customerManagers.empty():
        return
    if players.empty():
        return
    if foodSpawners.empty():
        return
    
    # Setup links between managers and classes
    customerManagers[0].player = players[0]
    customerManagers[0].SetAvailableFoodSpawners(foodSpawners)

    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
