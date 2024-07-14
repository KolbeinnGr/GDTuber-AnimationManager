class_name AnimationInstance extends Animation

const FIELDS: Array[String] = ["source_image_path", "name", "priority", "uuid", "cells"]

var source_sprite : Sprite2D
var source_image_path: String
var name : String
var priority: int = 0
var uuid : int
var cells : Array[AnimationCell]

func _init() -> void:
	self.uuid = int(Time.get_unix_time_from_system())

func to_dict() -> Dictionary:
	var dict = {
		"source_image_path": self.source_sprite.resource_path,
		"name": self.name,
		"priority": self.priority,
		"uuid": self.uuid,
	}
	var cells_dict = []
	for cell in self.cells:
		cells_dict.append(cell.to_dict())
	
	dict["cells"] = cells_dict
	return dict

func from_dict(data: Dictionary) -> void:
	# Check if the data is valid
	if data == null:
		print_debug("Error: Animation data is null")
		return
	elif data.has_all(self.FIELDS) == false:
		print_debug("Error: Animation data is missing fields")
		return

	self.source_image_path = data["source_image_path"]
	self.source_sprite.texture = load(self.source_image_path)
	self.name = data["name"]
	self.priority = data["priority"]
	self.uuid = data["uuid"]
	
	for cell_data in data["cells"]:
		var cell = AnimationCell.new()
		cell._from_dict(cell_data)
		self.cells.append(cell)
