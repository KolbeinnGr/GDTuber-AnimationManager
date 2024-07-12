class_name AnimationInstance extends Animation

var source_image: ImageTexture
var name : String
var priority: int = 0
var uuid : int
var cells : Array[AnimationCell]

func _to_dict() -> Dictionary:
    var dict = {
        "source_image": self.source_image,
        "name": self.name,
        "priority": self.priority,
        "uuid": self.uuid,
    }
    var cells_dict = []
    for cell in self.cells:
        cells_dict.append(cell._to_dict())
    return dict

func _from_dict(data: Dictionary) -> void:
    # Check if the data is valid
    if data == null:
        return
    elif data.has_all(["source_image", "name", "priority", "uuid", "cells"]) == false:
        return

    self.source_image = data["source_image"]
    self.name = data["name"]
    self.priority = data["priority"]
    self.uuid = data["uuid"]
    
    for cell_data in data["cells"]:
        var cell = AnimationCell.new()
        cell._from_dict(cell_data)
        self.cells.append(cell)
