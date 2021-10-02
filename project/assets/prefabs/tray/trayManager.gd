extends Spatial

class_name TrayManager

var food_list = []

func _ready():
    $RigidBody_tray/FoodLimit.connect("body_exited", self, "_on_body_exit")   

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass

func _on_body_exit(body: Node):
    var object_id = food_list.find(body.get_owner())
    if object_id != -1:
        food_list.remove(object_id)

func add_food(food_object):
    var food_instance = food_object.instance()
    get_tree().get_root().add_child(food_instance)
    food_instance.transform = global_transform
    food_list.push_back(food_instance)
