def randomStarterSelection(seed=-1)
    if seed > 0 then srand(seed) end
    typeStarters = {
        :NORMAL     => [:EEVEE,:TEDDIURSA,:WHISMUR,:GLAMEOW,:LILLIPUP,:BUNNELBY,:YUNGOOS,:WOOLOO],
        :GRASS      => [:BULBASAUR,:CHIKORITA,:TREECKO,:TURTWIG,:SNIVY,:CHESPIN,:ROWLET,:GROOKEY],
        :FIRE       => [:CHARMANDER,:CYNDAQUIL,:TORCHIC,:CHIMCHAR,:TEPIG,:FENNEKIN,:LITTEN,:SCORBUNNY],
        :WATER      => [:SQUIRTLE,:TOTODILE,:MUDKIP,:PIPLUP,:OSHAWOTT,:FROAKIE,:POPPLIO,:SOBBLE],
        :ELECTRIC   => [:PICHU,:MAREEP,:ELECTRIKE,:SHINX,:TYNAMO,:YAMPER],
        :ICE        => [:SNORUNT,:VANILLITE,:BERGMITE],
        :FIGHTING   => [:MACHOP,:TYROGUE,:MAKUHITA,:RIOLU,:TIMBURR,:CLOBBOPUS],
        :POISON     => [:NIDORANmA,:NIDORANfE,:GULPIN],
        :GROUND     => [:SANDSHREW,:TRAPINCH,:SILICOBRA],
        :FLYING     => [:ROOKIDEE],
        :PSYCHIC    => [:ABRA,:WYNAUT,:CHINGLING,:GOTHITA,:HATENNA],
        :BUG        => [:CATERPIE,:PINECO,:WURMPLE,:KRICKETOT,:SHELMET,:SCATTERBUG,:GRUBBIN],
        :ROCK       => [:BONSLY,:ROGGENROLA,:ROCKRUFF,:ROLYCOLY],
        :GHOST      => [:DUSKULL,:YAMASK],
        :DARK       => [:POOCHYENA,:PURRLOIN,:NICKIT],
        :DRAGON     => [:DRATINI,:BAGON,:AXEW,:GOOMY,:JANGMOO],
        :STEEL      => [:KLINK],
        :FAIRY      => [:TOGEPI,:FLABEBE]
    }
    typeWeight = {
        :NORMAL     => 6.00,
        :GRASS      => 12.00,
        :FIRE       => 12.00,
        :WATER      => 12.00,
        :ELECTRIC   => 4.00,
        :ICE        => 10.00,
        :FIGHTING   => 6.00,
        :POISON     => 8.00,
        :GROUND     => 6.00,
        :FLYING     => 6.00,
        :PSYCHIC    => 6.00,
        :BUG        => 8.00,
        :ROCK       => 10.00,
        :GHOST      => 4.00,
        :DARK       => 6.00,
        :DRAGON     => 0.00,
        :STEEL      => 0.00,
        :FAIRY      => 2.00
    }

    chosenTypes = []

    typeArr = [:NORMAL,:GRASS,:FIRE,:WATER,:ELECTRIC,:ICE,:FIGHTING,:POISON,:GROUND,:FLYING,:PSYCHIC,:BUG,:ROCK,:GHOST,:DARK,:DRAGON,:STEEL,:FAIRY]
    while chosenTypes.count < 3
        randarr = []
        typeArr.each do |type|
            x = typeStarters[type].count + typeWeight[type]
            if randarr.count == 0
                randarr.push(x)
            else
                randarr.push(randarr[randarr.count - 1] + x)
            end
        end
        y = rand(0..randarr[randarr.count-1])
        for i in 0..randarr.count-1
            if i == randarr.count-1 || (randarr[i] <= y && randarr[i+1] > y)
                chosenTypes.push(typeArr[i])
                typeArr.delete_at(i)
                break
            end
        end
    end
    
    chosenPkmn = []

    for i in chosenTypes
        pkmnarr = typeStarters[i]
        x = rand(0..pkmnarr.count-1)
        chosenPkmn.push(pkmnarr[x])
    end
    return chosenPkmn
end
