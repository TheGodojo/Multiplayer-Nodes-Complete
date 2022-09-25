extends MeshInstance3D

var speed = 10
var mouse_sensitivity = 0.5

@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer

func _ready():
	synchronizer.set_multiplayer_authority(str(name).to_int())
	camera.current = synchronizer.is_multiplayer_authority()

func _physics_process(delta):
	if synchronizer.is_multiplayer_authority():
		var direction = Vector3.ZERO
		if Input.is_key_pressed(KEY_W): direction -= global_transform.basis.z
		elif Input.is_key_pressed(KEY_S): direction += global_transform.basis.z
		if Input.is_key_pressed(KEY_A): direction -= global_transform.basis.x
		elif Input.is_key_pressed(KEY_D): direction += global_transform.basis.x
		
		global_position += direction.normalized() * speed * delta
		synchronizer.position = global_position



func _input(event):
	if synchronizer.is_multiplayer_authority():
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-deg2rad(event.relative.x) * mouse_sensitivity)
			synchronizer.y_rotation = rotation.y
			camera.rotate_x(-deg2rad(event.relative.y) * mouse_sensitivity)
