extends Control

class_name PlayerHUD


export(NodePath) var interaction_text_path
onready var interaction_text := get_node(interaction_text_path) as RichTextLabel

export(NodePath) var label_clients_requesting_value_path
onready var label_clients_requesting_value := get_node(label_clients_requesting_value_path) as Label

export(NodePath) var label_money_value_path
onready var label_money_value := get_node(label_money_value_path) as Label

func set_interaction_text(new_text: String) -> void:        
    interaction_text.bbcode_text = "[center]" + new_text + "[/center]"

func set_label_clients_requesting_value(new_value: String) -> void:
    label_clients_requesting_value.text = new_value

func set_label_money_value(new_value: String) -> void:
    label_money_value.text = new_value
