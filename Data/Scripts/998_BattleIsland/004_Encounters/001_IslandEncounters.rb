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
    @encounter_tables = dungeonMap.mapEncounters.encounterTable
    puts "[setup] #{@encounter_tables}"
    dungeonMap.mapEncounters.encounterChances.each { |type, value|
      @step_chances[type] = value
    }
    puts "[setup] #{@step_chances}"
  end

end