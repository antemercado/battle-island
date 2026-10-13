class DreamCornerMap < AbstractMap
  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 2

  def self.mapWidth()
    return MAP_WIDTH
  end
  def self.mapHeight()
    return MAP_HEIGHT
  end
  def self.frontierCount()
    return FRONTIER_COUNT
  end
  def self.isSingleGridSpace()
    return true
  end

  def initialize()
    super
    @engineID = 82

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 23, 6)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, 41, 24)))

    randomES = TypalEncounterSet.new(:FAIRY)
    randomES.addToMapEncounter(@mapEncounters, :Land, 15, 25)
  end

  def canBePlaced(dungeon)
    return true
  end
end