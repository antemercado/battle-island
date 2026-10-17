class VendingMachine
  VENDING_MACHINE_PERCENT = 0.2

  attr_accessor :typeArr
 
  attr_accessor :tmItem
  attr_accessor :tmMoveData
  attr_accessor :tmCost
  attr_accessor :berryItem
  attr_accessor :berryCost
  attr_accessor :miscItem
  attr_accessor :miscCost

  def initialize(typeArr)
    @ItemRNG = $DungeonManager.ItemRNG
    @typeArr = typeArr
    setBerryItem()
    setTMItem(@typeArr.sample(random: @ItemRNG))
    setMiscItem(@typeArr.sample(random: @ItemRNG))
  end

  def setBerryItem()
    @berryItem = GameData::Item.get(:ORANBERRY)
  end

  def setTMItem(type)
    moveMachines = []
    GameData::Item.each do |i|
      if !i.is_machine?
        next
      end
      move = GameData::Move.get(i.move)
      if (move.type == type)
        moveMachines.append([GameData::Item.get(i), move])
      end
    end
    sample = moveMachines.sample(random: @ItemRNG)
    @tmItem = sample[0]
    @tmMoveData = sample[1]
  end
  
  def setMiscItem(type)
    @miscItem = GameData::Item.get(:POKEBALL)
  end

  def renameChoices(key)
    case key
    when 1, :TM
      return "#{@tmItem.name}: #{@tmMoveData.name}"
    when 2, :BERRY
      return "#{@berryItem.name}"
    when 3, :MISC
      return "#{@miscItem.name}"
    end
  end

  def purchaseItem(key)
    item = nil
    cost = 0
    case key
    when 1, :TM
      item = @tmItem
      cost = 100
    when 2, :BERRY
      item = @berryItem
      cost = 100
    when 3, :MISC
      item = @miscItem
      cost = 100
    end

    if !$bag.can_add?(item, 1)
      pbMessage("Your Bag is full! The item could be purchased.")
      return
    end

    if $player.money < cost
      pbMessage("You can't afford that.")
      return
    end
    
    $bag.add(item, 1)
    $player.money -= cost
    pbMessage("You purchased: #{item.name}!")
  end

end