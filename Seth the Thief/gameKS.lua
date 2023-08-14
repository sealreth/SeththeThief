Debug.Log("Hi")

Level.Load( "Game.tmx" )


---- VARIABELEN ----
-- Boundaries
bLeft = 32
bRight = 704
bUp = 32
bDown = 704

-- StartMessage
StartMessage = "Welcome to Destopia\nUse WASD to move.\nPickup items to earn points."

-- GameOver Timer
GameOverTimer = 60

--moveSpeed player
defaultMoveSpeed = 3.5
defaultStamina = 50
pause = false
m10Showed = false
m20Showed = false
m100Showed = false
staminaWillRecharge = true
---- END VARIABLES ----


player = {
  Pickup = 0,
  Score = 0,
  Health = 5,
  Hurt = false,
  Chests = 0,
  Stamina = defaultStamina,
}

enemiesPatrolling = {}
enemiesChasing = {}

sounds = {
  bump = Sound.Load( "bump.wav", false, false )
}


function Start()
  Hud.Message ( StartMessage, 5 )
  SpawnChest()

  --- Spawn 5 items ---
  for i = 1, 5 do
    SpawnItem()
  end
  ---------------------
  
  player.object = Level.GetObject( "Player" )
end

function Update()
  if not pause then
  DoPlayer()
  DoCamera()
  DoEnemies()
  DoHud()
  end
  CheckWinCondition()
  DoHints()

end

function DoPlayer()
  moved = Controller.Wasd( player.object, moveSpeed )
  if not moved then
    if not Sound.IsPlaying( playingBump ) then
      playingBump = Sound.Play( sounds.bump )
    end
  end
  if Input.GetKey ( 32 ) and player.Stamina > 0 then --space in
    player.Stamina = player.Stamina - 1
    moveSpeed = defaultMoveSpeed + 3  
    staminaWillRecharge = false
    Debug.Log("Test2")
    Timer.Start("StaminaWillRecharge", 3, true)   -- needs to be before the else, otherwise the timer keeps being reset
  else
    if staminaWillRecharge then
      player.Stamina = player.Stamina + 0.15
      if player.Stamina >= defaultStamina then
        player.Stamina = defaultStamina
      end
    end
    moveSpeed = defaultMoveSpeed
  end
end

function DoCamera()
  
  Camera.Follow ( player.object )
end

function DoEnemies()
  enemiesPatrolling = Level.GetObjects( "EnemyPatrol" )
  for i = 1, #enemiesPatrolling do
    enemyPatrol = enemiesPatrolling[ i ]
    moved = Controller.Patrol( enemyPatrol, 1.5 )
    if not moved then
      if not Sound.IsPlaying( playingBump ) then
        playingBump = Sound.Play( sounds.bump )
      end
    end
  end
  
  enemiesChasing = Level.GetObjects( "EnemyChasing" )
  for i = 1, #enemiesChasing do
    enemyChase = enemiesChasing[ i ]
    moved2 = Controller.Chase(enemyChase, player.object, 1)
    if not moved2 then
      if not Sound.IsPlaying( playingBump ) then
        playingBump = Sound.Play( sounds.bump )
      end
    end
  end
end
  
function DoHud()
  Hud.Health ( "HP " .. player.Health  .. "  NRG " .. math.ceil(player.Stamina))
  Hud.Score ( "Score " .. player.Score .. "  Items " .. player.Pickup)
end

function SpawnItem () --Spawning pick up items every X seconds with the Hit function.
  Level.Spawn ( "Item", 45, math.random(bLeft, bRight), math.random(bUp, bDown), "ItemHit" )
  end
function SpawnChest () --Spawing the chest every X seconds with the Chest function
  Level.Spawn ( "Chest", 46, math.random(bLeft, bRight), math.random(bUp, bDown), "ChestHit" )
  end
function SpawnEnemyPatrol ()
  Level.Spawn ( "EnemyPatrol", 31, math.random(bLeft, bRight), math.random(bUp, bDown), "EnemyHit" )
end

function SpawnEnemyChasing ()
  Level.Spawn ( "EnemyChasing", 30, math.random(bLeft, bRight), math.random(bUp, bDown), "EnemyHit" )
end

function ItemHit ( target, source ) -- The Pickups(keys) Can be picked up on collision, when having 5 you will lose all on gate for 100points, or you lose all if you pick up a 6th Pickup for 10 points.
 if Object.GetName ( target ) == "Player" then
 Level.RemoveObject(source)
 player.Pickup = player.Pickup + 1
 if player.Pickup >5 then
   --Hud.Message ( "My bag won't hold this many items!\nIt even attracted a Chaser\n:-(", 4 )
   player.Pickup = 0
   player.Score = player.Score + 10
   SpawnEnemyChasing()
   
  end
 SpawnItem()
 end
end

function ChestHit ( target, source ) -- The Gate, Can be openend wit each each 5 Pickups to give 100 points, will display a message when <5
  if Object.GetName (target ) == "Player" then
  target = player.object
  if player.Pickup == 5 then
    player.Chests = player.Chests + 1
    Level.RemoveObject ( source )
    player.Score = player.Score + 100
    player.Pickup = 0
    SpawnChest()
    if player.Chests == 5 then 
    SpawnEnemyChasing()
    player.Chests = 0
    else  
    SpawnEnemyPatrol()
    end
  else
    Hud.Message ( "I need more items\nbut I'd rather not have more then 5 when I open this chest.", 3)
  end
end
end

function EnemyHit ( target, source )
  if Object.GetName (target ) == "Player" then
    if not player.Hurt then
    player.Health = player.Health - 1
    Timer.Start ( "MayBeHurtAgain", 1.0, false )
  end
  player.Hurt = true
  end
end

function MayBeHurtAgain()
  player.Hurt = false
end

function CheckWinCondition()
  if player.Health <= 0 then  -- smaller or equals 0, if enemy causes 2 damage, your health could become -1 AND CRASSSHHHHH!
    pause = true
    Hud.Message ( "Good job, you died.\nYou're score is " .. player.Score .. "\nPress spacebar to play again.", 60)
    if Input.GetKey( 32 ) then
      UnPause()
      Hud.Message( StartMessage, 3 )
    end
  end
  end

function StaminaWillRecharge()
  staminaWillRecharge = true
  Debug.Log ("YEP TRUE")
  end

function UnPause()
    player.Chests = 0
    player.Health = 5
    player.Score = 0
    player.Hurt = false
    for i = 1, #enemiesPatrolling do     --for starting index (= 1) until endingnumber (= number of instances within the array enemiesPatrolling) do make variable enemyPatrol be the object at the index and delete it.
      enemyPatrol = enemiesPatrolling[ i ]
      Level.RemoveObject( enemyPatrol )
    end
    for i = 1, #enemiesChasing do
      enemyChase = enemiesChasing[ i ]
      Level.RemoveObject( enemyChase )
    end
    pause = false
  end
  
  function DoHints()
    if player.Score == 10 and m10Showed == false then --check whether the message has been showed or not.. otherwise it will show as long as the score is equal to ten.
      Hud.Message ("Try picking up the chest whenever\nyou hold 5 keys for more points.",5)
      m10Showed = true
    end
    if player.Score == 20 and m20Showed == false then
      Hud.Message ("Are you for real?\nMy bag won't hold this many items!\nIt even attracted another Chaser\n:-(",7)
      m20Showed = true
    end
    if player.Score >= 100 and m100Showed == false then
      Hud.Message ("Good job!\nKeep up the good work and\nyou might get a nice score!",6)
      m100Showed = true
    end
    
  end
