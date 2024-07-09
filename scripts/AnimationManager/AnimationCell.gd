class_name AnimationCell extends Button

signal redraw_cells
signal pressed_animation_cell

var row : int
var col : int
var width : int
var height : int
var selected : bool = false
var button_style : StyleBoxFlat = StyleBoxFlat.new()
var uid : int

func _ready():
	self.button_style.set_border_width_all(1)
	self.button_style.border_color = Color.WHITE
	self.add_theme_stylebox_override("normal", button_style)
	self.button_style.bg_color = Color(1, 1, 1, 0.0)
	connect("pressed", _on_pressed_animation_cell)

func update_cell(_row: int, _col : int, _width: int, _height: int, new_position: Vector2, new_uid: int) -> void:
	self.row = _row
	self.col = _col
	self.width = _width
	self.height = _height
	self.position = new_position
	self.uid = new_uid
	
	# set the size and color of the button
	self.custom_minimum_size = Vector2(self.width, self.height)
	if self.selected:
		self.button_style.bg_color = Color(1, 1, 1, 0.5)
	else:
		self.button_style.bg_color = Color(1, 1, 1, 0.0)

	emit_signal("redraw_cells")

func is_selected() -> bool:
	return self.selected

func _on_pressed_animation_cell() -> void:
	self.selected = !self.selected
	emit_signal("redraw_cells")
	pressed_animation_cell.emit(self.uid)
