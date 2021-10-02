extends Control

class_name PlayerHUD


export(NodePath) var interaction_text_path
onready var interaction_text := get_node(interaction_text_path) as RichTextLabel


func set_interaction_text(new_text: String) -> void:        
    interaction_text.bbcode_text = "[center]" + new_text + "[/center]"
