extends Node3D

@export var playerBody: PlayerBody;

@onready var startMovePlayer = $StartMovePlayer;
@onready var loopMovePlayer = $loopMovePlayer;
@onready var slideMovePlayer = $slideMovePlayer;
@onready var hitGroundPlayer = $hitGroundPlayer;
@onready var enterWaterPlayer = $EnterWaterPlayer;
@onready var exitWaterPlayer = $ExitWaterPlayer;

var playerMoving = false;
var wasStill = true;
var wasInAir = false;
var waterChange = false;
var waterLast = false;
var playerMovingGrace = 0.1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward");
	if input_dir:
		playerMoving = true;
		playerMovingGrace = 0.1;
	else:
		playerMovingGrace -= delta;
		if playerMovingGrace <= 0:
			playerMoving = false;
			wasStill = true;
	if !playerBody.is_on_floor():
		wasInAir = true;
	
	if playerBody.isInWater != waterLast:
		waterChange = true;
	
	_handleAudio();
	
	waterLast = playerBody.isInWater

func _handleAudio():
	if waterChange:
		waterChange = false;
		if playerBody.isInWater:
			if !enterWaterPlayer.playing and !exitWaterPlayer.playing:
				enterWaterPlayer.play();
		else:
			if !enterWaterPlayer.playing and !exitWaterPlayer.playing:
				exitWaterPlayer.play();
	
	if playerBody.is_on_floor() and !playerBody.isInWater:
		if wasInAir:
			wasInAir = false;
			if !hitGroundPlayer.playing:
				hitGroundPlayer.play()
		if playerMoving:
			if wasStill:
				if !startMovePlayer.playing:
					startMovePlayer.play();
			else:
				if !loopMovePlayer.playing:
					_stopAll()
					loopMovePlayer.play();
		elif playerBody.crouching and playerBody.velocity.length() > 6 and playerBody.floorVelocity.length() == 0:
			if !slideMovePlayer.playing:
				_stopAll()
				slideMovePlayer.play();
		else:
			_stopAll()
	else:
		_stopAll()

func _stopAll():
	startMovePlayer.stop();
	loopMovePlayer.stop();
	slideMovePlayer.stop();

func _on_start_move_player_finished() -> void:
	wasStill = false;
