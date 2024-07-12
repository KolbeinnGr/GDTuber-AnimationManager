extends Control

@onready var animation_manager : AspectRatioContainer = $"."
@onready var image : Sprite2D = %SpriteImage
@onready var center_container : Control = %CenterContainer
@onready var rows_text: LineEdit = %RowsText
@onready var cols_text: LineEdit = %ColsText
@onready var animation_list: ItemList = %AnimationList
@onready var file_dialog: FileDialog = %FileDialog
@onready var file_dialog_button: Button = %FileDialogButton
@onready var frames_container: HBoxContainer = %FramesContainer
@onready var name_text_edit: LineEdit = %NameTextEdit


var rows : int = 2
var columns : int = 2
var should_redraw_cells : bool = false
var image_size : Vector2
var animations : Animation
var animations_folder : String = "res://animations/"

var cells : Array[AnimationCell] = []
var openingfor : Sprite2D


func _ready():
	if self.animation_manager == null:
		animation_manager = get_node("AnimationManager")
		if animation_manager == null:
			print("AnimationManager node not found!")
	animation_manager.visible = false
	
	if animation_list:
		self.animation_list.custom_minimum_size = Vector2(200, 300)
		_load_saved_animations()
	if file_dialog_button:
		file_dialog_button.connect("pressed", _on_file_button_button_down)
	if file_dialog:
		file_dialog.connect("file_selected", _on_file_dialog_file_selected)
	if rows_text:
		rows_text.text = str(rows)
	if cols_text:
		cols_text.text = str(columns)

	_draw_cells()

func _process(_delta):
	if self.should_redraw_cells:
		_draw_cells()
		self.should_redraw_cells = false

func _draw_cells():
	if !image:
		print("Image is not assigned")
		return

	image_size = image.texture.get_size()
	var cell_width : int = image_size.x / columns
	var cell_height : int = image_size.y / rows
	var counter : int = 0

	for i in range(rows):
		for j in range(columns):
			# check if the cell has already been created if so, update the cell, otherwise create a new cell
			var cell
			var new_pos : Vector2 = Vector2(image.position.x - image_size.x/2 + j * cell_width, image.position.y - image_size.y/2 + i * cell_height)
			if cells.size() > counter:
				cell = cells[counter]
				cell.update_cell(i, j, cell_width, cell_height, new_pos, counter)
			else:
				cell = AnimationCell.new()
				cell.update_cell(i, j, cell_width, cell_height, new_pos, counter)
				cell.connect("redraw_cells", _on_redraw_cells)
				cell.connect("pressed_animation_cell", _on_pressed_animation_cell)
				cells.append(cell)
				center_container.add_child(cell)
				
			counter += 1

func _on_animation_manager_button_pressed():
	animation_manager.visible = !animation_manager.visible

func _on_rows_add_button_pressed() -> void:
	self.rows += 1
	_update_rows_cols_texts()

func _on_rows_sub_button_pressed() -> void:
	if self.rows > 1:
		self.rows -= 1
		_update_rows_cols_texts()

func _on_cols_sub_button_pressed() -> void:
	if self.columns > 1:
		self.columns -= 1
		_update_rows_cols_texts()

func _on_cols_add_button_pressed() -> void:
	self.columns += 1
	_update_rows_cols_texts()

func _update_rows_cols_texts():
	if rows_text:
		rows_text.text = str(rows)
	if cols_text:
		cols_text.text = str(columns)

	# when the rows or columns are updated, we need to delete all the cells and lines and redraw them
	for cell in cells:
		cell.queue_free()
	cells.clear()
	_draw_cells()

func _on_file_button_button_down():
	# Set the requestor (image) and show the file dialog
	openingfor = image
	file_dialog.popup_centered()

func _on_file_dialog_file_selected(path):
	if openingfor:
		var img = Image.new()
		var err = img.load(path)
		if err != OK:
			print("Failed to load image")
			return

		var texture = ImageTexture.create_from_image(img)
		openingfor.texture = texture
		self.image.texture = texture
		
		self.should_redraw_cells = true

func _load_saved_animations():
	# Load the saved animations from the folder and populate the animation list
	var dir = DirAccess.open(animations_folder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with("animation_"):
				print("Loading animation: " + file_name)
				_load_animation_from_file(animations_folder + file_name)
			else:
				print("Skipping file: " + file_name)
			file_name = dir.get_next()
	else:
		print("Failed to open directory: " + animations_folder)

func _on_redraw_cells():
	self.should_redraw_cells = true

func _on_pressed_animation_cell(uid: int):
	var selected_cell = cells[uid]

	selected_cell.selected = !selected_cell.selected
	if selected_cell.selected:
		# get the rect of the selected cell
		var atlas_texture = AtlasTexture.new()
		var atlas_rect = selected_cell.rect
		atlas_texture.atlas = image.texture
		atlas_texture.region = atlas_rect
		
		var new_sprite = Sprite2D.new()
		new_sprite.name = str(uid)
		new_sprite.texture = atlas_texture
		new_sprite.scale = Vector2(2,2)

		# add the new sprite to the frames container
		var sprite_container = CenterContainer.new()
		sprite_container.custom_minimum_size = Vector2(selected_cell.width, selected_cell.height) * new_sprite.scale
		sprite_container.add_child(new_sprite)
		
		frames_container.add_child(sprite_container)
	else:
		# remove the sprite from the frames container
		for frame in frames_container.get_children():
			for child in frame.get_children():
				if child.name == str(uid):
					frame.queue_free()


func _on_save_button_pressed() -> void:
	print("Saving")
	var new_animation : AnimationInstance = AnimationInstance.new()
	new_animation.name = name_text_edit.text
	new_animation.source_image = image.texture
	new_animation.cells = cells
	#generate a new uuid using the current time
	new_animation.uuid = int(Time.get_unix_time_from_system())

	# save the animation to a file using resourceSaver
	var result = ResourceSaver.save(new_animation, animations_folder + "animation_" + str(new_animation.uuid) + ".tres")

	if result == OK:
		print("Animation saved successfully with id: ", new_animation.uuid)
	else:
		print("Failed to save animation")


01,3
func _load_animation_from_file(path: String) -> AnimationInstance:

	var animation : AnimationInstance = ResourceLoader.load(path)
	print("Loaded animation: " + animation.name)
	print("UUID: " + str(animation.uuid))
	print("Cells: " + str(animation.cells.size()))
	return animation
 6æ7ujK(ÞIL
 -