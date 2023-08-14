Debug.Log("Hi")

Level.Load( "Game.tmx" )

player = {
  object = nil,
  score = 0,
  health = 100,
  hurtable = true,
  shootable = true;
}

steps = {
}


function Start()
  player.object = Level.GetObject( "Player" )
  Timer.Start( "SpawnEnemy", 1, false )
  Hud.Message("START", 5 )
end

function Update() -- using convienient functions
  DoPlayer()
  DoBullets()
  DoEnemies()
  DoCamera()
  DoHud()
end

function DoBullets()
  bullets = Level.GetObjects( "Bullet" )
  for i=1, #bullets do
    if not Object.Forward( bullets[i], 2 ) then 
        Level.RemoveObject( bullets[i] )
    end
  end
end

function DoCamera()
	Camera.Follow( player.object )
end

function DoEnemies()
  enemies = Level.GetObjects( "Enemy" )
  for k, enemy in pairs( enemies ) do
--  for i = 1, #enemies do

-- some tries
    --Controller.Patrol( enemy, 3 )
    --Object.Move( enemy, -2.5 + math.random() * 5, -2.5 + math.random() * 5 )
    --moved = Object.Forward( enemy, 3 )

   -- chase the player and if stuck move randomly for a number f steps and then continue chasing 
    px, py = Object.GetPosition( player.object )
    ex, ey = Object.GetPosition( enemy )
    dx = px - ex -- difference in x position
    dy = py - ey -- difference in y position
    
    if dx > 3 then -- maximize speed to 3
      dx = 3
    end
    if dx < -3 then -- minimize speed to -3
      dx = -3
    end
    if dy > 3 then dy = 3 end -- maximize speed to 3
    if dy < -3 then dy = -3 end -- minimize speed to -3
    
    if steps[ enemy ] == nil or steps[ enemy ] == 0 then -- if no evasive steps left or unknown
      moved = Object.Move( enemy, dx, dy ) -- move towards player
      if not moved then -- if not able to move
        steps[ enemy ] = 25 + math.random( 75 ) -- for a number of steps /frames move in a random dir (25-100 steps )
        moved = Object.Move( enemy, -2 + math.random() * 4, -2 + math.random() * 4 ) -- move in a random dir, this sets the enemy its dir
      end
    else-- move random dir for steps
      steps[ enemy ] = steps[ enemy ] - 1 -- reduce steps left for 
      moved = Object.Forward( enemy, 3 ) -- continue moving in forward dir
    end
  
  end
  
end

function DoPlayer()
	moved = Controller.Wasd( player.object, 5 ) -- control player by wasd
  if Input.GetKey(32) and player.shootable then -- if space then shoot when enabled
    Level.Fire( player.object, "Bullet", 45, "Hit" ) -- spawn the bullet
    player.shootable = false -- disable shooting
    Timer.Start( "EnableShooting", 0.5, false ) -- timeout after 0.5 sec
  end
end

function DoHud() -- refresh hud values
  Hud.Health( "HEALTH "..player.health)
  Hud.Score( "SCORE "..player.score )
end




-- Triggers

-- wehen enemy hits something
function Byte( target, source )
  if  target == player.object then -- hitting player ?
    Debug.Log("Byte")
  end
end


-- Timeouts


function EnableShooting()
  player.shootable = true -- player can now shoot again
end

function SpawnEnemy()
  Level.Spawn( "Enemy", 46, 32, 32, "Byte" ) -- spawn enemy on timeout
  Timer.Start( "SpawnEnemy", math.random( 4, 10 ), false ) -- start timer for next enemy to spawn
end


