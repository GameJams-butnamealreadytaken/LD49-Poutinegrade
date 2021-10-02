extends Spatial

func _ready():
    var foodSpawners = get_tree().get_nodes_in_group("food_spawner")
    var customerManagers = get_tree().get_nodes_in_group("customer_manager")
    var players = get_tree().get_nodes_in_group("player")
    var billboards = get_tree().get_nodes_in_group("billboard")
    
    if customerManagers.empty():
        return
    if players.empty():
        return
    if foodSpawners.empty():
        return
    if billboards.empty():
        return
    
    # Setup links between managers and classes
    customerManagers[0].player = players[0]
    customerManagers[0].SetAvailableFoodSpawners(foodSpawners)
    
    var billboardSize = billboards.size()
    for billboardIndex in range(0, billboardSize-1):
        billboards[billboardIndex].CameraToLookAt = players[0]

    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
