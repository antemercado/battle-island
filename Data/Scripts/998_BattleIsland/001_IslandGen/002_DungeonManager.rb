class DungeonManager

  attr_accessor :currentDungeon
  attr_accessor :minLevel
  attr_accessor :maxLevel

  def newDungeon(seed=-1)
    currentDungeon = IslandDungeon.new()
    currentDungeon.generate(seed)
    @currentDungeon = currentDungeon
    @minLevel = 5
    @maxLevel = 10
    $PokemonEncounters = DungeonPokemonEncounters.new
  end

  def transferMaps(frontierID)
    currentMap = @currentDungeon.currentMap
    frontier = currentMap.getFrontierByID(frontierID)

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
    @currentDungeon.currentMap = destinationMap

    $PokemonEncounters.setup(destinationMap)
    
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
    
    @currentDungeon.currentMap = map
    $PokemonEncounters.setup(map)
    
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
    return @currentDungeon.currentMap
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