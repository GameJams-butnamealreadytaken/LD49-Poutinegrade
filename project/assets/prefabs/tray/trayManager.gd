extends Spatial

class_name TrayManager


export(NodePath) var tray_controller_path
onready var tray_controller := get_node(tray_controller_path) as TrayController

var food_list = []

func _ready():
    var _error = $RigidBody_tray/FoodLimit.connect("body_exited", self, "_on_body_exit")
    _error = $RigidBody_tray/FoodLimit.connect("body_entered", self, "_on_body_enter")
    

func _on_body_exit(body: Node) -> void:
    var object_id = food_list.find(body.get_owner())
    if object_id != -1:
        food_list.remove(object_id)
        
func _on_body_enter(body: Node) -> void:
    var entering_object = body.get_owner() as Food
    if entering_object != null:
        var object_id = food_list.find(body.get_owner())
        if object_id == -1:
            food_list.push_back(body.get_owner())

func add_food(food_object: PackedScene) -> void:
    var food_instance = food_object.instance()
    get_tree().get_root().add_child(food_instance)
    food_instance.transform = global_transform
    food_list.push_back(food_instance)

func apply_player_velocity(velocity: Vector3) -> void:
    for item in food_list:
        item.apply_player_velocity(velocity);
        
func apply_player_rotation(rotation: float, player_location: Vector3) -> void:
    for item in food_list:
        item.apply_player_rotation(rotation, player_location);

func is_in_kinematic_state() -> bool:
    return tray_controller.is_in_kinematic_state()
