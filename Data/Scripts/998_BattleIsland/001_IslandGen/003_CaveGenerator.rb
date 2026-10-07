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
    connectIntersectingRays(rays)
    
    # If a frontier would cast a ray that intersects a cave, connect it
    connectFrontiersToCaves(rays)

    # Are the remaining frontiers interior or exterior
    classifyRemainingFrontiers(rays)

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

    offset = frontier.getDirectionOffset()
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
    reverseDirection = sourceFrontier.getOppositeDirection()
    destinationLocation = matchingFrontier.originLocation

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

    requiredDirection = sourceFrontier.getOppositeDirection()
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

  def connectIntersectingRays(frontierRays)

    unresolvedRays = frontierRays.select {|r| !r.isResolved?}

    unresolvedRays.each do |ray1|
      unresolvedRays.each do |ray2|
        if ray2.equal?(ray1)
          next
        end

        if !raysCanIntersect?(ray1, ray2)
          next
        end

        intersection = getRayIntersection(ray1, ray2)

        if intersection.nil?
          next
        end

        markIntersectingCave(ray1, ray2, intersection)

      end
    end

  end

  def raysCanIntersect?(ray1, ray2)
    return ray1.isPerpendicular?(ray2)
  end

  def getRayIntersection(ray1, ray2)
    ret = nil
    ray1.clearCells.each do |location|
      if !ray2.clearCells.include?(location)
        next
      end
      x = location[0]
      y = location[1]

      # If a cave already exists here, this should be
      # handled by the later ray-to-existing-cave pass.
      if !@caveGrid[x][y].nil?
        next
      end
      
      # Check to see if rays can reach intersection from frontier
      # without hitting an existing caveCell
  
      ray1CanSee = rayHasViewOfLocation(ray1, location)
      if !ray1CanSee
        next
      end
      ray2CanSee = rayHasViewOfLocation(ray2, location)
      if !ray2CanSee
        next
      end

      ret = location
      break
    end

    return ret
  end

  def markIntersectingCave(ray1, ray2, intersection)
    success1 = markCaveToLocation(ray1, intersection)

    if !success1
      return false
    end

    success2 = markCaveToLocation(ray2, intersection)

    if !success2
      return false
    end

    puts "[markIntersectingCave] Connected:"
    puts "  #{ray1.frontier.direction} #{ray1.frontier.originLocation.inspect}"
    puts "  #{ray2.frontier.direction} #{ray2.frontier.originLocation.inspect}"
    puts "  Intersection: #{intersection.inspect}"

    return true
  end

  def markCaveToLocation(ray, intersection)

    travelDirection = ray.frontier.direction
    reverseDirection = ray.frontier.getOppositeDirection()

    ray.clearCells.each do |location|
      x = location[0]

      y = location[1]

      caveCell = getOrCreateCaveCell(x,y)

      if location == intersection
        # The path ends here, so this cell only needs
        # to point back toward the source frontier.
        caveCell.addConnection(reverseDirection)
        return true
      end
      # Intermediate cells are straight tunnel pieces.
      caveCell.addConnection(travelDirection)
      caveCell.addConnection(reverseDirection)
    end
    return false
  end

  def rayHasViewOfLocation(ray, targetLocation)
    ray.clearCells.each do |location|
      if location == targetLocation
        return true
      end
      x = location[0]
      y = location[1]
      caveCell = @caveGrid[x][y]
      if !caveCell.nil?
        return false
      end
    end
    return false
  end

  def connectFrontiersToCaves(frontierRays)
    frontierRays.each do |ray|
      if ray.resolved
        next
      end
      caveCell = getFirstBlocker(ray, @caveGrid)
      if caveCell.nil?
        next
      end
      success = markRayToCave(ray, caveCell)
      if success
        ray.resolved = true
      end
    end
  end

  def getFirstBlocker(ray, grid)
    ray.clearCells.each do |location|
      x = location[0]
      y = location[1]
      blocker = grid[x][y]
      if !blocker.nil?
        return blocker
      end
    end
    return nil
  end

  def markRayToCave(ray, caveCell)
    targetLocation = caveCell.originLocation
    success = markCaveToLocation(ray, targetLocation)
    if !success
      return false
    end
    return true
  end

  def classifyRemainingFrontiers(frontierRays)
    frontierRays.each do |ray|
      frontier = ray.frontier
      if ray.crossedRoom
        frontier.interior = true
      else
        frontier.interior = false
      end
    end
  end

end