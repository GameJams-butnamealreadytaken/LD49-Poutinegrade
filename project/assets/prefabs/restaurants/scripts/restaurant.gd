extends Spatial

export(int) var game_duration_seconds = 300
var remaining_time = 0
var player
var customerManager

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
    player = players[0]
    customerManager = customerManagers[0]
    customerManager.player = player
    customerManager.SetAvailableFoodSpawners(foodSpawners)
    
    var billboardSize = billboards.size()
    for billboardIndex in range(0, billboardSize-1):
        billboards[billboardIndex].CameraToLookAt = player

    remaining_time = game_duration_seconds
    
func reset():
    remaining_time = game_duration_seconds
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not Game.started:
        reset()
        return
        
    if remaining_time > 0:
        remaining_time = max(remaining_time - delta, 0)
        if remaining_time <= 0:
            player.on_game_finished()
        player.hud.set_label_time_value(String(remaining_time))
