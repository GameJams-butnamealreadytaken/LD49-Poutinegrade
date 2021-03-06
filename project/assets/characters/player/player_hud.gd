extends Control

class_name PlayerHUD


export(NodePath) var interaction_text_path
onready var interaction_text := get_node(interaction_text_path) as RichTextLabel

export(NodePath) var label_clients_requesting_value_path
onready var label_clients_requesting_value := get_node(label_clients_requesting_value_path) as Label

export(NodePath) var label_money_value_path
onready var label_money_value := get_node(label_money_value_path) as Label

export(NodePath) var label_time_value_path
onready var label_time_value := get_node(label_time_value_path) as Label

func _ready():
    $TabContainer.set_tab_disabled(1, true)
    $TabContainer.set_tab_title(0, "")
    $TabContainer.set_tab_title(1, "")
    
func _process(_delta):
    if $TabContainer.current_tab == 1 and Input.is_action_just_pressed("interact"):
        _on_ButtonReturnMainMenu_pressed()

func set_interaction_text(new_text: String) -> void:        
    interaction_text.bbcode_text = "[center]" + new_text + "[/center]"

func set_label_clients_requesting_value(new_value: String) -> void:
    label_clients_requesting_value.text = new_value

func set_label_money_value(new_value: String) -> void:
    label_money_value.text = new_value

func set_label_time_value(new_value: String) -> void:
    label_time_value.text = new_value

func show_game_finished() -> void:
    $TabContainer.current_tab = 1

func _on_ButtonReturnMainMenu_pressed():
    $TabContainer.current_tab = 0
    get_tree().root.get_child(1).stop_game()
