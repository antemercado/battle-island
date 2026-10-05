class TPPRed < AbstractTrainer
  def getTeam()

  end

  def getChampionTeam()
    team = []

    species = [:ZAPDOS, :NIDOKING, :VENOMOTH, :LAPRAS, :PIDGEOT, :OMASTAR]
    species.each do |spec|
      pkmn = Pokemon.new(spec, AbstractTrainer::CHAMP_LEVEL, @trainer, false)
      case spec
      when :ZAPDOS
        pkmn.learn_move(:THUNDERSHOCK)
        pkmn.learn_move(:TAKEDOWN)
        pkmn.learn_move(:DRILLPECK)
        pkmn.learn_move(:DRILLPECK)
        pkmn.name("AA-j")
      when :NIDOKING
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:POSIONSTING)
        pkmn.learn_move(:STRENGTH)
        pkmn.learn_move(:FURYATTACK)
        pkmn.name("AAAAAAAAAA")
      when :VENOMOTH
        pkmn.learn_move(:DISABLE)
        pkmn.learn_move(:POISONPOWDER)
        pkmn.learn_move(:LEECHLIFE)
        pkmn.learn_move(:STUNSPORE)
        pkmn.name("AATTVVV")
      when :LAPRAS
        pkmn.learn_move(:CONFUSERAY)
        pkmn.learn_move(:MIST)
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:STRENGTH)
        pkmn.name("AIIIIIIRRR")
      when :PIDGEOT
        pkmn.learn_move(:MIRRORMOVE)
        pkmn.learn_move(:SANDATTACK)
        pkmn.learn_move(:QUICKATTACK)
        pkmn.learn_move(:SKYATTACK)
        pkmn.name("aaabaaajss")
      when :OMASTAR
        pkmn.learn_move(:HYDROPUMP)
        pkmn.learn_move(:WITHDRAW)
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:HORNATTACK)
      end

      

    end

  end

end