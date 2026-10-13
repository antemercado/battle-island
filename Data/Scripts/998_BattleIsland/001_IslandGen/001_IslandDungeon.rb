class IslandDungeon
  attr_accessor :DungeonRNG
  attr_accessor :seed

  attr_accessor :mapPool

  attr_accessor :mapGrid
  attr_accessor :caveGrid

  attr_accessor :availableFrontiers
  attr_accessor :centerX
  attr_accessor :centerY

  attr_accessor :roomCount

  GRID_SIZE = 100
  MAX_ROOMS = 20
  MAX_FAILURES = 100

  def initialize()
    @DungeonRNG = $DungeonManager.DungeonRNG
    @seed = nil
    @mapGrid = nil
    @caveGrid = nil
    @availableFrontiers = nil
    @centerX = nil
    @centerY = nil
    @roomCount = 0

    @branchingFailures = 0

    @mapPools = {
      :NORTH  => [],
      :EAST   => [],
      :SOUTH  => [],
      :WEST   => []
    }
  end

  # TODO: Should probably seperate this all into a IslandGenerator class
  #         that can then hold different generators to call.
  def generate(seed = -1)

    @branchingFailures = 0

    if seed == -1
      seed = $DungeonManager.DungeonRNG.rand(10_000_000..99_999_999)
    end
    @seed = seed

    @mapGrid = Array.new(GRID_SIZE) { Array.new GRID_SIZE }
    @caveGrid = Array.new(GRID_SIZE) { Array.new GRID_SIZE }

    @availableFrontiers = []
    @centerX = GRID_SIZE / 2
    @centerY = GRID_SIZE / 2

    @roomCount = 0

    # Get map pool
    declareMapPool()

    # Place map at center of grid
    success = initialPlacement()

    if !success
      puts "FAILED TO GENERATE MAP: CAN'T PLACE INITIAL ROOMS"
      puts "FAILED TO GENERATE MAP: SEED #{@seed}"
      return false
    end

    # Place rooms until MAX_ROOMS is placed
    roomsPlaced = generateRooms()

    if !roomsPlaced
      puts "FAILED TO GENERATE MAP: TOO MANY ROOM GENERATION FAILURES"
      puts "FAILED TO GENERATE MAP: SEED #{@seed}"
      return false
    end

    # Cave Generation
    @caveGen = CaveGenerator.new(self)
    @caveGen.generate()

    # Place dead ends
    placeDeadEnds()

    # Trim bounding box
    trimBoundingBox()
  end

  def initialPlacement()
    centerMap = ExampleCross.new()
    @mapGrid[@centerX][@centerY] = centerMap
    centerMap.frontiers.each do |f|
      f.originLocation = [@centerX, @centerY]
      @availableFrontiers.push(f)
    end

    # Make currentMap the center map for testing purposes
    $DungeonManager.currentMap = centerMap

    # Place a room at each radial direction from center
    openingFrontiers = @availableFrontiers.shuffle(random: @DungeonRNG)

    until openingFrontiers.empty?
      frontier = openingFrontiers.shift
      openingMap = getMapToPlace(frontier.getOppositeDirection())
      success = tryPlaceMap(openingMap, frontier)
      if !success
        openingFrontiers.push(frontier)
        if @branchingFailures >= MAX_FAILURES
          return false
        end
      end
    end
    return true
  end

  def generateRooms(number = MAX_ROOMS)
    placed = 0
    # @branchingFailures = 0
    while placed < number && @roomCount < MAX_ROOMS && (MAX_FAILURES < 0 || @branchingFailures < MAX_FAILURES)
      branchingFrontier = getFrontierBranch()
      branchMap = getMapToPlace(branchingFrontier.getOppositeDirection())

      success = tryPlaceMap(branchMap, branchingFrontier)
      if success
        placed += 1
        # @branchingFailures = 0
      else
      end
    end

    if @branchingFailures >= MAX_FAILURES
      return nil
    end
    return placed
  end

  def placeDeadEnds()
    # puts "[placeDeadEnds] Placing dead end maps.."
    frontiersToClose = @availableFrontiers.clone

    frontiersToClose.each do |f|
      deadEnd = getDeadEndMap(f)
      
      success = tryPlaceMap(deadEnd, f)
      if !success
        puts "[placeDeadEnds] FAILED TO PLACE DEAD-END MAP!"
      end
    end
  end

  def trimBoundingBox(buffer = 0)
    return true
    
    puts "Trimming bounding box..."

    minX = nil
    maxX = nil
    minY = nil
    maxY = nil

    # Find the bounding box of anything occupying either grid.
    for x in 0...@mapGrid.length
      for y in 0...@mapGrid[0].length

        mapOccupied = !@mapGrid[x][y].nil?
        caveOccupied = !@caveGrid[x][y].nil?

        if mapOccupied || caveOccupied

          if minX.nil? || x < minX
            minX = x
          end

          if maxX.nil? || x > maxX
            maxX = x
          end

          if minY.nil? || y < minY
            minY = y
          end

          if maxY.nil? || y > maxY
            maxY = y
          end

        end
      end
    end

    # Nothing exists on either grid.
    if minX.nil?
      return false
    end

    # Apply requested buffer.
    minX -= buffer
    maxX += buffer
    minY -= buffer
    maxY += buffer

    # Do not go outside the existing arrays.
    if minX < 0
      minX = 0
    end

    if minY < 0
      minY = 0
    end

    if maxX >= @mapGrid.length
      maxX = @mapGrid.length - 1
    end

    if maxY >= @mapGrid[0].length
      maxY = @mapGrid[0].length - 1
    end

    newWidth = maxX - minX + 1
    newHeight = maxY - minY + 1

    newMapGrid =
      Array.new(newWidth) { Array.new(newHeight) }

    newCaveGrid =
      Array.new(newWidth) { Array.new(newHeight) }

    # Copy the selected region into the new grids.
    for oldX in minX..maxX
      for oldY in minY..maxY

        newX = oldX - minX
        newY = oldY - minY

        newMapGrid[newX][newY] =
          @mapGrid[oldX][oldY]

        newCaveGrid[newX][newY] =
          @caveGrid[oldX][oldY]

      end
    end

    # Shift all placed map/frontier coordinates.
    #
    # A future multi-cell map will appear in more than one grid cell,
    # so make sure each map instance is only updated once.
    adjustedMaps = []

    for oldX in minX..maxX
      for oldY in minY..maxY

        map = @mapGrid[oldX][oldY]

        if map.nil?
          next
        end

        if adjustedMaps.include?(map)
          next
        end

        map.originLocation = [
          map.originLocation[0] - minX,
          map.originLocation[1] - minY
        ]

        map.frontiers.each do |frontier|

          if frontier.originLocation.nil?
            next
          end

          frontier.originLocation = [
            frontier.originLocation[0] - minX,
            frontier.originLocation[1] - minY
          ]

        end

        adjustedMaps << map
      end
    end

    # Update center coordinates to their normalized position.
    @centerX -= minX
    @centerY -= minY

    # Replace the old temporary grids.
    @mapGrid = newMapGrid
    @caveGrid = newCaveGrid

    return true
  end

  def getPlacementMapOrigin(existingFrontier, candidateFrontier)
    targetX, targetY = existingFrontier.getTarget()

    localX = candidateFrontier.localMapLocation[0]
    localY = candidateFrontier.localMapLocation[1]

    ret = [targetX - localX, targetY - localY]
    return ret
  end

  def canPlaceMap(map, existingFrontier, candidateFrontier, originX, originY)

    # 1. Candidate frontier must face the existing frontier
    return false unless candidateFrontier.direction == existingFrontier.getOppositeDirection()

    # 2. Check every grid cell the map would occupy
    for localX in 0...map.mapWidth
      for localY in 0...map.mapHeight

        gridX = originX + localX
        gridY = originY + localY

        # Out of bounds
        if gridX < 0 || gridY < 0
          puts "[canPlaceMap] FAILED: Negative grid coordinate"
          puts "[canPlaceMap] gridX: #{gridX}, gridY: #{gridY}"
          return false
        end

        if gridX >= @mapGrid.length
          puts "[canPlaceMap] FAILED: X out of bounds"
          puts "[canPlaceMap] gridX: #{gridX}, max: #{@mapGrid.length}"
          return false
        end

        if gridY >= @mapGrid[0].length
          puts "[canPlaceMap] FAILED: Y out of bounds"
          puts "[canPlaceMap] gridY: #{gridY}, max: #{@mapGrid[0].length}"
          return false
        end

        # Room overlap
        if !@mapGrid[gridX][gridY].nil?
          puts "[canPlaceMap] FAILED: Grid cell already occupied"
          return false
        end

        # Would placement block an open frontier?
        existingFrontiers = getFrontiersPointingAt(gridX,gridY)
        existingFrontiers.each do |existingIncomingFrontier|

          requiredDirection =
            MapFrontier::OPPOSITE_DIRECTION[
              existingIncomingFrontier.direction
            ]

          matchingFrontier = nil

          map.frontiers.each do |candidateMapFrontier|

            correctLocation =
              candidateMapFrontier.localMapLocation ==
                [localX, localY]

            correctDirection =
              candidateMapFrontier.direction ==
                requiredDirection

            if correctLocation && correctDirection
              matchingFrontier = candidateMapFrontier
              break
            end

          end

          if matchingFrontier.nil?
            puts "[canPlaceMap] FAILED: Map would block an existing frontier"
            puts "  Existing frontier: #{existingIncomingFrontier.direction} #{existingIncomingFrontier.originLocation.inspect}"
            puts "  Candidate cell: [#{gridX},#{gridY}]"

            return false
          end

        end
        
      end
    end

    # 3. Check that every unused frontier would still point
    #    into an empty dungeon-grid cell
    map.frontiers.each do |frontier|
      next if frontier.equal?(candidateFrontier)

      localX = frontier.localMapLocation[0]
      localY = frontier.localMapLocation[1]

      frontierX = originX + localX
      frontierY = originY + localY

      targetX, targetY =
        frontier.getTarget(frontierX, frontierY)

      return false if targetX < 0 || targetY < 0
      return false if targetX >= @mapGrid.length
      return false if targetY >= @mapGrid[0].length

      targetMap = @mapGrid[targetX][targetY]

      # Empty space is fine.
      next if targetMap.nil?

      # Occupied space is also fine IF it exposes a matching frontier.
      matchingFrontier = frontier.getKissingFrontier(frontierX, frontierY, grid:@mapGrid)

      # Otherwise this frontier would point directly into a wall/room.
      return false if matchingFrontier.nil?
    end

    # 4. Let the map check its own generation-specific rules
    return false unless map.canBePlaced(self)

    return true
  end

  # Looks at all the valid frontiers this map has in the direction and attmepts to place them
  def tryPlaceMap(map, existingFrontier)

    validFrontiers = map.getFrontiersByDirection(existingFrontier.getOppositeDirection())

    validFrontiers = validFrontiers.shuffle(random: @DungeonRNG)

    validFrontiers.each do |candidateFrontier|

      originX, originY =
        getPlacementMapOrigin(
          existingFrontier,
          candidateFrontier
        )

      canPlace = canPlaceMap(map, existingFrontier,
          candidateFrontier, originX, originY)
      if canPlace
        placed = placeMap(map, existingFrontier, candidateFrontier, originX, originY)
        if placed
          return true
        end
      end
    end
    @branchingFailures += 1
    puts "[tryPlaceMap] MAP FAILED TO PLACE. FAILURE COUNT: #{@branchingFailures}/#{MAX_FAILURES}"
    return false
  end

  def placeMap(map, existingFrontier, candidateFrontier, originX, originY)
    # return false unless canPlaceMap(
    #   map,
    #   existingFrontier,
    #   candidateFrontier,
    #   originX,
    #   originY
    # )

    # Store room origin
    map.originLocation = [originX, originY]

    # Fill all occupied cells with this map instance
    for localX in 0...map.mapWidth
      for localY in 0...map.mapHeight

        gridX = originX + localX
        gridY = originY + localY

        @mapGrid[gridX][gridY] = map
      end
    end

    # Calculate absolute dungeon-grid location
    # for every frontier on the new map
    map.frontiers.each do |frontier|
      frontier.age = @roomCount

      localX = frontier.localMapLocation[0]
      localY = frontier.localMapLocation[1]

      frontier.originLocation = [
        originX + localX,
        originY + localY
      ]
    end

    connectFrontiers(existingFrontier, candidateFrontier)

    # Add every new frontier except the one used as the entrance
    map.frontiers.each do |frontier|
      next if frontier.equal?(candidateFrontier)

      matchingFrontier = frontier.getKissingFrontier(grid:@mapGrid)

      if matchingFrontier.nil?
        @availableFrontiers << frontier
      else
        connectFrontiers(frontier, matchingFrontier)
      end

    end

    @roomCount += 1
    return true
  end

  def getFrontierBranch()
    ret = @availableFrontiers.sample(random: @DungeonRNG)
    return ret
  end

  def declareMapPool()
    mapClasses = biGetOverworldMapClasses()

    mapClasses.each do |mapClass|
      map = mapClass.new()
      map.frontiers.each do |frontier|
        mapPool = @mapPools[frontier.direction]
        if !mapPool.include?(mapClass)
          mapPool.push(mapClass)
        end
      end
    end
    return true
  end

  def getMapToPlace(frontierDir)
    mapClass = @mapPools[frontierDir].sample(random: @DungeonRNG)
    return mapClass.new()
  end

  def getDeadEndMap(frontier)
    ret = nil
    case frontier.direction
    when :NORTH
      ret = NDeadEnd.new()
    when :EAST
      ret = EDeadEnd.new()
    when :SOUTH
      ret = SDeadEnd.new()
    when :WEST
      ret = WDeadEnd.new()
    end
    return ret
  end

  def getFrontiersPointingAt(targetX, targetY)

    ret = []

    @availableFrontiers.each do |frontier|

      frontierTargetX, frontierTargetY =
        frontier.getTarget()

      correctX =
        frontierTargetX == targetX

      correctY =
        frontierTargetY == targetY

      if correctX && correctY
        ret.push(frontier)
      end

    end

    return ret
  end

  def connectFrontiers(frontier1, frontier2)

    frontier1.connectFrontier(frontier2)

    @availableFrontiers.delete(frontier1)
    @availableFrontiers.delete(frontier2)

  end

end