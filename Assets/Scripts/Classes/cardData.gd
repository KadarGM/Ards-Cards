extends Node

#region Enums
enum Race {
	N,Forest, Rusty, Black, Termite, Yellow, White
}
enum Heroes {
	N,ULL
}
enum Types {
	N,Attack, Defend
}
enum Specializations {
	N, Fighter, Archer, Sorcerer, Dark_wizard, Necromancer, Shaman, Rider_shooter, Elite, Rider
}
enum Spells {
	N, Enhance, Surface_enhance, Heal, Draw, Surface_heal, Destructive, Surface_destructive, Worm
}
enum Instants {
	N, Destructive, Enhance
}
enum Artefacts {
	N, Enhance, Heal
}
enum Kind {
	Creature, Spell, Instant, Artefact
}
#endregion

@export_category("General")
@export_group("Main")
@export var kind : Kind
@export var name_value: String
@export_placeholder("Placeholder") var hoover_text: String = "Placeholder"
@export_multiline var description: String = ""
@export var race : Race
@export var heroes : Heroes
@export var mana_value: int

@export_group("Stats")
@export_subgroup("Creature_stats")
@export var health_value: int
@export var defense_value: int
@export var attack_value: int
@export var type : Types
@export var specialization : Specializations

@export_subgroup("Actions and spells stats")
@export var spell : Spells
@export var instants : Instants
@export var artefacts : Artefacts

@export_group("Paths")
@export_subgroup("Nodes")
@export_node_path("Sprite2D") var picture

@export_subgroup("Directories")
@export_dir var sprite_folder : String

@export_subgroup("Files")
@export_file var sprite_file : String

@export_group("Colors")
@export_color_no_alpha var modulate_color : Color
