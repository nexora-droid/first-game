extends Panel
const drawing_area := Rect2(Vector2(0, 115), Vector2(308, 480))
var points = []
var last_pos: Vector2 = Vector2.INF
var drawing:= false
var http_request : HTTPRequest = null
var url := "https://godot-image-model.onrender.com/predict"
var classname: String 
var probability: String
func _ready() -> void:
	$"..".connect("panel_visible", Callable(self, 'reset_panel'))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drawing = event.pressed
		last_pos = Vector2.INF
		if drawing:
			points.append(event.position)
			last_pos = event.position
			self.queue_redraw()
		return	
	if not drawing:
		return
	if not Rect2(Vector2.ZERO, size).has_point(event.position):
		last_pos = Vector2.INF
		return
	if last_pos != Vector2.INF:
		var distance = last_pos.distance_to(event.position)
		var steps = max(1, int(distance/1))
		for i in range(steps + 1):
			points.append(last_pos.lerp(event.position, float(i) /steps))
	else:
		points.append(event.position)
	last_pos = event.position
	self.queue_redraw()
func _draw() -> void:
	for point in points:
		draw_circle(point, 5, Color.WHITE)

func reset_panel()->void:
	points.clear()
	queue_redraw()


func _on_button_pressed() -> void:
	reset_panel()

func _get_drawing_img() -> Image:
	var viewport = get_viewport()
	var full_img = viewport.get_texture().get_image()
	full_img.flip_y()
	var global_rect = Rect2(
		global_position + drawing_area.position,
		drawing_area.size
	)
	return full_img.get_region(global_rect)

func prepare_for_model(img: Image) -> Image:
	img.resize(224, 224, Image.INTERPOLATE_LANCZOS)
	img.convert(Image.FORMAT_RGB8)
	return img
	
func send_to_server(img: Image) -> void:
	print("Sending to server...")
	var png_bytes = img.save_png_to_buffer()
	var base64_str = Marshalls.raw_to_base64(png_bytes)
	var json_body = {"image": base64_str}
	var body_bytes = JSON.stringify(json_body).to_utf8_buffer()
	var request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", Callable(self, "_on_request_completed"))
	request.request_raw(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body_bytes)
	
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Request Completed - Result: ", result, "Code: ", response_code)
	print("Response: ", body.get_string_from_utf8())
	if http_request:
		http_request.queue_free()
	if response_code != 200:
		print("Server Error: ", response_code)
		return
	var json_result = JSON.parse_string(body.get_string_from_utf8())
	if json_result == null:
		print("Failed to parse JSON response")
		return
	probability = (String.num(json_result["probability"], 2))
	classname = String(json_result["className"])
	cast_spell(classname, probability)
	print("Predicted class:", json_result["className"], " Probability:", json_result["probability"])

func _on_button_2_pressed() -> void:
	var img = prepare_for_model(_get_drawing_img())
	send_to_server(img)

func cast_spell(shape: String, confidence: String) -> void:
	return
