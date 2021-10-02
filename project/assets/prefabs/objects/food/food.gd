extends Spatial

class_name Food


export(NodePath) var rigid_body_path
onready var rigid_body := get_node(rigid_body_path) as RigidBody

export(String) var food_name := "No Name"
export(float) var food_reward := 0.0


func make_food_static() -> void:
    rigid_body.set_mode(RigidBody.MODE_STATIC)

func apply_player_velocity(velocity: Vector3) -> void:
    rigid_body.linear_velocity += velocity * 1.0
    
func apply_player_rotation(rotation: float, player_location: Vector3) -> void:        
    var food_location = rigid_body.global_transform.origin
    rotation *= -1.0
        
    var x = food_location.x
    var z = food_location.z

    x -= player_location.x
    z -= player_location.z

    var xnew = x * cos(rotation) - z * sin(rotation)
    var znew = x * sin(rotation) + z * cos(rotation)

    x = xnew + player_location.x
    z = znew + player_location.z

    food_location.x = x
    food_location.z = z
    
    #print(String(food_location) + "\n")
    
    rigid_body.global_transform.origin = food_location
