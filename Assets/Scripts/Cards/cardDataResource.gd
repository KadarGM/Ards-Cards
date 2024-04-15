extends Resource
class_name CardDataResource

#region Enums
enum Race {
	Forest, Rusty, Black, Termite, Yellow, White
}
enum Type {
	AttackCreature, DefendCreature, Artefact, Action, Spell, AttackElite, DefendElite, Hero 
}
enum Type_spell {
	Spell, Action, Artefact
}
enum Heroes {
	NULL
}
enum Elites {
	NULL
}
enum Specializations {
	Fighter, Archer, Sorcerer, Dark_wizard, Necromancer, Shaman, Rider_shooter, Elite, Rider
}
enum Spells {
	Enhance, Surface_enhance, Heal, Draw, Surface_heal, Destructive, Surface_destructive, Worm
}
enum Instants {
	Destructive, Enhance
}
enum Artefacts {
	Enhance, Heal
}
#endregion

@export_category("General")
@export_group("Main")
@export var type : Type
@export var name: String
@export_multiline var description: String
@export var race : Race
@export_node_path("Sprite2D") var picture

@export_group("Separate Stats")
@export_subgroup("Hero")
@export var mana_max : int
@export var mana_cur : int

@export_subgroup("Creature")
@export var hero : Heroes
@export var elite : Elites

@export_subgroup("Spells")
@export var type_spell : Type_spell
@export var spell : Spells
@export var instants : Instants
@export var artefacts : Artefacts

@export_group("Global Stats")
@export var mana_cost : int
@export var health: int
@export var defense: int
@export var attack: int
@export var specialization : Specializations
@export var has_spell : int

