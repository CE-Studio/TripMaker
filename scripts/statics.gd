class_name Statics
extends Node


enum BeatObjs {
	NORMAL,
	OVERLAP,
	SCALER,
	BOUNCER,
	JUGGLE,
	INVIS,
	WAVER,
	STUTTER,
	TRAIL,
	FOLLOW,
	ROTATOR,
	FIREWORK,
	GEO,
	STUNNER,
	AVOID,
	BONUS,
	POWERUP,
	NONE = -1,
}


const BEAT_DATA_DICT:Dictionary = {
	BeatObjs.NORMAL:   ["Normal Beat", Color.GOLD],
	BeatObjs.OVERLAP:  ["Overlapping Group", Color.GOLD],
	BeatObjs.SCALER:   ["Scaler Beat", Color.AQUA],
	BeatObjs.BOUNCER:  ["Bouncer Beat", Color.DARK_CYAN],
	BeatObjs.JUGGLE:   ["Juggle Beat", Color.DARK_ORANGE],
	BeatObjs.INVIS:    ["Invisibeat", Color.GREEN],
	BeatObjs.WAVER:    ["Waver Beat", Color.LIGHT_SEA_GREEN],
	BeatObjs.STUTTER:  ["Stutter Beat", Color.GOLD],
	BeatObjs.TRAIL:    ["Trail Beat", Color.GOLD],
	BeatObjs.FOLLOW:   ["Follow Beat", Color.LIGHT_YELLOW],
	BeatObjs.ROTATOR:  ["Rotator Structure", Color.HOT_PINK],
	BeatObjs.FIREWORK: ["Firework Beat", Color.BLUE],
	BeatObjs.GEO:      ["Geometry Structure", Color.GOLD],
	BeatObjs.STUNNER:  ["Stunner Beat", Color.RED],
	BeatObjs.AVOID:    ["Obstacle", Color.WHITE],
	BeatObjs.BONUS:    ["Bonus Beat", Color.WHITE],
	BeatObjs.POWERUP:  ["Powerup", Color.WHITE],
}
