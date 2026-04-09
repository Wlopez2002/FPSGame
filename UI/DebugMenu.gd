extends VBoxContainer



func _on_debug_info_but_toggled(toggled_on: bool) -> void:
	GameData.debugInfo = toggled_on

func _on_god_mode_but_toggled(toggled_on: bool) -> void:
	GameData.godMode = toggled_on

func _on_no_clip_but_toggled(toggled_on: bool) -> void:
	GameData.noClip = toggled_on
