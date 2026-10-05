class AbstractTrainer

  CHAMP_LEVEL = 60
  CHAMP_LEVEL_ACE = 65

  attr_accessor :trainer
  attr_accessor :name
  attr_accessor :graphic
  attr_accessor :defeated
  attr_accessor :intro_text
  attr_accessor :lose_text
  attr_accessor :win_text

  attr_accessor :pokemon_pool

  def getTeam(levels=[1,100])
    
  end

  def getChampionTeam() 
     return self.getTeam()
  end

  def startBattle()
    pbNoticePlayer(get_self)
    pbMessage(_INTL(@intro_text))
    return TrainerBattle.start_core(@trainer)
  end
  
end