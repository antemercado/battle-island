class CaveCross < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 4

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 20
    engineLocalY = 8

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNS < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 0
    engineLocalY = 23

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    # @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    # @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveEW < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 20
    engineLocalY = 23

    @frontiers = []
    # @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    # @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveSE < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 0
    engineLocalY = 0

    @frontiers = []
    # @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    # @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNE < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 0
    engineLocalY = 15

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    # @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    # @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNW < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 40
    engineLocalY = 15

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    # @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    # @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveSW < AbstractMap

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 40
    engineLocalY = 0

    @frontiers = []
    # @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    # @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNEW < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 3

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 20
    engineLocalY = 15

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    # @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveSEW < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 3

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 20
    engineLocalY = 0

    @frontiers = []
    # @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNES < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 3

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 0
    engineLocalY = 8

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    # @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end
class CaveNWS < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 3

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
    @engineID = 81

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    # All cave pieces are placed on the same engine map for simplicity
    # Use offsets to speed up placements
    engineLocalX = 40
    engineLocalY = 8

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, engineLocalX + 7, engineLocalY)))
    # @frontiers.push((MapFrontier.new(self, 1, :EAST, engineLocalX + 11, engineLocalY + 2)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, engineLocalX + 5, engineLocalY + 3)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, engineLocalX, engineLocalY + 1)))
  end

  def canBePlaced(dungeon)
    return true
  end
end