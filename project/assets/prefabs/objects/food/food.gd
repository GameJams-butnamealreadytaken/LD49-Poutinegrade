extends Spatial

class_name Food


export(NodePath) var rigid_body_path
onready var rigid_body := get_node(rigid_body_path) as RigidBody

export(String) var food_name := "No Name"
export(float) var food_reward := 0.0


func make_food_static() -> void:
    rigid_body.set_mode(RigidBody.MODE_STATIC)

func add_player_velocity(velocity: Vector3):
    rigid_body.linear_velocity += velocity * 0.95
