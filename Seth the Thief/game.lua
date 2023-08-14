Debug.Log("Hi") --log into output 

Level.Load( "Game.tmx" ) -- loading tiled file


---- VARIABELEN ----
-- Boundaries
bLeft = 32
bRight = 704
bUp = 32
bDown = 704

-- StartMessage
StartMessage = "Steal Monkey tech\nUse WASD to move and E to Sprint.\nPickup Disks and bring them to the chests for points\nAnd avoid the spawning Enemys."

-- GameOver Timer
GameOverTimer = 60

--moveSpeed player
BombScore = 2000
defaultMoveSpeed = 3.5
defaultStamina = 50
pause = false
m10Showed = false
m20Showed = false
m100Showed = false
m1500Showed = false
m2000Showed = false
m3000Showed = false
m4000Showed = false
m5000Showed = false
m9000Showed = false
--scoreBomb = false
--score2000 = false
staminaWillRecharge = true

--Player array--
player = {
  Pickup = 0,
  Score = 0,
  Health = 5,
  Hurt = false,
  Chests = 0,
  Bomb = 0,
  Stamina = defaultStamina,  
}

--Other arrays all contain object = nil
enemiesPatrolling = {}
enemiesChasing = {}
Bombs = {}


--Start
function Start()
  Hud.Message ( StartMessage, 15 )
  SpawnChest()

  --- Spawn 5 items ---
  for i = 1, 5 do
    SpawnItem()
  end
  ---------------------
  --Loading Sounds, not streaming need to use them instantly, nor looping
  chest = Sound.Load( "chest.wav", false, false )
  disk = Sound.Load( "disk.wav", false, false )
  gameover = Sound.Load( "gameover.wav", false, false)
  enemyhit = Sound.Load( "enemyhit.wav", false, false )
  bomb = Sound.Load( "bomb.wav", false, false )
  locked = Sound.Load( "locked.wav", false, false )
  beep = Sound.Load( "beep.wav", false, false )
  player.object = Level.GetObject( "Player" )
end

--Update function which calles uppon functions
function Update() 
  if not pause then
  DoPlayer()
  DoCamera()
  DoEnemies()
  DoHud()
  DoBomb()
  DoHints()
  
end
  CheckWinCondition()
  
  

end

--Things concerning the playeble character
function DoPlayer()

  Controller.Wasd( player.object, moveSpeed )
    if Input.GetKey ( 69 ) and player.Stamina > 0 then --space in
    player.Stamina = player.Stamina - 1
    moveSpeed = defaultMoveSpeed + 3  
    staminaWillRecharge = false
    --Debug.Log("Test2")
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

--Camara behaviour
function DoCamera()
  
  Camera.Follow ( player.object )
end

--Things concerning the Bomb/wall object
function DoBomb()
  Bombs = Level.GetObjects( "PlaceBomb")
  for i = 1, #Bombs do
    placeBomb = Bombs[ i ]
  end
end


--Things concerning enemies
function DoEnemies() --Behaviours of enemies (patrol and chase)
  enemiesPatrolling = Level.GetObjects( "EnemyPatrol" )
  for i = 1, #enemiesPatrolling do
    enemyPatrol = enemiesPatrolling[ i ]
    Controller.Patrol( enemyPatrol, 2 )
  end
  
  enemiesChasing = Level.GetObjects( "EnemyChasing" )
  for i = 1, #enemiesChasing do
    enemyChase = enemiesChasing[ i ]
    Controller.Chase(enemyChase, player.object, 1.5)
  end
end
  
--Things concerning the Hud
function DoHud()
  Hud.Health ( "HP " .. player.Health  .. "  NRG " .. math.ceil(player.Stamina))
  Hud.Score ( "Score " .. player.Score .. "  Disc's " .. player.Pickup)
end

------ SPAWNING OF STUFF -------
function SpawnItem ()
  if not Walkable then
  Level.Spawn ( "Item", 45, math.random(bLeft, bRight), math.random(bUp, bDown), "ItemHit" )
end
end
function SpawnChest ()
  if not Walkable then
  Level.Spawn ( "Chest", 46, math.random(bLeft, bRight), math.random(bUp, bDown), "ChestHit" )
end
end
function SpawnEnemyPatrol ()
  if not Walkable then
  Level.Spawn ( "EnemyPatrol", 31, math.random(bLeft, bRight), math.random(bUp, bDown), "EnemyHit" )
end
end

function SpawnEnemyChasing ()
  if not Walkable then
  Level.Spawn ( "EnemyChasing", 30, math.random(bLeft, bRight), math.random(bUp, bDown), "EnemyHit" )
end
end

function SpawnBomb ()
  if not Walkable then
  Level.Spawn ( "PlaceBomb", 37, math.random(bLeft, bRight), math.random(bUp, bDown), "BombHit" )
  Debug.Log ("Bomb spawned")
end
end

------ TRIGGERS ----------------
function ItemHit ( target, source )
 if Object.GetName ( target ) == "Player" then
 Level.RemoveObject(source)
 Sound.Play (disk)
 player.Pickup = player.Pickup + 1
 if player.Pickup >5 then
   --Hud.Message ( "My bag won't hold this many items!\nIt even attracted a Chaser\n:-(", 4 )
   player.Pickup = 0
   player.Score = player.Score + 10
   --player.Bomb = player.Bomb + 10
   Sound.Play (beep)
   SpawnEnemyChasing()   
  end
 SpawnItem()
 end
end

function ChestHit ( target, source )
  if Object.GetName (target ) == "Player" then
  target = player.object
  if player.Pickup == 5 then
    player.Chests = player.Chests + 1
    Level.RemoveObject ( source )
    Sound.Play (chest)
    player.Bomb = player.Bomb + 100
    player.Score = player.Score + 100
    player.Pickup = 0
    SpawnChest()
    if player.Chests == 10 then 
    SpawnEnemyChasing()
    Hud.Message ( "Nice job! but a chaser is now following you!\nAt every 20 chests bomb will spawn which you can use for 1000 points and 5 disks", 10)
    player.Chests = 0
    else  
    SpawnEnemyPatrol()
    end
  else
    if not Sound.IsPlaying( playlocked ) then
      playlocked = Sound.Play( locked )
    Hud.Message ( "I need more disks\nbut I'd rather not have more then 5 when I open this chest.", 7)
  end
  end
end
end

function EnemyHit ( target, source )
  if Object.GetName (target ) == "Player" then
    if not player.Hurt then
    player.Health = player.Health - 1
    Sound.Play (enemyhit)
    Timer.Start ( "MayBeHurtAgain", 1.0, false )
  end
  player.Hurt = true
  end
end


function BombHit ( target, source )
 if Object.GetName ( target ) == "Player" then
      target = player.object
    if player.Pickup == 5 and player.Score >= 1000 then
      Level.RemoveObject(source)
      Sound.Play (bomb)
      player.Pickup = 0
      -- starting index (= 1) until endingnumber (= number of instances within the array enemiesPatrolling) do make variable  enemyPatrol be the object at the index and delete it.
      for i = 1, #enemiesPatrolling do 
      enemyPatrol = enemiesPatrolling[ i ]
      Level.RemoveObject( enemyPatrol )
      end
      for i = 1, #enemiesChasing do
      enemyChase = enemiesChasing[ i ]
      Level.RemoveObject( enemyChase )
      end
      Hud.Message ("Ninja bomb activated!, The Monkeys sensors are gone, but so are 1000 of my points", 10)
      player.Score = player.Score - 1000
      player.Pickup = 0
    else
      if not Sound.IsPlaying( playlocked ) then
      playlocked = Sound.Play( locked )
      Hud.Message ("I need 5 disk to use this!, But if I do this it will cost me a 1000 points.", 10)
    end
  end
end
end
--Checking if the game is to end
function CheckWinCondition()
  if player.Health <= 0 then  -- smaller or equals 0, if enemy causes 2 damage, your health could become -1 AND CRASSSHHHHH!
    Sound.Play (gameover)
    pause = true
    Hud.Message ( "Good job, The monkeys captured you.\nYou're score is " .. player.Score .. "\nPress spacebar to play again.", 60)
    if Input.GetKey( 32 ) then
      UnPause()
      Hud.Message( StartMessage, 5 )
    end
  end
  end

--can be called to set player to vulnerble again
function MayBeHurtAgain()
  player.Hurt = false
end

--can be called to spawn bomb
function DoBomb ( target, source )
  if player.Bomb >= BombScore then --scoreBomb == false then
    player.Bomb = 0    
    SpawnBomb ()
    --scoreBomb = true
  end
end

--Can be called to set player enegy regenrating back on
function StaminaWillRecharge()
  staminaWillRecharge = true
  --Debug.Log ("YEP TRUE")
  end

--Game ove function (reset to defaut)
function UnPause()
    player.Chests = 0
    player.Pickup = 0
    player.Health = 5
    player.Bomb = 0
    player.Score = 0
    player.Hurt = false
    for i = 1, #enemiesPatrolling do     
      enemyPatrol = enemiesPatrolling[ i ]
      Level.RemoveObject( enemyPatrol )
    end
    for i = 1, #enemiesChasing do
      enemyChase = enemiesChasing[ i ]
      Level.RemoveObject( enemyChase )
    end    
    pause = false
  end
  
--Hud. message tooltips at certain scores
function DoHints()
    if player.Score == 10 and m10Showed == false then --check whether the message has been showed or not.. otherwise it will show as long as the score is equal to ten.
      Hud.Message ("Try picking up the chest whenever\nyou hold 5 disks for more points.",7)
      m10Showed = true
    end
    if player.Score == 20 and m20Showed == false then
      Hud.Message ("Are you for real?\nMy bag won't hold this many disks!\nIt even attracted another Chaser\n:-(",7)
      m20Showed = true
    end
    if player.Score >= 500 and m100Showed == false then
      Hud.Message ("Good job!\nKeep up the good work and\nyou might get a nice score!",7)
      m100Showed = true
    end    
    if player.Score >= 1500 and m1500Showed == false then
      Hud.Message ("You are awesome! keep it up",7)
      m1500Showed = true
    end
    if player.Score >= 2000 and m2000Showed == false then
      Hud.Message ("Bomb has arrived! Do you have a 1000 points? ofc you do.\n use the bomb to clear the enemy.",7)
      m2000Showed = true
    end
    if player.Score >= 3000 and m3000Showed == false then
      Hud.Message ("Here I thought chimps where agile. Well done!",7)
      m3000Showed = true
    end
    if player.Score >= 4000 and m4000Showed == false then
      Hud.Message ("I guess even humans have multiple lives.",7)
      m4000Showed = true
    end
    if player.Score >= 5000 and m5000Showed == false then
      Hud.Message ("You're a god... but I'm still better",7)
      m5000Showed = true
    end
    if player.Score > 9000 and m5000Showed == false then
      Hud.Message ("Its..... OVER 9000!",10)
      m5000Showed = true
    end
end