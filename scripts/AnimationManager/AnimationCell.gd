class_name AnimationCell extends Button

@onready var animation_manager

var _row : int
var _col : int
var _width : int
var _height : int

var selected : bool = false
var button_style : StyleBoxFlat = StyleBoxFlat.new()


func _ready():
	self.button_style.set_border_width_all(1)
	self.button_style.border_color = Color.WHITE
	self.add_theme_stylebox_override("normal", button_style)
	self.button_style.bg_color = Color(1, 1, 1, 0.0)

	connect("pressed", _on_pressed_animation_cell)

func update_cell(row: int, col : int, width: int, height: int, new_position: Vector2) -> void:
	self._row = row
	self._col = col
	self._width = width
	self._height = height
	self.position = new_position
	
	# set the size and color of the button
	self.custom_minimum_size = Vector2(self._width, self._height)
	if self.selected:
		self.button_style.bg_color = Color(1, 1, 1, 0.5)
	else:
		self.button_style.bg_color = Color(1, 1, 1, 0.0)

	# Get the animation manager node and set the redraw_cells flag to true
	if animation_manager:
		animation_manager.redraw_cells = true

func is_selected() -> bool:
	return self.selected

func _on_pressed_animation_cell() -> void:
	self.selected = !self.selected
	animation_manager.redraw_cells = true
