class ExampleCross < AbstractMap

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
    @engineID = 22

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []

    dir = [:NORTH, :EAST, :SOUTH, :WEST]
    dir.each do |x|
      case x
      when :NORTH
        @frontiers.push((MapFrontier.new(self, 0, x, 9, 2)))
      when :EAST
        @frontiers.push((MapFrontier.new(self, 1, x, 15, 7)))
      when :SOUTH
        @frontiers.push((MapFrontier.new(self, 2, x, 9, 13)))
      when :WEST
        @frontiers.push((MapFrontier.new(self, 3, x, 3, 7)))
      end
    end
  end

  def canBePlaced(dungeon)
    return true
  end

end

class EDeadEnd < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 1

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
    @engineID = 32

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :WEST, 3, 7)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class WDeadEnd < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 1

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
    @engineID = 42

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :EAST, 15, 7)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class NDeadEnd < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 1

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
    @engineID = 33

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :SOUTH, 9, 13)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class SDeadEnd < AbstractMap

  MAP_WIDTH = 1
  MAP_HEIGHT = 1
  FRONTIER_COUNT = 1

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
    @engineID = 43

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 9, 2)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class NTrident < AbstractMap

  MAP_WIDTH = 3
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
    return false
  end

  def initialize()
    super
    @engineID = 76

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 9, 2, 0, 0)))
    @frontiers.push((MapFrontier.new(self, 1, :NORTH, 29, 2, 1, 0)))
    @frontiers.push((MapFrontier.new(self, 2, :NORTH, 49, 2, 2, 0)))
    @frontiers.push((MapFrontier.new(self, 3, :SOUTH, 29, 13, 1, 0)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class STrident < AbstractMap

  MAP_WIDTH = 3
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
    return false
  end
  def initialize()
    super
    @engineID = 77

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 29, 2, 1, 0)))
    @frontiers.push((MapFrontier.new(self, 1, :SOUTH, 49, 13, 2, 0)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, 29, 13, 1, 0)))
    @frontiers.push((MapFrontier.new(self, 3, :SOUTH, 9, 13, 0, 0)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class BigCross < AbstractMap

  MAP_WIDTH = 3
  MAP_HEIGHT = 3
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
    return false
  end

  def initialize()
    super
    @engineID = 78

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []
    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 29, 2, 1, 0)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, 54, 22, 2, 1)))
    @frontiers.push((MapFrontier.new(self, 2, :SOUTH, 29, 42, 1, 2)))
    @frontiers.push((MapFrontier.new(self, 3, :WEST, 4, 22, 0, 1)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class NSStraight < AbstractMap

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
    @engineID = 80

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []

    @frontiers.push((MapFrontier.new(self, 0, :NORTH, 9, 2)))
    @frontiers.push((MapFrontier.new(self, 1, :SOUTH, 9, 13)))
  end

  def canBePlaced(dungeon)
    return true
  end

end

class EWStraight < AbstractMap

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
    @engineID = 79

    @mapWidth = MAP_WIDTH
    @mapHeight = MAP_HEIGHT

    @frontiers = []

    @frontiers.push((MapFrontier.new(self, 0, :WEST, 3, 7)))
    @frontiers.push((MapFrontier.new(self, 1, :EAST, 15, 7)))
  end

  def canBePlaced(dungeon)
    return true
  end

end