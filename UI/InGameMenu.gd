extends CanvasLayer

@onready var playerKilledTimer = $PlayerKilledTimer;
@onready var MouseSensSlider = $Settings/MS;
@onready var VolumeSlider = $Settings/Vol;

var menuUp = false;
var disableSave = false;

func _ready() -> void:
	SaveLoadManager.menuNode = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC"):
		toggleMenu();

func toggleMenu():
	if menuUp:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		menuUp = false;
		visible = false;
		get_tree().paused = false;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		menuUp = true;
		visible = true;
		get_tree().paused = true;


func _on_resume_button_pressed() -> void:
	toggleMenu();
func _on_save_button_pressed() -> void:
	if !disableSave:
		SaveLoadManager.saveGame();
func _on_load_button_pressed() -> void:
	SaveLoadManager.loadGame();
func _on_quit_button_pressed() -> void:
	get_tree().quit();

func _playerKilled():
	playerKilledTimer.start(1.0)

func _on_player_killed_timer_timeout() -> void:
	if menuUp == false:
		toggleMenu();
	disableSave = true;

func _on_ms_drag_ended(_value_changed: bool) -> void:
	GameData.MOUSESENSITIVITY = GameData.MOUSESENSITIVITYBASE * MouseSensSlider.value;

func _on_vol_drag_ended(_value_changed: bool) -> void:
	if VolumeSlider.value == -20:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), VolumeSlider.value)
	
