extends Interactable

class_name FoodSpawner


export(PackedScene) var food_to_spawn: PackedScene

export(NodePath) var food_anchor_path
onready var food_anchor := get_node(food_anchor_path)


var food: Food


func _ready() -> void:
    food = food_to_spawn.instance() as Food
    food_anchor.add_child(food)
    food.make_food_static()
    display_text = "Press SPACE to get " + food.food_name.to_lower()

func interact(instigator):
    var player = instigator as Player
    player.tray.add_food(food_to_spawn)
