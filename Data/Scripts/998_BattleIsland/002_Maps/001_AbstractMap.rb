class AbstractMap

  attr_accessor :frontiers
  attr_accessor :engineID

  attr_accessor :mapWidth
  attr_accessor :mapHeight

  attr_accessor :originLocation

  attr_accessor :encounterList
  attr_accessor :trainerList
  attr_accessor :itemList

  attr_accessor :mapEncounters

  def initialize
    @mapEncounters = MapEncounters.new
  end

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
    return true
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
  attr_accessor :age

  attr_accessor :engineMapCoords # The engine map's X,Y coordinates this should place the player at
  attr_accessor :engineMapFacingDir # What direction you should face coming out the exit
  
  attr_accessor :originLocation # Location on the dungeon grid
  attr_accessor :localMapLocation # Location in the AbstractRoom's grid from the upper left [0,0]

  attr_accessor :connectedFrontier

  attr_accessor :ray
  attr_accessor :interior

  def initialize(map, id, dir, engineX = 0, engineY = 0, localX = 0, localY = 0)
    @parentMap = map
    @frontierID = id
    @engineMapCoords = [engineX, engineY]
    @localMapLocation = [localX, localY]
    @direction = dir
    @engineMapFacingDir = OPPOSITE_DIRECTION[dir]

    @originLocation = nil
    @connectedFrontier = nil

    @ray = nil
    @interior = nil
    @age = 0
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

  def getKissingFrontier(frontierX = nil, frontierY = nil, grid:)

    if frontierX.nil? || frontierY.nil?
      frontierX = @originLocation[0]
      frontierY = @originLocation[1]
    end

    targetX, targetY = getTarget(frontierX, frontierY)

    if targetX < 0 || targetY < 0
      return nil
    end

    if targetX >= grid.length || targetY >= grid[0].length
      return nil
    end

    targetMap = grid[targetX][targetY]

    # If there is no map in the target space,
    # then there cannot be a kissing frontier.
    return nil if targetMap.nil?

    oppositeDirection =
      MapFrontier::OPPOSITE_DIRECTION[@direction]

    ret = nil

    targetMap.frontiers.each do |otherFrontier|

      correctLocation =
        otherFrontier.originLocation == [targetX, targetY]

      correctDirection =
        otherFrontier.direction == oppositeDirection

      isOpen =
        otherFrontier.open?

      if correctLocation && correctDirection && isOpen
        ret = otherFrontier
        break
      end

    end

    return ret
  end

  def connectFrontier(frontier)

    @connectedFrontier = frontier
    frontier.connectedFrontier = self

  end

  def self.getOppositeDirection(dir)
    return OPPOSITE_DIRECTION[dir]
  end

  def self.getDirectionOffset(dir)
    return DIRECTION_OFFSET[dir]
  end

  def getOppositeDirection()
    return MapFrontier.getOppositeDirection(@direction)
  end

  def getDirectionOffset()
    return MapFrontier.getDirectionOffset(@direction)
  end

end

class FrontierRay

  attr_accessor :frontier

  attr_accessor :cells
  attr_accessor :clearCells

  attr_accessor :crossedRoom
  attr_accessor :matchingFrontier

  attr_accessor :resolved

  def initialize(frontier)
    if frontier.ray.nil?
      frontier.ray = self
    else
      raise "FRONTIER ALREADY HAS FrontierRay!"
    end
    
    @frontier = frontier
    @cells = []
    @clearCells = []
    
    @crossedRoom = false
    @matchingFrontier = nil
    
    @resolved = false

  def vertical?()
    f = @frontier
    return f.direction == :NORTH || f.direction == :SOUTH
  end

  def horizontal?()
    f = @frontier
    return f.direction == :EAST || f.direction == :WEST
  end

  end

  def openSpaceCount()
    return @clearCells.length
  end

  def isPerpendicular?(ray)
    return (self.vertical? && ray.horizontal?) || (self.horizontal? && ray.vertical?)
  end

  def isResolved?()
    if @resolved.nil?
      return false
    end
    return @resolved
  end

end