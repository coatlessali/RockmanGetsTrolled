extends Node

const table_size = 128

var rng_lookup_table : Array[int] = [0]
var rng_index : int = 0


func _ready() -> void:
	generate_table()
	rng_index = rng_lookup_table.size() # account for increment
	
func generate_table() -> void:
	print("generating rng table...")
	var a : Array[int] = [0]
	var c : int = 0
	while c < (table_size - 1):
		c += 1
		var b : Array[int] = [c]
		a += b
	a.shuffle()
	rng_lookup_table = a
	print(rng_lookup_table)

func update_index() -> void:
	rng_index = (rng_index + 1) % rng_lookup_table.size()

func get_rng() -> int:
	update_index()
	return rng_lookup_table[rng_index]
