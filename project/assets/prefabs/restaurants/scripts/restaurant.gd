extends Spatial

func _ready():
    var foodSpawners = get_tree().get_nodes_in_group("food_spawner")
    var customerManager = get_tree().get_nodes_in_group("customer_manager")
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
