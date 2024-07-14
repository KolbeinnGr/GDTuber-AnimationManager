class_name FileManager extends Node


func get_files_in_folder(folder_path: String) -> Array:
	var dir = DirAccess.get_files_at(folder_path)
	var files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			files.append(file_name)
			file_name = dir.get_next()
	return files

func get_files_that_begin_with(folder_path: String, prefix: String) -> Array:
	var dir = DirAccess.get_files_at(folder_path)
	var files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.begins_with(prefix):
				files.append(file_name)
			file_name = dir.get_next()
	return files

func get_specific_file(folder_path: String, file_name: String) -> String:
	var dir = DirAccess.get_files_at(folder_path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file == file_name:
				return file
			file = dir.get_next()
	print_debug("Error: Could not find file")
	return ""

func save_file(folder_path: String, file_name: String, data: Dictionary) -> bool:
	var file = FileAccess.open(folder_path + file_name, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		return true
	else:
		print("Error: Could not save file")
		return false

func load_file(folder_path: String, file_name: String) -> Dictionary:
	var file = FileAccess.open(folder_path + file_name, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		file.close()
		var data_dict = JSON.parse_string(data)
		return data_dict
	else:
		print("Error: Could not load file")
		return {}
