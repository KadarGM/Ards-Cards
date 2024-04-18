extends Resource
class_name HeroDataResource

#region Enums
enum Race {
	Forest, Rusty, Black, Termite, Yellow, White
}
enum Specializations {
	Fighter, Archer, Sorcerer, Dark_wizard, Necromancer, Shaman, Rider_shooter, Elite, Rider
}
enum WhewCast {
	NULL, die, put, board, end_turn, start_turn
}
enum WhatCast {
	NULL, furry, evoke, add, destroy, shoot, wound, double_attack, triple_attack 
}
enum WhereCast {
	NULL, hand, deck, graveyard, board, enemy_hand, enemy_deck, enemy_graveyard, enemy_board
}
enum WhomCast {
	NULL, all, all_enemy, all_ally, any 
}
#endregion

@export_category("General")
@export_group("Main")
@export var hero_id: int
@export var name: String
@export_multiline var description: String
@export var race : Race
@export var prize: int
@export_node_path("Sprite2D") var picture

@export_subgroup("Creature Cast Data")
@export var when_cast : WhewCast
@export var when_repeat : int
@export var when_value : int
@export var what_cast : WhatCast
@export var what_repeat : int
@export var what_value : int
@export var where_cast : WhereCast
@export var where_repeat : int
@export var where_value : int
@export var whom_cast : WhomCast
@export var whom_repeat : int
@export var whom_value : int

@export_group("Global Stats")
@export var health: int
@export var defense: int
@export var attack: int
@export var specialization : Specializations
@export var will_cast : bool
