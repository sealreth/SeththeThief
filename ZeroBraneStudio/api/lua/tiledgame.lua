return {
	Camera = { 
		type = "lib",
		description = "For Controlling Objects",
		childs = {
			Follow = { 
				type = "function",
				description = "Lets the camera follow the object",
				args = "( Object *folowee )",
				returns = "",
			},
		},
	},	
	
	Controller = { 
		type = "lib",
		description = "For Controlling Objects",
		childs = {
			Chase = { 
				type = "function",
				description = "Lets the chaser head straight for the chasee with speed",
				args = "( Object chaser, Object chasee, Number speed )",
				returns = "Bool success",
			},
			Evade = { 
				type = "function",
				description = "Lets the Evader move away from the Evadee with speed",
				args = "( Object evader, Object evadee, Number speed )",
				returns = "Bool success",
			},
			Move = { 
				type = "function",
				description = "Move the Object x, y from it's current position",
				args = "( Object object, Number x, Number y )",
				returns = "Bool success",
			},
			Patrol = { 
				type = "function",
				description = "Lets the Object move trhough the level randomly",
				args = "( Object Object, Number speed )",
				returns = "Bool success",
			},
			Wasd = { 
				type = "function",
				description = "Lets the Object be controlled by wasd keys",
				args = "( Object object, float speed )",
				returns = "Bool success",
			},
		},
	},	
	
	Debug = { 
		type = "lib",
		description = "For Debug info",
		childs = {
			Log = { 
				type = "function",
				description = "Prints a message on console",
				args = "( String Message )",
				returns = "",
			},
		},
	},

	Hud = { 
		type = "lib",
		description = "For Debug info",
		childs = {
			Health = { 
				type = "function",
				description = "Show value on Health Hud",
				args = "( Number value )",
				returns = "",
			},
			Message = { 
				type = "function",
				description = "Show value on Message for given duration seconds",
				args = "( String message, Number duration )",
				returns = "",
			},
			Score = { 
				type = "function",
				description = "Show value on Score Hud",
				args = "( Number value )",
				returns = "",
			},
		},
	},
	
	Input = { 
		type = "lib",
		description = "Input info",
		childs = {
			GetKey = { 
				type = "function",
				description = "Check if key (ascii) s down",
				args = "( Number key )",
				returns = "Bool",
			},
		},
	},
	
	
	Level = { 
		type = "lib",
		description = "Level Manipulations",
		childs = {
			Fire = { 
				type = "function",
				description = "Aims and Fires from Parent a new Object with given tile id\nReturns the new Object",
				args = "( Object parent, String name, Number id, String trigger )",
				returns = "Object",
			},
	
			Spawn = { 
				type = "function",
				description = "Spawns a new Object at x,y position ( pixels ) with given name and tile id\nReturns the new Object",
				args = "( String name, Number id, Number x, Number y, String trigger )",
				returns = "Object",
			},

			GetObject = { 
				type = "function",
				description = "Find object with name\nReturns null if not found",
				args = "( String name )",
				returns = "Object",
			},

			GetObjects = { 
				type = "function",
				description = "Find objects with name\nReturns empty array if none found",
				args = "( String name )",
				returns = "(Array of Objects)",
			},

			InRange = { 
				type = "function",
				description = "Check if distance between objects < range",
				args = "( Object observer, Object observee, Number range )",
				returns = "Bool",
			},
			
			Load = { 
				type = "function",
				description = "Loads level with name in path assets/ ",
				args = "( Sting tmxfile )",
				returns = "",
			},
			
			RemoveObject = { 
				type = "function",
				description = "Removes object from the level and destroys it",
				args = "( Object object )",
				returns = "",
			},
		},
	},
	
	
	Object = { 
		type = "lib",
		description = "Object manipulation",
		childs = {
			Move = { 
				type = "function",
				description = "Moves the object with x,y pixels per frame\nReturns false if anything is hit",
				args = "( Object object, Number x, Number y )",
				returns = "(Bool success)",
			},
			GetName = { 
				type = "function",
				description = "Returns the name of the object",
				args = "( Object object )",
				returns = "(String name)",
			},
			GetPosition = { 
				type = "function",
				description = "Returns the position x,y of the object",
				args = "( Object object )",
				returns = "(Number x, Number y)",
			},
			Forward = { 
				type = "function",
				description = "Forwards the object with speed pixels/frame in it's current direction\nReturns false if anything is hit",
				args = "( Object object, Number speed )",
				returns = "(Bool success)",
			},
			Property = { 
				type = "function",
				description = "Returns the property whith the given name for the object",
				args = "( Object object, String property name )",
				returns = "(String property)",
			},
		},
	},
	
	Sound = { 
		type = "lib",
		description = "Sound manipulations",
		childs = {
			Load = { 
				type = "function",
				description = "Loads sound  with name",
				args = "( String name, Bool looping, Bool streaming )",
				returns = "(Sound sound)",
			},
			Play = { 
				type = "function",
				description = "Plays the sound in a channel",
				args = "( Sound sound )",
				returns = "(SoundChannel channel)",
			},
			IsPlaying = { 
				type = "function",
				description = "Checks is channel is still playing",
				args = "( SoundChannel channel )",
				returns = "(Bool isPlaying)",
			},
			Stop = { 
				type = "function",
				description = "Stopt the channel playing",
				args = "( SoundChannel channel )",
				returns = "",
			},
		},
	},
	
	Timer = { 
		type = "lib",
		description = "Timer things",
		childs = {
			Start = { 
				type = "function",
				description = "Starts a timer resulting in a timeout call to function name\nReturns the created timer",
				args = "( String name, Number interval, Bool repeat )",
				returns = "(Timer timer)",
			},
			Stop = { 
				type = "function",
				description = "Stops the running timer and destroys the timer",
				args = "( Timer timer )",
				returns = "",
			},
		},
	},

	
}

