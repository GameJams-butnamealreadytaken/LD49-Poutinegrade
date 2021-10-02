extends Spatial

class_name TrayManager


export(NodePath) var tray_controller_path
onready var tray_controller := get_node(tray_controller_path) as TrayController

var food_list = []

func _ready():
    var _error = $RigidBody_tray/FoodLimit.connect("body_exited", self, "_on_body_exit")
    _error = $RigidBody_tray/FoodLimit.connect("body_entered", self, "_on_body_enter")
    
func _process(_delta):
    pass

func _on_body_exit(body: Node):
    var object_id = food_list.find(body.get_owner())
    if object_id != -1:
        food_list.remove(object_id)
        
func _on_body_enter(body: Node):
    var entering_object = body.get_owner() as Food
    if entering_object != null:
        var object_id = food_list.find(body.get_owner())
        if object_id == -1:
            food_list.push_back(body.get_owner())
            print("adding entering object")

func add_food(food_object: PackedScene):
    var food_instance = food_object.instance()
    get_tree().get_root().add_child(food_instance)
    food_instance.transform = global_transform
    food_list.push_back(food_instance)

func add_player_velocity(velocity: Vector3):
    for item in food_list:
        item.add_player_velocity(velocity);

func is_in_kinematic_state() -> bool:
    return tray_controller.is_in_kinematic_state()
