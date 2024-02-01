utiliser jeu {*}
utiliser strategie {Strategie}

utiliser Texte {remplacer, couper}
utiliser Iter {map}


fonction lireStrip(stripped: texte) -> texte
    lire foo, ""
    retourner remplacer(foo, stripped, "", 1)
fin fonction

fonction get_moi() -> entier
    retourner entier(lireStrip("player "))
fin fonction

fonction get_main(ligne: texte) -> Main 
    const cartesTxt = couper(remplacer(ligne, "hand ", "", 1), " ")
    var cartes = map(fonction(carte): Carte(carte[0], carte[1]), cartesTxt)

    retourner Main(cartes)
fin fonction

fonction tourDeMise(jeu: Jeu, faireMise: fonction)
    var pass = 0
    var aMise = [faux] * NB_JOUEURS
    
    const tousMise = [vrai] * NB_JOUEURS

    tant que pass < NB_JOUEURS - 1 ou aMise != tousMise faire
        const ligne = lireStrip("bid ")

        si ligne == "?" alors
            afficher faireMise(jeu)
            continuer
        fin si

        joueur, mise = map(entier, couper(ligne, " ", 1))

        jeu.joueurMise(joueur, mise)

        si mise == 0 alors 
            pass += 1
        fin si

        aMise[joueur] = vrai
    fin tant que
fin fonction

fonction jouerLevee(jeu: Jeu, choisirCarte: fonction)
    aJoue = 0

    tant que aJoue < NB_JOUEURS faire
        const ligne = lireStrip("card ")

        si ligne == "?" alors
            carte = choisirCarte(jeu)
            jeu.jouerCarte(carte)
            afficher carte
            continuer
        fin si

        joueur, carte = couper(ligne, " ", 1)

        joueur = entier(joueur)
        carte = Carte(carte[0], carte[1])

        jeu.carteJouee(joueur, carte)

        aJoue += 1
    fin tant que
fin fonction

fonction jouerRound(moi: entier, strategie: Strategie) -> booleen
    lire ligne, ""

    retourner faux si ligne == "end"

    main = get_main(ligne)
    nbLevees = tailleDe(main.cartes)

    jeu = Jeu(moi, main)

    tourDeMise(jeu, strategie.faireMise)

    repeter nbLevees
        jouerLevee(jeu, strategie.choisirCarte)
    fin repeter

    retourner vrai

fin fonction


fonction jouerPartie(strategie: Strategie)
    moi = get_moi()

    tant que jouerRound(moi, strategie)
    fin tant que

fin fonction
