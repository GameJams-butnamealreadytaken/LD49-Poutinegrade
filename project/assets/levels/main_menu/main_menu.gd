extends Control


func _ready() -> void:
    pass
    
func _on_QuitButton_pressed() -> void:
    get_tree().quit()


func _on_ButtonRun_pressed():
    get_parent().start_game()

