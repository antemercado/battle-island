class VendingMachine
  VENDING_MACHINE_PERCENT = 0.1

  TM_COST_BASE = 200

  LEGEND_CUTOFF = 90
  RARE_CUTOFF = 75
  UNCOMMON_CUTOFF = 45

  BERRY_COST_BASE = {
    :COMMON   => 50,
    :UNCOMMON => 100,
    :RARE     => 200
  }
  MISC_COST_BASE = {
    :COMMON     => 75,
    :UNCOMMON   => 150,
    :RARE       => 300,
    :LEGENDARY  => 500
  }

  BERRY_RARITY = {
    :COMMON   => [:ORANBERRY, :LEPPABERRY, :CHERIBERRY, :CHESTOBERRY, :PECHABERRY, :RAWSTBERRY, :ASPEARBERRY, :PERSIMBERRY],
    :UNCOMMON => [:SITRISBERRY, :TYPEBERRY, :LIECHIBERRY, :GANLONBERRY, :SALACBERRY, :PETAYABERRY, :APICOTBERRY, :LANSATBERRY, :STARFBERRY],
    :RARE     => [:ENIGMABERRY, :MICLEBERRY, :CUSTAPBERRY, :JABOCABERRY, :KEEBERRY, :MARANGABERRY],
  }

  MISC_RARITY = {
    :COMMON => [:HEALBALL, :TIMERBALL],
    :UNCOMMON => [:GREATBALL, :QUICKBALL],
    :RARE => [:TYPESTONE, :ULTRABALL],
    :LEGENDARY => [:LEFTOVERS, :CHOICEBAND, :CHOICESCARF, :CHOICESPECS, :ASSAULTVEST]
  }

  BERRY_TYPE = {
      :NORMAL     => :CHILANBERRY,
      :GRASS      => :RINDOBERRY,
      :FIRE       => :OCCABERRY,
      :WATER      => :PASSHOBERRY,
      :ELECTRIC   => :WACANBERRY,
      :ICE        => :YACHEBERRY,
      :FIGHTING   => :CHOPLEBERRY,
      :POISON     => :KEBIABERRY,
      :GROUND     => :SHUCABERRY,
      :FLYING     => :COBABERRY,
      :PSYCHIC    => :PAYAPABERRY,
      :BUG        => :TANGABERRY,
      :ROCK       => :CHARTIBERRY,
      :GHOST      => :KASIBBERRY,
      :DARK       => :COLBURBERRY,
      :DRAGON     => :HABANBERRY,
      :STEEL      => :BABIRIBERRY,
      :FAIRY      => :ROSELIBERRY
  }

  STONE_TYPE = {
      :NORMAL     => :MOONSTONE,
      :GRASS      => :LEAFSTONE,
      :FIRE       => :FIRESTONE,
      :WATER      => :WATERSTONE,
      :ELECTRIC   => :THUNDERSTONE,
      :ICE        => :ICESTONE,
      :FIGHTING   => nil,
      :POISON     => nil,
      :GROUND     => nil,
      :FLYING     => :DAWNSTONE,
      :PSYCHIC    => :SUNSTONE,
      :BUG        => nil,
      :ROCK       => nil,
      :GHOST      => nil,
      :DARK       => :DUSKSTONE,
      :DRAGON     => nil,
      :STEEL      => nil,
      :FAIRY      => :SHINYSTONE
  }

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
    rarity = getRarity()
    itemKey = BERRY_RARITY[rarity].sample(random: @ItemRNG)
    if itemKey == :TYPEBERRY
      type = @typeArr.sample(random: @ItemRNG)
      itemKey = BERRY_TYPE[type]
    end
    @berryItem = GameData::Item.get(itemKey)
    @berryCost = BERRY_COST_BASE[rarity]
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
    @tmCost = TM_COST_BASE
  end
  
  def setMiscItem(type)
    rarity = getRarity(true)
    itemKey = MISC_RARITY[rarity].sample(random: @ItemRNG)
    if itemKey == :TYPESTONE
      type = @typeArr.sample(random: @ItemRNG)
      itemKey = STONE_TYPE[type]
      if itemKey.nil?
        itemKey = STONE_TYPE.values.compact.sample(random: @ItemRNG)
      end
    end
    @miscItem = GameData::Item.get(itemKey)
    @miscCost = MISC_COST_BASE[rarity]
  end

  def renameChoices(key)
    case key
    when 1, :TM
      return "#{@tmItem.name}: #{@tmMoveData.name} - $#{@tmCost}"
    when 2, :BERRY
      return "#{@berryItem.name} - $#{@berryCost}"
    when 3, :MISC
      return "#{@miscItem.name} - $#{@miscCost}"
    end
  end

  def purchaseItem(key)
    item = nil
    cost = 0
    case key
    when 1, :TM
      item = @tmItem
      cost = @tmCost
    when 2, :BERRY
      item = @berryItem
      cost = @berryCost
    when 3, :MISC
      item = @miscItem
      cost = @miscCost
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

  def getRarity(includeLegend = false)
    roll = @ItemRNG.rand(0..99)
    rarity = :COMMON
    if includeLegend && roll >= LEGEND_CUTOFF
      rarity = :LEGENDARY
    elsif roll >= RARE_CUTOFF
      rarity = :RARE
    elsif roll >= UNCOMMON_CUTOFF
      rarity = :UNCOMMON
    end
    return rarity
  end

end