class MapEncounters
  attr_accessor :landChances
  attr_accessor :caveChances
  attr_accessor :waterChances
  attr_accessor :bugContestChances
  attr_accessor :rockSmashChances
  attr_accessor :pokeRadarChances

  attr_accessor :encounterTable
  attr_accessor :encounterChances

  def initialize
    @landChances = 21
    @caveChances = 5
    @waterChances = 2
    @bugContestChances = 21
    @rockSmashChances = 50
    @pokeRadarChances = 30

    @encounterTable = {}
    @encounterChances = {}
    setEncounterChances()
  end

  def setEncounterChances()
    encounterChances = @encounterChances
    encounterChances[:Land] = @landChances
    encounterChances[:Cave] = @caveChances
    encounterChances[:Water] = @waterChances

    encounterChances[:LandDay] = @landChances
    encounterChances[:CaveDay] = @caveChances
    encounterChances[:WaterDay] = @waterChances

    encounterChances[:LandNight] = @landChances
    encounterChances[:CaveNight] = @caveChances
    encounterChances[:WaterNight] = @waterChances

    encounterChances[:LandMorning] = @landChances
    encounterChances[:CaveMorning] = @caveChances
    encounterChances[:WaterMorning] = @waterChances

    encounterChances[:LandAfternoon] = @landChances
    encounterChances[:CaveAfternoon] = @caveChances
    encounterChances[:WaterAfternoon] = @waterChances

    encounterChances[:LandEvening] = @landChances
    encounterChances[:CaveEvening] = @caveChances
    encounterChances[:WaterEvening] = @waterChances

    encounterChances[:BugContest] = @bugContestChances
    encounterChances[:RockSmash] = @rockSmashChances
    encounterChances[:PokeRadar] = @pokeRadarChances
  end

  def addToEncounterTable(key, speciesArr, levelMin, levelMax)
    arr = []
    speciesArr.each do |pknnArr|
      tmpArr = pknnArr + [levelMin, levelMax]
      arr.push(tmpArr)
    end
    @encounterTable[key] = Array(@encounterTable[key]) + arr
  end
end
