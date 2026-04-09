Untitled FPS Game
William L Lopez - 2026
williamlopez011602@gmail.com

TODO:
	* Redo file structure.
	* Ballance health and damage
	* Fix movement audio for sliding on moving platform and landing on vertical ones
	* projectile and enemy speed in water
	* more enemies
	* ability to pickup new weapons
	* more effects
	* better temp models

ERRORS:
	Error comes up when destroying a turret, I think it comes up when it also tries to create a bullet
		E 0:00:23:697   _flush_events: Condition "ref_count <= 0" is true. Continuing.<C++ Source>  modules/jolt_physics/objects/jolt_area_3d.cpp:159 @ _flush_events()
