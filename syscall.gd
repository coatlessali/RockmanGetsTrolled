extends Node

var rng_lookup_table : Array[int] = [0]
var rng_index : int = 0

func _ready() -> void:
	generate_table()
	
func generate_table() -> void:
	print("generating rng table...")
	var a : Array[int] = [0]
	var c : int = 0
	while c < 127:
		c += 1
		var b : Array[int] = [c]
		a += b
	a.shuffle()
	rng_lookup_table = a
	print(rng_lookup_table)

func update_index() -> void:
	rng_index += 1
	if rng_index > len(rng_lookup_table):
		rng_index = 0 + rng_index - len(rng_lookup_table)

func get_rng() -> int:
	update_index()
	print(rng_lookup_table[rng_index])
	return rng_lookup_table[rng_index]
