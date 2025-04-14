extends LimboHSM

@onready var enemy: Enemy = $".."
@onready var wandering: StateWithBT = $Wandering
@onready var aggro_d: StateWithBT = $"Aggro'd"
@onready var going_where_player_was_last_seen: StateWithBT = $"Going where player was last seen"
@onready var searching: StateWithBT = $Searching

func _add_transition(from, to): add_transition(from, to, from.event_assoc_to[to])

func _ready() -> void:
	_link()
	initialize(enemy)

func _link() -> void:
	_add_transition(wandering, aggro_d)
	_add_transition(aggro_d, going_where_player_was_last_seen)
	_add_transition(going_where_player_was_last_seen, aggro_d)
	_add_transition(going_where_player_was_last_seen, searching)
	_add_transition(searching, aggro_d)
	_add_transition(searching, wandering)
	_add_transition(wandering, searching)
