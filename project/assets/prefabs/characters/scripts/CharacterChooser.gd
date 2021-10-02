extends Spatial

# var
export(String, "Adventurer", "Man", "ManAlternative", "Orc", "Robot", "Soldier", "Woman", "WomanAlternative") var CharacterType setget SetCharacterType, GetCharacterType
var dictionnaryCharacterTypeToResource = {
    "Adventurer" : preload("res://assets/prefabs/characters/materials/character_material_adventurer.tres"),
    "Man" : preload("res://assets/prefabs/characters/materials/character_material_man.tres"),
    "ManAlternative" : preload("res://assets/prefabs/characters/materials/character_material_man_alternative.tres"),
    "Orc" : preload("res://assets/prefabs/characters/materials/character_material_orc.tres"),
    "Robot" : preload("res://assets/prefabs/characters/materials/character_material_robot.tres"),
    "Soldier" : preload("res://assets/prefabs/characters/materials/character_material_soldier.tres"),
    "Woman" : preload("res://assets/prefabs/characters/materials/character_material_woman.tres"),
    "WomanAlternative" : preload("res://assets/prefabs/characters/materials/character_material_woman_alternative.tres"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
    SetupMaterials()
    
func SetupMaterials():
    #
    # Choose texture
    if CharacterType.empty():
        CharacterType = "Man"
    var materialToUse = dictionnaryCharacterTypeToResource[CharacterType]
    
    #
    # Setup material
    var iMaterialsCount = $character.get_surface_material_count()
    for iMaterialIndex in iMaterialsCount:
        $character.set_surface_material(iMaterialIndex, materialToUse)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func SetCharacterType(_CharacterType):
    CharacterType = _CharacterType
    
func GetCharacterType():
    return CharacterType
