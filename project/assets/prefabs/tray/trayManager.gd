extends Spatial

class_name TrayManager


export(NodePath) var tray_controller_path
onready var tray_controller := get_node(tray_controller_path) as TrayController

var food_list = []
var raycast_list = []

func _ready():
    var _error = $RigidBody_tray/FoodLimit.connect("body_exited", self, "_on_body_exit")
    _error = $RigidBody_tray/FoodLimit.connect("body_entered", self, "_on_body_enter")
    _error = tray_controller.connect("onTrayBail", self, "on_tray_bail")
    
    raycast_list = get_tree().get_nodes_in_group("tray_raycast")

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

func compute_food_position_on_tray() -> Transform: 
    var localUpwardOffset = Vector3(0.0, 0.3, 0.0)
    var localHorizontalOffset = Vector3(0.0, 0.0, 0.0)
    
    # Find horizontal offset according to raycast list
    var raycast_list_count = raycast_list.size()
    var bFoundSpot = false
    var correct_raycast = null
    var raycast_list_shuffled = raycast_list.duplicate()
    raycast_list_shuffled.shuffle()
    for raycast_list_index in range(0, raycast_list_count-1):
        var raycast_nb = raycast_list_shuffled[raycast_list_index]
        var neighbours_count = raycast_nb.neighbours.size()
        var bColliding = false
        for neighbour_index in range(0, neighbours_count-1):
            var raycast_nodepath = raycast_nb.neighbours[neighbour_index]
            var raycast = raycast_nb.get_node(raycast_nodepath) as RayCast
            var bRaycastColliding = raycast.is_colliding()
            bColliding = bColliding or bRaycastColliding
            if bColliding :
                break
        if not bColliding:
            correct_raycast = raycast_nb
            bFoundSpot = true
            break
    if bFoundSpot:
        localHorizontalOffset = global_transform.inverse().xform(correct_raycast.global_transform.origin)    
    
    # Merge offsets
    var localOffset = localUpwardOffset + localHorizontalOffset
    
    # Transform offset in global transform to return
    var newTransform = $RigidBody_tray.global_transform.translated(localOffset)
    return newTransform

func add_food(food_object: PackedScene) -> void:
    var food_instance = food_object.instance()
    get_tree().get_root().add_child(food_instance)
    food_instance.transform = compute_food_position_on_tray()
    food_list.push_back(food_instance)

func apply_player_velocity(velocity: Vector3) -> void:
    for item in food_list:
       item.apply_player_velocity(velocity);
        
func apply_player_rotation(rotation: float, player_location: Vector3) -> void:
    for item in food_list:
        item.apply_player_rotation(rotation, player_location);

func on_player_moved(direction: int, rotation: int, delta: float) -> void:
    tray_controller.on_player_moved(direction, rotation, delta)

func trigger_bail() -> void:
    tray_controller.trigger_bail()

func get_food_object(food_name: String) -> Food:
    for i in range(0, food_list.size()):
        var food = food_list[i]
        if food_name == food.food_name:
            food_list.remove(i)
            return food
    return null

func is_in_kinematic_state() -> bool:
    return tray_controller.is_in_kinematic_state()
    
func on_tray_bail() -> void:
    food_list.clear()
