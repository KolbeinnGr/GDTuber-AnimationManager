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
var rect : Rect2

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
	self.rect = Rect2(Vector2.ZERO + Vector2(_width * _col, _row * _height), Vector2(_width, _height))
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
	pressed_animation_cell.emit(self.uid)
	emit_signal("redraw_cells")
