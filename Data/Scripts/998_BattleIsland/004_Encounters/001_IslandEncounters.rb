class DungeonPokemonEncounters < PokemonEncounters
  def setup(map_id)
    if !$DungeonManager
      puts "[setup] !$DungeonManager"
      super(map_id)
      return
    end
    dungeonMap = $DungeonManager.getCurrRoom()
    if !dungeonMap
      puts "[setup] !$DungeonManager.getCurrRoom()"
      super(map_id)
      return
    end
    super(dungeonMap.engineID)
    @encounter_tables = dungeonMap.encounters.getEncounterTable($DungeonManager.minLevel, $DungeonManager.maxLevel)
    puts "[setup] #{@encounter_tables}"
    dungeonMap.encounters.getEncounterChances().each { |type, value|
      @step_chances[type] = value
    }
    puts "[setup] #{@step_chances}"
  end

end