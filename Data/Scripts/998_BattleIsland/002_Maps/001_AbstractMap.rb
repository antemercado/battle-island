class AbstractMap

  attr_accessor :frontiers
  attr_accessor :engineID

  attr_accessor :mapWidth
  attr_accessor :mapHeight

  attr_accessor :originLocation

  attr_accessor :encounterList
  attr_accessor :trainerList
  attr_accessor :itemList

  def self.frontierCount()
    return 0
  end

  def self.mapWidth()
    return 1
  end

  def self.mapHeight()
    return 1
  end

  def self.isSingleGridSpace()
    return false
  end
  
  def canBePlaced(dungeon) 
    return false
  end

  def getFrontiersByDirection(dir)
    ret = []
    for f in @frontiers
      if f.direction == dir
        ret.push(f)
      end
    end
    return ret
  end

  def getFrontierByID(id)
    ret = nil

    @frontiers.each do |f|
      if f.frontierID == id
        ret = f
        break
      end
    end

    return ret
  end
  
  def enterMap(engineX = nil, engineY = nil)
    if engineX.nil? || engineY.nil?
      randomFrontier = @frontiers.sample()
      engineX = randomFrontier.engineMapCoords[0]
      engineY = randomFrontier.engineMapCoords[1]
    end
    
    $game_temp.player_new_x = engineX
    $game_temp.player_new_y = engineY
    $game_temp.player_new_direction = :SOUTH
    $game_temp.player_new_map_id = @engineID
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  end
end

class MapFrontier

  DIRECTION = {
    :NORTH  =>  0,
    :EAST   =>  1,
    :SOUTH  =>  2,
    :WEST   =>  3
  }

  DIRECTION_OFFSET = {
    :NORTH  =>  [0, -1],
    :EAST   =>  [1, 0],
    :SOUTH  =>  [0, 1],
    :WEST   =>  [-1, 0]
  }

  OPPOSITE_DIRECTION = {
    :NORTH  =>  :SOUTH,
    :EAST   =>  :WEST,
    :SOUTH  =>  :NORTH,
    :WEST   =>  :EAST
  }

  attr_accessor :direction # Direction the frontier faces
  attr_accessor :parentMap # The AbstractMap this frontier belongs to
  attr_accessor :frontierID

  attr_accessor :engineMapCoords # The engine map's X,Y coordinates this should place the player at
  attr_accessor :engineMapFacingDir # What direction you should face coming out the exit
  
  attr_accessor :originLocation # Location on the dungeon grid
  attr_accessor :localMapLocation # Location in the AbstractRoom's grid from the upper left [0,0]

  attr_accessor :connectedFrontier

  def initialize(map, id, dir, engineX = 0, engineY = 0, localX = 0, localY = 0)
    @parentMap = map
    @frontierID = id
    @engineMapCoords = [engineX, engineY]
    @localMapLocation = [localX, localY]
    @direction = dir
    @engineMapFacingDir = OPPOSITE_DIRECTION[dir]

    @originLocation = nil
    @connectedFrontier = nil
  end

  def getTarget(x = nil, y = nil)
    x ||= @originLocation[0]
    y ||= @originLocation[1]

    dirOffset = DIRECTION_OFFSET[@direction]
    ret = [x + dirOffset[0], y + dirOffset[1]] 
    return ret
  end

  def open?()
    ret = @connectedFrontier.nil?
    return ret
  end
end