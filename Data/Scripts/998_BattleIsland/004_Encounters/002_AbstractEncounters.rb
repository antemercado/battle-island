class AbstractEncounters
  attr_accessor :landChances
  attr_accessor :caveChances
  attr_accessor :waterChances
  attr_accessor :bugContestChances
  attr_accessor :rockSmashChances
  attr_accessor :pokeRadarChances

  def initialize
    @landChances = 21
    @caveChances = 5
    @waterChances = 2
    @bugContestChances = 21
    @rockSmashChances = 50
    @pokeRadarChances = 30
  end

  def getEncounterChances()
    encounterChances = {}
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

    return encounterChances
  end

  def getEncounterTable(levelMin=0,levelMax=100)
    tmpTable = {}
    tmpTable[:Land] = getLandSpecies()
    tmpTable[:Cave] = getCaveSpecies()
    tmpTable[:Water] = getWaterSpecies()

    tmpTable[:LandDay] = getLandDaySpecies()
    tmpTable[:CaveDay] = getCaveDaySpecies()
    tmpTable[:WaterDay] = getWaterDaySpecies()

    tmpTable[:LandNight] = getLandNightSpecies()
    tmpTable[:CaveNight] = getCaveNightSpecies()
    tmpTable[:WaterNight] = getWaterNightSpecies()

    tmpTable[:LandMorning] = getLandMorningSpecies()
    tmpTable[:CaveMorning] = getCaveMorningSpecies()
    tmpTable[:WaterMorning] = getWaterMorningSpecies()

    tmpTable[:LandAfternoon] = getLandAfternoonSpecies()
    tmpTable[:CaveAfternoon] = getCaveAfternoonSpecies()
    tmpTable[:WaterAfternoon] = getWaterAfternoonSpecies()

    tmpTable[:LandEvening] = getLandEveningSpecies()
    tmpTable[:CaveEvening] = getCaveEveningSpecies()
    tmpTable[:WaterEvening] = getWaterEveningSpecies()

    tmpTable[:BugContest] = getBugContestSpecies()
    tmpTable[:RockSmash] = getRockSmashSpecies()
    tmpTable[:PokeRadar] = getPokeRadarSpecies()

    tmpTable[:OldRod] = getOldRodSpecies()
    tmpTable[:GoodRod] = getGoodRodSpecies()
    tmpTable[:SuperRod] = getSuperRodSpecies()

    tmpTable[:HeadbutLow] = getHeadbutLowSpecies()
    tmpTable[:HeadbutHigh] = getHeadbutHighSpecies()
    
    encounterTable = {}
    tmpTable.compact.each do |k, v|
      addToEncounterTable(encounterTable, k, v, levelMin, levelMax)
    end

    return encounterTable

  end

  def addToEncounterTable(encounterTable, key, speciesArr, levelMin, levelMax)
    arr = []
    speciesArr.each do |pknnArr|
      tmpArr = pknnArr + [levelMin, levelMax]
      arr.push(tmpArr)
    end
    encounterTable[key] = Array(encounterTable[key]) + arr
  end

  def getLandSpecies()
    return nil
  end
  def getLandDaySpecies()
    return nil
  end
  def getLandNightSpecies()
    return nil
  end
  def getLandMorningSpecies()
    return nil
  end
  def getLandAfternoonSpecies()
    return nil
  end
  def getLandEveningSpecies()
    return nil
  end
  
  def getCaveSpecies()
    return nil
  end
  def getCaveDaySpecies()
    return nil
  end
  def getCaveNightSpecies()
    return nil
  end
  def getCaveMorningSpecies()
    return nil
  end
  def getCaveAfternoonSpecies()
    return nil
  end
  def getCaveEveningSpecies()
    return nil
  end
  
  def getWaterSpecies()
    return nil
  end
  def getWaterDaySpecies()
    return nil
  end
  def getWaterNightSpecies()
    return nil
  end
  def getWaterMorningSpecies()
    return nil
  end
  def getWaterAfternoonSpecies()
    return nil
  end
  def getWaterEveningSpecies()
    return nil
  end
  
  def getBugContestSpecies()
    return nil
  end
  
  def getOldRodSpecies()
    return nil
  end
  def getGoodRodSpecies()
    return nil
  end
  def getSuperRodSpecies()
    return nil
  end
  
  def getRockSmashSpecies()
    return nil
  end
  
  def getHeadbutLowSpecies()
    return nil
  end
  def getHeadbutHighSpecies()
    return nil
  end

  def getPokeRadarSpecies()
    return nil
  end
end
