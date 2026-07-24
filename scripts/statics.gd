class_name Statics
extends Node


static var editor_accepts_inputs:bool = true
static var level_load_path:String = ""


enum Attributes {
	BEAT = 0, TYPE = 1, X = 2, Y = 3, SPEED = 4, ANGLE = 5
}


const COLORS_TRANSITION:Array[Color] = [
	Color("fbf74b"),  #  0
	Color("2e9ca8"),  #  1
	Color("#00d200"), #  2
	Color("c44193"),  #  3
	Color("e578a6"),  #  4
	Color("00e5fc"),  #  5
	Color("009e91"),  #  6
	Color("7e82ff"),  #  7
	Color("0e0bed"),  #  8
	Color("fcce00"),  #  9
	Color("fff100"),  # 10
	Color("bef8fd"),  # 11
	Color("ffa400"),  # 12
	Color("ff1c00"),  # 13
]

const COLORS_MEGA:Array[Color] = [
	Color("ffa400"), # 0
	Color("fbf74b"), # 1
	Color("2e9ca8"), # 2
	Color("c44193"), # 3
	Color("e578a6"), # 4
	Color("009e91"), # 5
	Color("7e82ff"), # 6
	Color("fcce00"), # 7
	Color("bef8fd"), # 8
]

const COLORS_EXTRA:Array[Color] = [
	Color("ffd600"), # 0
	Color("ffaa2b"), # 1
	Color("2b9aa5"), # 2
	Color("e27ca6"), # 3
	Color("32377d"), # 4
]


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
