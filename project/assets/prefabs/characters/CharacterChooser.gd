extends Spatial

# var
export(String, "Adventurer", "Man", "ManAlternative", "Orc", "Robot", "Soldier", "Woman", "WomanAlternative") var CharacterType
var dictionnaryCharacterTypeToResource = {
    "Adventurer" : preload("res://assets/models/characters/Skins/Basic/skin_adventurer.png"),
    "Man" : preload("res://assets/models/characters/Skins/Basic/skin_man.png"),
    "ManAlternative" : preload("res://assets/models/characters/Skins/Basic/skin_manAlternative.png"),
    "Orc" : preload("res://assets/models/characters/Skins/Basic/skin_orc.png"),
    "Robot" : preload("res://assets/models/characters/Skins/Basic/skin_robot.png"),
    "Soldier" : preload("res://assets/models/characters/Skins/Basic/skin_soldier.png"),
    "Woman" : preload("res://assets/models/characters/Skins/Basic/skin_woman.png"),
    "WomanAlternative" : preload("res://assets/models/characters/Skins/Basic/skin_womanAlternative.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
    #
    # Choose texture
    if CharacterType.empty():
        CharacterType = "Man"
    var textureToUse = dictionnaryCharacterTypeToResource[CharacterType]
    
    #
    # Setup material
    var iMaterialsCount = $character.get_surface_material_count()
    for iMaterialIndex in iMaterialsCount:
        var mat = $character.get_surface_material(iMaterialIndex)
        mat.set_shader_param("tex_frg_2", textureToUse)
        
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
