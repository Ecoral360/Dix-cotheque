utiliser jeu {*}

utiliser coeur {jouerPartie}
utiliser strategie {Strategie}

classe Etat
fin classe

fonction miser(etat: Etat, jeu: Jeu) -> entier
    retourner 0
fin fonction

fonction choisirCarte(etat: Etat, jeu: Jeu) -> Carte 
    cartesJouables = jeu.cartesJouables()
    retourner cartesJouables[0]
fin fonction


fonction debut()
    etat = Etat()
    strategie = Strategie(fonction(jeu): miser(etat, jeu), 
                          fonction(jeu): choisirCarte(etat, jeu))

    jouerPartie(strategie)
fin fonction


debut()
