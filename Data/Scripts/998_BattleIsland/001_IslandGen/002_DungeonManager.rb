class DungeonManager

  attr_accessor :currentDungeon
  attr_accessor :currentMap

  attr_accessor :minLevel
  attr_accessor :maxLevel

  attr_reader :DungeonRNG
  attr_reader :EncounterRNG
  attr_reader :ItemRNG

  attr_reader :validSpecies

  def newDungeon(seed=-1)
    @DungeonRNG = Random.new(seed)
    @EncounterRNG = Random.new(seed)
    @ItemRNG = Random.new(seed)
    
    @minLevel = 5
    @maxLevel = 10

    @validSpecies = []
    setValidSpecies()

    dungeonGenerated = false
    dungeonSeed = seed
    currentDungeon = IslandDungeon.new()
    until dungeonGenerated
      puts "[DungeonManger] New seed = #{dungeonSeed}"
      dungeonGenerated = currentDungeon.generate(dungeonSeed)
      if !dungeonGenerated
        dungeonSeed = @DungeonRNG.rand(10_000_000..99_999_999)
      end
    end

    @currentDungeon = currentDungeon
    
    $PokemonEncounters = DungeonPokemonEncounters.new
    
    updateVendingMachines()
  end

  def transferMaps(frontierID)
    frontier = @currentMap.getFrontierByID(frontierID)

    # No frontier matching ID
    if frontier.nil?
      return false
    end

    connectedFrontier = frontier.connectedFrontier

    # No connected frontier to transfer to.
    if connectedFrontier.nil?
      return false
    end

    destinationMap = connectedFrontier.parentMap
    @currentMap = destinationMap

    $PokemonEncounters.setup(destinationMap)
    $game_switches[76] = !destinationMap.vendingMachine.nil?

    # Engine Transfer Logic
    $game_temp.player_new_x = connectedFrontier.engineMapCoords[0]
    $game_temp.player_new_y = connectedFrontier.engineMapCoords[1]
    $game_temp.player_new_direction = connectedFrontier.engineMapFacingDir
    $game_temp.player_new_map_id = destinationMap.engineID
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh

    puts "[transferMaps] Moved to [#{connectedFrontier.originLocation[0]},#{connectedFrontier.originLocation[1]}]"
  end

  
  def enterMap(map, engineX = nil, engineY = nil)
    if @currentDungeon.nil? || map.nil?
      return false
    end
    
    @currentMap = map

    $PokemonEncounters.setup(map)
    $game_switches[76] = !map.vendingMachine.nil?
    
    map.enterMap(engineX, engineY)
    return true
  end

  def hasEncounters?()
    terrainTag = $game_map.terrain_tag($game_player.x, $game_player.y)
    return terrainTag.land_wild_encounters
  end

  def inDungeon?()
    return true
  end

  def getCurrRoom()
    return @currentMap
  end

  def setValidSpecies()
    GameData::Species.each do |s|
      @validSpecies.push(s)
    end
  end

  def getRandomSpeciesID(random = @EncounterRNG)
    @validSpecies.sample(random: random).id
  end

  def getRandomSpeciesIDByType(type, random = @EncounterRNG)
    arr = []
    @validSpecies.each do |s|
      if s.types.include?(type)
        arr.push(s.id)
      end
    end
    arr.sample(random: random)
  end

  def updateVendingMachines()
    allMaps = @currentDungeon.mapHash.values.shuffle(random: @DungeonRNG)
    sampleCount = VendingMachine::VENDING_MACHINE_PERCENT * allMaps.length
    allMaps.each_with_index do |map, i|
      if i <= sampleCount
        # Add below for debugging
        # || map.instance_of?(DreamCornerMap)
        map.vendingMachine = VendingMachine.new(map.typeArray)
      else
        map.vendingMachine = nil
      end
    end
  end

  def getVendingChoice(key, map = @currentMap)
     return map.vendingMachine.renameChoices(key)
  end

  def purchaseVendingItem(key, map = @currentMap)
     map.vendingMachine.purchaseItem(key)
  end

end
#----------------------------
# Save map value to save file
#----------------------------

SaveData.register(:dungeonmanager) do
    ensure_class :DungeonManager
    save_value { $DungeonManager }
    load_value { |value| $DungeonManager = value }
    new_game_value { DungeonManager.new }
end