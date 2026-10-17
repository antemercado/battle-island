class AbstractEncounterSet
  attr_accessor :speciesHash

  def initialize
    @speciesHash = {}
    @EncounterRNG = @EncounterRNG
  end

  def addToMapEncounter(mapEncounter, key, levelMin=1, levelMax=100)
    mapEncounter.addToEncounterTable(key, @speciesHash[key], levelMin, levelMax)
  end
end

# A basic encounter set with iconic pokemon for testing
class ExampleEncounterSet < AbstractEncounterSet
  def initialize
    super
    tmp = [:Land, :Cave, :Water]
    tmp.each do |key|
      speciesArr = []
      case key
      when :Land
        speciesArr.push([10, :SEEDOT])
        speciesArr.push([10, :LEDYBA])
        speciesArr.push([10, :MURKROW])
        speciesArr.push([10, :SNUBBULL])
        speciesArr.push([10, :JOLTIK])
        speciesArr.push([5, :VOLTORB_1])
      when :Cave
        speciesArr.push([10, :MACHOP])
        speciesArr.push([10, :ZUBAT])
        speciesArr.push([10, :DWEBBLE])
        speciesArr.push([10, :HEATMOR])
        speciesArr.push([10, :SHUCKLE])
        speciesArr.push([5, :STUNFISK_1])
      when :Water
        speciesArr.push([10, :TENTACOOL])
        speciesArr.push([10, :QWILFISH_1])
        speciesArr.push([10, :CLOBBOPUS])
        speciesArr.push([10, :HORSEA])
        speciesArr.push([10, :CURSOLA])
      end
      @speciesHash[key] = speciesArr
    end
  end
end

# A basic encounter set with iconic pokemon for testing
class TypalEncounterSet < AbstractEncounterSet
  def initialize(type)
    super()
    tmp = [:Land, :Cave, :Water]
    tmp.each do |key|
      speciesArr = []
      case key
      when :Land
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
      when :Cave
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
      when :Water
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
        speciesArr.push([10, $DungeonManager.getRandomSpeciesIDByType(type.sample(random: @EncounterRng))])
      end
      @speciesHash[key] = speciesArr
    end
  end
end