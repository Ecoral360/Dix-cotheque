utiliser Iter {filtrer}

const NB_JOUEURS = 4

const SUITS =  ["C", "D", "H", "S"]
const RANKS =  ["5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
const SCORES = [5, 0, 0, 0, 0, 10, 0, 0, 0, 10]

const NB_SUITS = tailleDe(SUITS)
const NB_RANKS = tailleDe(RANKS)

classe Carte
    const suit: texte # SUITS
    const rank: texte # RANKS

    init(suit: texte, rank: texte)
        inst.suit = suit 
        inst.rank = rank
    fin init

    methode ordreSuit() -> entier
        retourner indexDe(SUITS, inst.suit)
    fin methode

    methode ordreRank() -> entier
        retourner indexDe(RANKS, inst.rank)
    fin methode

    methode __texte__() -> texte
        retourner inst.suit + inst.rank
    fin methode
fin classe

classe LeveeCourante
    var cartes: liste = []  # de [joueurId, carte]
    var suivi: texte? = nul # SUITS
    var atout: texte? = nul # SUITS

    methode jouer(joueur: entier, carte: Carte)
        si inst.atout == nul alors
            inst.atout = carte.suit
        fin si

        si inst.suivi == nul alors
            inst.suivi = carte.suit
        fin si

        inst.cartes += [joueur, carte]
    fin methode

    methode estPleine() -> booleen
        retourner tailleDe(inst.cartes) == NB_JOUEURS
    fin methode

    methode estVide() -> booleen
        retourner tailleDe(inst.cartes) == 0
    fin methode

    methode clear()
        inst.suivi = nul
        inst.cartes = []
    fin methode

    methode getCurrentTrickWinner() -> entier?
        si inst.estVide()
            retourner nul
        fin si

        var meilleureJoueur = nul
        var meilleurScore = -1
        pour joueur, carte dans inst.cartes
            var ordre = s.ordreSuit()
            si s == inst.atout alors 
                ordre = 5
            sinon si s == inst.suivi alors
                ordre = 4
            fin si

            const score = NB_RANKS * ordre + carte.ordreRank()

            si score > meilleurScore alors
                meilleureJoueur = joueur
            fin si
        fin pour

        retourner joueur
    fin methode
fin classe

classe Levee 
    var cartes: [[entier, Carte], [entier, Carte], [entier, Carte], [entier, Carte]]
    var gagnant: entier # PlayerId

    init(cartes: [[entier, Carte], [entier, Carte], [entier, Carte], [entier, Carte]], 
         gagnant: entier)
        inst.cartes = cartes
        inst.gagnant = gagnant
    fin init
fin classe

classe Round 
    var historique: liste = [] # Levee
    var leveeCourante: LeveeCourante = LeveeCourante()
    var atout: texte? = nul # SUITS

    methode jouerCarte(joueur: entier, carte: Carte)
        si inst.atout == nul
            inst.atout = carte.suit
        fin si

        inst.leveeCourante.jouer(joueur, carte)

        si inst.leveeCourante.estPleine()
            inst.historique += inst.leveeCourante
            inst.leveeCourante.clear()
        fin si
    fin methode

fin classe

classe Main
    var cartes: liste # Carte

    init(cartes: liste)
        inst.cartes = cartes
    fin init

    methode cartesJouables(leveeCourante: LeveeCourante) -> liste#[Carte]
        retourner inst.cartes si leveeCourante.estVide()

        suivi = leveeCourante.suivi
        suivis = filtrer(fonction(carte): carte.suit == suivi, inst.cartes)

        retourner inst.cartes si tailleDe(suivis) == 0

        retourner suivis
    fin methode
fin classe

classe RapportMise
    var mises: [entier, entier, entier, entier] = [0, 0, 0, 0]
    var gagnant: entier? = nul # PlayerId?
fin classe

classe Jeu
    const moi: entier 
    var main: Main
    var rapportMise = RapportMise()
    var round: Round = Round()

    init(moi: entier, main: Main)
        inst.moi = moi
        inst.main = main
    fin init

    methode atout() -> texte? # SUITS?
        retourner inst.round.atout
    fin methode

    (-:
        Retourne la valeur de la mise gagnante actuelle
        (ou nul s'il n'y a pas de mise gagnante actuellement)
    :-)
    methode miseGagnante() -> entier?
        gagnant = inst.rapportMise.gagnant
        retourner nul si gagnant == nul
        retourner inst.rapportMise.mises[gagnant]
    fin methode

    methode joueurMise(joueur: entier, mise: entier)
        si mise != 0
            inst.rapportMise.gagnant = joueur
            inst.rapportMise.mises[joueur] = mise
        fin si
    fin methode

    methode jouerCarte(carte: Carte)
        inst.main.cartes = filtrer(fonction(c): c != carte, inst.main.cartes)
    fin methode

    methode carteJouee(joueur: entier, carte: Carte)
        inst.round.jouerCarte(joueur, carte)
    fin methode

    methode cartesJouables() -> liste#[Carte]
        retourner inst.main.cartesJouables(inst.round.leveeCourante)
    fin methode
fin classe
