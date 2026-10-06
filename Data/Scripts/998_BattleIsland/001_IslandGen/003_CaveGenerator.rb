class CaveCell

  attr_accessor :connections
  attr_accessor :componentID
  attr_accessor :caveMap
  attr_accessor :originLocation

  def initialize(x,y)
    @connections = []
    @componentID = nil
    @caveMap = nil
    @originLocation = [x,y]
  end

  def addConnection(direction)

    if !@connections.include?(direction)
      @connections.push(direction)
    end

    return true
  end

  def collapse()
    mapClass = getCaveMapClass()
    if mapClass.nil?
      return nil
    end
    @caveMap = mapClass.new()
    return @caveMap
  end
  def getCaveMapClass()
    north = @connections.include?(:NORTH)
    east = @connections.include?(:EAST)
    south = @connections.include?(:SOUTH)
    west = @connections.include?(:WEST)
    ret = nil

    if north && east && south && west
      ret = CaveCross
    elsif north && south && !east && !west
      ret = CaveNS
    elsif east && west && !north && !south
      ret = CaveEW
    elsif north && east && !south && !west
      ret = CaveNE
    elsif north && west && !south && !east
      ret = CaveNW
    elsif south && east && !north && !west
      ret = CaveSE
    elsif south && west && !north && !east
      ret = CaveSW
    elsif north && east && west && !south
      ret = CaveNEW
    elsif south && east && west && !north
      ret = CaveSEW
    elsif north && east && south && !west
      ret = CaveNES
    elsif north && west && south && !east
      ret = CaveNWS
    end
    return ret
  end
end

class CaveRay

  attr_accessor :frontier
  attr_accessor :cells
  attr_accessor :crossedRoom
  attr_accessor :matchingFrontier

  def initialize(frontier)
    @frontier = frontier
    @cells = []
    @crossedRoom = false
    @matchingFrontier = nil
  end
end

class CaveGenerator

  attr_accessor :dungeon
  attr_accessor :mapGrid
  attr_accessor :caveGrid
  attr_accessor :availableFrontiers
  attr_accessor :DungeonRNG
  attr_accessor :caveCells

  def initialize(dungeon)
    @dungeon = dungeon
    @mapGrid = dungeon.mapGrid
    @caveGrid = dungeon.caveGrid
    @availableFrontiers = dungeon.availableFrontiers
    @DungeonRNG = dungeon.DungeonRNG
    @caveCells = []
  end

  def generate()
    rays = generateFrontierRays()

    # Connect frontiers that face each other as caves, even under'
    # existing maps
    connectOpposingFrontiers(rays)

    # If a frontier casts a ray that would intersect with another ray
    # create a cave connecting the two.
    # connectFrontiersToCaves(rays)

    # If a frontier would cast a ray that intersects a cave, connect it
    # connectIntersectingRays(rays)

    # Are the remaining frontiers interior or exterior
    # classifyRemainingFrontiers(rays)

    collapseCaveCells()
  end

  def generateFrontierRays()
    ret = []
    frontiers = @dungeon.availableFrontiers.clone
    frontiers.each do |frontier|
      ray = generateFrontierRay(frontier)
      ret.push(ray)
    end
    return ret
  end

  def generateFrontierRay(frontier)

    ray = FrontierRay.new(frontier)

    currentX, currentY = frontier.getTarget()

    offset = MapFrontier::DIRECTION_OFFSET[frontier.direction]
    clearPath = true

    while inBounds?(currentX, currentY)
      ray.cells.push([currentX, currentY])
      map = @mapGrid[currentX][currentY]
      if map.nil?
        if clearPath
          ray.clearCells.push([currentX, currentY])
        end
      else
        ray.crossedRoom = true
        clearPath = false
      end
      matchingFrontier = getOpposingFrontierAt(frontier, currentX, currentY)
      if !matchingFrontier.nil?
        ray.matchingFrontier = matchingFrontier
        break
      end

      currentX += offset[0]
      currentY += offset[1]
    end
    return ray
  end

  def connectOpposingFrontiers(frontierRays)
    connectionCount = 0

    frontierRays.each do |ray|
      # This ray has already been consumed by another cave connection.
      if ray.resolved
        next
      end

      matchingFrontier = ray.matchingFrontier
      # This ray never encountered an opposing frontier.
      if matchingFrontier.nil?
        next
      end

      matchingRay = matchingFrontier.ray

      # This should normally exist because all open frontiers
      # had rays generated before cave processing started.
      if matchingRay.nil?
        puts "[connectOpposingFrontiers] Matching frontier has no ray!"
        next
      end

      # The matching ray may already have been consumed.
      if matchingRay.resolved
        next
      end

      # Safety check:
      # the two rays should have discovered one another.
      if !matchingRay.matchingFrontier.equal?(ray.frontier)
        puts "[connectOpposingFrontiers] Rays do not mutually match!"
        next
      end

      success = markOpposingCave(ray, matchingFrontier)

      if success
        ray.resolved = true
        matchingRay.resolved = true
        connectionCount += 1
      end
    end

    puts "[connectOpposingFrontiers] Created #{connectionCount} cave connections"

    return connectionCount
  end

  def markOpposingCave(ray, matchingFrontier)

    sourceFrontier = ray.frontier
    travelDirection = sourceFrontier.direction
    reverseDirection = MapFrontier::OPPOSITE_DIRECTION[travelDirection]
    destinationLocation =matchingFrontier.originLocation

    ray.cells.each do |location|
      # The destination location belongs to the destination
      # overworld room. Stop before placing a cave cell there.
      if location == destinationLocation
        break
      end

      x = location[0]
      y = location[1]

      caveCell = getOrCreateCaveCell(x, y)

      caveCell.addConnection(travelDirection)
      caveCell.addConnection(reverseDirection)
    end
    puts "[markOpposingCave] Connected:"
    puts "  #{sourceFrontier.direction} #{sourceFrontier.originLocation.inspect}"
    puts "  #{matchingFrontier.direction} #{matchingFrontier.originLocation.inspect}"
    return true
  end

  def getOrCreateCaveCell(x, y)
    caveCell = @caveGrid[x][y]
    if caveCell.nil?
      caveCell = CaveCell.new(x,y)
      @caveGrid[x][y] = caveCell
      @caveCells.push(caveCell)
    end
    return caveCell
  end

  def inBounds?(x, y)
    if x < 0 || y < 0
      return false
    end

    if x >= @mapGrid.length
      return false
    end

    if y >= @mapGrid[0].length
      return false
    end

    return true
  end

  def getOpposingFrontierAt(sourceFrontier, x, y)

    requiredDirection = MapFrontier::OPPOSITE_DIRECTION[sourceFrontier.direction]
    ret = nil

    @dungeon.availableFrontiers.each do |frontier|
      if frontier.equal?(sourceFrontier)
        next
      end

      correctLocation = frontier.originLocation == [x, y]
      correctDirection = frontier.direction == requiredDirection
      isOpen = frontier.open?

      if correctLocation && correctDirection && isOpen
        ret = frontier
        break
      end
    end
    return ret
  end

  def collapseCaveCells()
    caveCells = @caveCells
    caveCells.each do |caveCell|
      x = caveCell.originLocation[0]
      y = caveCell.originLocation[1]
      
      caveMap = caveCell.collapse()
      caveMap.originLocation = [x,y]

      caveMap.frontiers.each do |f|
        f.originLocation = [x,y]
      end

      @caveGrid[x][y] = caveMap
      puts "[collapseCaveCells] #{caveMap.class.name} Placed at  #{x} x #{y}!"
    end

    connectCaveMaps()
    connectOverworldToCaves()
  end

  def connectCaveMaps()

    caveMaps = []

    @caveCells.each do |cell|
      if cell.caveMap.nil?
        next
      end
      caveMaps.push(cell.caveMap)
    end

    caveMaps.each do |caveMap|
      caveMap.frontiers.each do |f|
        if !f.open?
          next
        end

        kissingFrontier = f.getKissingFrontier(grid:@caveGrid)
        if kissingFrontier.nil?
          next
        end
        f.connectFrontier(kissingFrontier)
      end
    end

    return true
  end

  def connectOverworldToCaves()
    frontiers = @dungeon.availableFrontiers.clone

    frontiers.each do |f|
      if !f.open?
        next
      end

      kissingFrontier = f.getKissingFrontier(grid:@caveGrid)
      if kissingFrontier.nil?
        next
      end
      @dungeon.connectFrontiers(f, kissingFrontier)
    end
    return true
  end

end