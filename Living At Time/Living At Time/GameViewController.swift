//
//  GameViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 02/04/2024.
//

import UIKit
import AVKit
import AVFoundation

// Classe qui représente une carte événement.
class GameEvent {
    var caracter : String
    var request : String
    var answerA : String
    var answerB : String
    var condition : Int
    var offsetA : Int
    var offsetB : Int
    
    var influenceReligionA : Int
    var influencePopulationA : Int
    var influenceArmyA : Int
    var influenceWealthA : Int
    var influenceElectionA : Int
    
    var influenceReligionB : Int
    var influencePopulationB : Int
    var influenceArmyB : Int
    var influenceWealthB : Int
    var influenceElectionB : Int
    
    init(caracter: String, request: String, answerA: String,  influenceReligionA: Int = 0, influencePopulationA: Int = 0, influenceArmyA: Int = 0, influenceWealthA: Int = 0, influenceElectionA: Int = 0, answerB: String, influenceReligionB: Int = 0, influencePopulationB: Int = 0, influenceArmyB: Int = 0, influenceWealthB: Int = 0, influenceElectionB: Int = 0, condition: Int = 0, offsetA: Int = 0, offsetB : Int = 0) {
        self.caracter = caracter
        self.request = request
        self.answerA = answerA
        self.answerB = answerB
        self.influenceReligionA = influenceReligionA
        self.influencePopulationA = influencePopulationA
        self.influenceArmyA = influenceArmyA
        self.influenceWealthA = influenceWealthA
        self.influenceElectionA = influenceElectionA
        self.influenceReligionB = influenceReligionB
        self.influencePopulationB = influencePopulationB
        self.influenceArmyB = influenceArmyB
        self.influenceWealthB = influenceWealthB
        self.influenceElectionB = influenceElectionB
        self.condition = condition
        self.offsetA = offsetA
        self.offsetB = offsetB
    }
    
    func addCondition(_ cond : Int) {
        self.condition  = cond
    }
    
    func addOffsetA(_ offset : Int) {
        self.offsetA = offset
    }
    
    func addOffsetB(_ offset : Int) {
        self.offsetB = offset
    }
    
    var description : String {
        return "Caracter: \(caracter), Request: \(request), AnswerA: \(answerA), influenceReligionA: \(influenceReligionA), influencePopulationA: \(influencePopulationA), influenceArmyA: \(influenceArmyA), influenceWealthA: \(influenceWealthA), influenceElectionA: \(influenceElectionA), answerB: \(answerB), influenceReligionB: \(influenceReligionB), influencePopulationB: \(influencePopulationB), influenceArmyB: \(influenceArmyB), influenceWealthB: \(influenceWealthB), influenceElectionB: \(influenceElectionB)"
    }
}

// Limite de la jauge pour les 4 statistiques de jeu
let MAX_COUNT : Int = 8

class GameViewController: UIViewController {
    // Variables pour la gestion de la galerie
    var successList: [String:Bool] = ["success1":false, "success2":false, "success3":false]
    
    var characters: [String:Bool] = ["mage":false, "paysan":false, "paysanne":false, "marchand":false, "reine":false, "chevalier":false, "templier":false, "ninja":false, "moine":false, "courtisane":false, "pape":false, "cultiste":false, "princesse":false, "seigneur":false, "conseiller":false, "viking":false, "chevalier_creuset":false, "robin":false, "assassin":false, "archer":false, "developpeur":false, "fille":false]
    
    // Variables de gestion du jeu
    var personnage : [String : String] = ["mage" : "???", "paysan": "Goedfrey", "paysanne": "Helen", "marchand": "Otto Suwen", "reine": "Rose Oriana", "chevalier": "Rodrigo", "templier": "Hugues de Payns", "ninja": "Sakata Gintoki", "moine": "Frère Tuc", "courtisane": "Roxanne", "pape": "Benoit Ier", "cultiste": "Petelgeuse Romanee-conti", "princesse": "Lily Oriana", "seigneur": "Charles Arbor", "conseiller": "Alfred", "viking" : "Kerøsen", "chevalier_creuset" : "Ordovis", "robin":"Robin des bois", "assassin":"Silencieux", "archer":"Andrew Gilbert", "developpeur":"Guilaume & Flavien", "fille":"Lily"]
    
    var load : Bool = false
    var religionCount : Int = 4
    var populationCount : Int = 4
    var armyCount : Int = 4
    var wealthCount : Int = 4
    var popularityCount : Int = 50
    var timeCount: Int = 25
    var imageTouch : Bool = false
    var coordImage : CGPoint = CGPoint()
    var coordAnswerA : CGPoint = CGPoint()
    var coordAnswerB : CGPoint = CGPoint()
    var lastLocation : CGPoint = CGPoint()
    var pointInit : CGPoint = CGPoint()
    var totalAlpha : Double = 0.0
    var lastTotalAlpha : Double = 0.0
    var actualYear : Int = 1350
    var actualDay : Int = 29
    var gameYear : Int = 0
        
    // Variables des objets de la vue
    @IBOutlet weak var religion: UIImageView!
    @IBOutlet weak var population: UIImageView!
    @IBOutlet weak var army: UIImageView!
    @IBOutlet weak var wealth: UIImageView!
    
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var caracterImage: UIImageView!
    
    @IBOutlet var influenceInformations: [UIImageView]!
    
    // Variable pour gérer la musique du jeu
    var music: AVAudioPlayer?
    
    // Variables liées aux événements et à leurs gestions
    var actualEvent : GameEvent = GameEvent(caracter: "", request: "", answerA: "", answerB: "")
    var event : [GameEvent] = []
    var mageEvent : [GameEvent] = []
    var mageEvent1399 : [GameEvent] = []
    
    var condMage1399 : Bool = false
    var eventMage1399 : Bool = false
    var secondGame : Bool = false
    
    var gameOverWealth : [GameEvent] = []
    var gameOverArmy : [GameEvent] = []
    var gameOverPopulation : [GameEvent] = []
    var gameOverReligion : [GameEvent] = []
    var gameOverElection : [GameEvent] = []
    var gameOverFirst : [GameEvent] = []
    
    var electionEvent : [GameEvent] = []
    var firstElectionEvent : [GameEvent] = []
    var victoryElectionEvent : [GameEvent] = []
    
    var eventPreventRobin : GameEvent = GameEvent(caracter: "", request: "", answerA: "", answerB: "")
    var robinEvent : [GameEvent] = []
    var robinMeeting : [GameEvent] = []
    var robinDeath : [GameEvent] = []
    var gameEventRobin : [GameEvent] = []
    
    var indMortEvent : Int = 0
    var indElectionEvent : Int = 0
    var indMageEvent : Int = 0
    var indRobin : Int = 0
    
    var firstLife : Bool = true
    var secondLife : Bool = false
    var firstElection : Bool = true
    var resultatElection : Bool = false
    var deathElection : Bool = false
    
    var condRobin : Bool = false
    var robinMeet : Bool = false
    var robinDeathBool : Bool = false
    var eventRobinDeath : Bool = false
    var robinIsHere : Bool = false
    
    var eventSouvenir : [GameEvent] = []
    
    var endEventSouvenir : Bool = false
    var indEventSouvenir : Int = 0
    
    var templierMeeting : [GameEvent] = []
    var templierEvent : [GameEvent] = []
    var gameEventTemplier : [GameEvent] = []
    var assassinMeeting : [GameEvent] = []
    var assassinEvent : [GameEvent] = []
    var gameEventAssassin : [GameEvent] = []
    var templierAssassinDeath : [GameEvent] = []
    
    var indEventTemplierAssassin : Int = 0
    var templierMeet : Bool = false
    var assassinMeet : Bool = false
    var templierAssasinDeathBool : Bool = false
    var condTemplier : Bool = false
    var condAssassin : Bool = false
    var eventTemplierAssasinDeath : Bool = false
    
    var ninjaMeeting : [GameEvent] = []
    var ninjaEvent : [GameEvent] = []
    var gameEventNinja : [GameEvent] = []
    var ninjaDeath : [GameEvent] = []
    
    var indEventNinja : Int = 0
    var condNinja : Bool = false
    var ninjaMeet : Bool = false
    var ninjaDeathBool : Bool = false
    var eventNinjaDeath : Bool = false
    
    var creusetMeeting : [GameEvent] = []
    var creusetEvent : [GameEvent] = []
    var gameEventCreuset : [GameEvent] = []
    var creusetDeath : [GameEvent] = []
    
    var indEventCreuset : Int = 0
    var condCreuset : Bool = false
    var creusetMeet : Bool = false
    var creusetDeathBool : Bool = false
    var eventCreusetDeath : Bool = false
    
    var cultisteMeeting : [GameEvent] = []
    var cultisteEvent : [GameEvent] = []
    var gameEventCultiste : [GameEvent] = []
    var cultisteDeath : [GameEvent] = []
    
    var indCultiste : Int = 0
    var condCultiste : Bool = false
    var cultisteMeet : Bool = false
    var cultisteDeathBool : Bool = false
    var eventCultisteDeath : Bool = false
    
    var eventPreCultiste : GameEvent = GameEvent(caracter: "", request: "", answerA: "", answerB: "")
    var preCultiste : Bool =  false
    
    var endGame : [GameEvent] = []
    var credits : [GameEvent] = []
    
    var indRevelation : Int = -1
    var indCredit : Int = 0
    var condRevelation : Bool = false
    var eventRevelation : Bool = false
    var eventCredits : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gestion de la musique du jeu
        let musicPath = Bundle.main.path(forResource: "musicGame", ofType: "mp3")!
        let musicUrl = URL(fileURLWithPath: musicPath)
        
        do {
            music = try AVAudioPlayer(contentsOf:musicUrl)
            music!.numberOfLoops = -1
            music!.play()
        } catch {
            print("ERROR - fail to init the music")
        }
        
        // Sauvegarde des coordonnées, on masque les réponses
        answerA.layer.opacity = 0
        answerB.layer.opacity = 0
        coordImage = caracterImage.center
        coordAnswerA = answerA.center
        coordAnswerB = answerB.center
        
        /* On récupère les données de la dernière partie dans le fichier save.txt
         S'il n'y a pas de dernière partie, on part sur une nouvelle partie */
        loadGame()
        updateScreen()
        
        // Lecture des événements du jeu
        mageEvent = lectureEvent(nomfichier: "mageEvent", offset: false, value: false)
        event = lectureEvent(nomfichier: "GameEvent", offset: false, value: true)
        gameOverArmy = lectureEvent(nomfichier: "GameOverMillitaire", offset: false, value: false)
        gameOverWealth = lectureEvent(nomfichier: "GameOverWealth", offset: false, value: false)
        gameOverElection = lectureEvent(nomfichier: "GameOverElection", offset: false, value: false)
        gameOverPopulation = lectureEvent(nomfichier: "GameOverPopulation", offset: false, value: false)
        gameOverReligion = lectureEvent(nomfichier: "GameOverReligion", offset: false, value: false)
        gameOverFirst = lectureEvent(nomfichier: "GameOverFirst", offset: false, value: false)
        electionEvent = lectureEvent(nomfichier: "electionEvent", offset: false, value: false)
        firstElectionEvent = lectureEvent(nomfichier: "firstElectionEvent", offset: false, value: false)
        victoryElectionEvent = lectureEvent(nomfichier: "victoryElectionEvent", offset: false, value: false)
        
        // Lecture des événements unique du jeu
        var t = lectureEvent(nomfichier: "GameEventUnique", offset: false, value: false)
        eventPreventRobin = t.removeFirst()
        for _ in 0...2 {
            eventSouvenir.append(t.removeFirst())
        }
        eventPreCultiste = t.removeFirst()
        mageEvent1399 = t
        
        // Lecture des événements liés au personnage de Robin des Bois
        robinMeeting = lectureEvent(nomfichier: "RobinMeeting", offset: false, value: false)
        robinEvent = lectureEvent(nomfichier: "RobinEvent", offset: false, value: true)
        gameEventRobin = lectureEvent(nomfichier: "GameEventRobin", offset: false, value: true)
        robinDeath = lectureEvent(nomfichier: "RobinDeath", offset: true, value: false)
        
        if robinIsHere {
            event.append(contentsOf: gameEventRobin)
            if robinMeet && !robinDeathBool {
                event.append(contentsOf: robinEvent)
            }
        }
        if robinDeathBool {
            personnage["mage"] = "Firo Prochainezo"
        }
        
        // Lecture des événements liés aux Templiers et Assassins
        templierMeeting = lectureEvent(nomfichier: "TemplierMeeting", offset: false, value: false)
        templierEvent = lectureEvent(nomfichier: "TemplierEvent", offset: false, value: true)
        gameEventTemplier = lectureEvent(nomfichier: "GameEventTemplier", offset: false, value: true)
        assassinMeeting = lectureEvent(nomfichier: "AssassinMeeting", offset: false, value: false)
        assassinEvent = lectureEvent(nomfichier: "AssassinEvent", offset: false, value: true)
        gameEventAssassin = lectureEvent(nomfichier: "GameEventAssassin", offset: false, value: true)
        templierAssassinDeath = lectureEvent(nomfichier: "TemplierAssassinDeath", offset: false, value: false)
        
        if templierMeet {
            event.append(contentsOf: gameEventTemplier)
            if assassinMeet {
                event.append(contentsOf: gameEventAssassin)
            }
            if !templierAssasinDeathBool {
                event.append(contentsOf: templierEvent)
                event.append(contentsOf: assassinEvent)
            }
        }
        
        // Lecture des événements liés au Ninja
        ninjaMeeting = lectureEvent(nomfichier: "ninjaMeeting", offset: false, value: false)
        ninjaEvent = lectureEvent(nomfichier: "NinjaEvent", offset: false, value: true)
        gameEventNinja = lectureEvent(nomfichier: "GameEventNinja", offset: false, value: true)
        ninjaDeath = lectureEvent(nomfichier: "NinjaDeath", offset: true, value: false)
        
        if ninjaMeet {
            event.append(contentsOf: gameEventNinja)
            if !ninjaDeathBool {
                event.append(contentsOf: ninjaEvent)
            }
        }
        
        // Lecture des événements liés au Chevalier du Creuset
        creusetMeeting = lectureEvent(nomfichier: "ChevalierCreusetMeeting", offset: false, value: false)
        creusetEvent = lectureEvent(nomfichier: "ChevalierCreusetEvent", offset: false, value: true)
        gameEventCreuset = lectureEvent(nomfichier: "GameEventChevalierCreuset", offset: false, value: true)
        creusetDeath = lectureEvent(nomfichier: "ChevalierCreusetDeath", offset: false, value: false)
        
        if creusetMeet {
            event.append(contentsOf: gameEventCreuset)
            if !creusetDeathBool {
                event.append(contentsOf: creusetEvent)
            }
        }
        
        // Lecture des événements liés au personnage de l'adepte
        cultisteMeeting = lectureEvent(nomfichier: "CultisteMeeting", offset: false, value: false)
        cultisteEvent = lectureEvent(nomfichier: "CultisteEvent", offset: false, value: true)
        gameEventCultiste = lectureEvent(nomfichier: "GameEventCultiste", offset: false, value: true)
        cultisteDeath = lectureEvent(nomfichier: "CultisteDeath", offset: true, value: false)
        
        if cultisteMeet {
            event.append(contentsOf: gameEventCultiste)
            if !cultisteDeathBool {
                event.append(contentsOf: cultisteEvent)
            }
        }
        
        endGame = lectureEvent(nomfichier: "EndGame", offset: true, value: false)
        credits = lectureEvent(nomfichier: "Credits", offset: false, value: false)
        
        if !load {
            // Début de partie, on lance les événements liés au Mage
            loadRequest(mageEvent[indMageEvent])
            actualEvent = mageEvent[indMageEvent]
            indMageEvent += 1
        } else {
            // On joue de façon aléatoire les événements des autres personnages
            changeEvent(totalAlpha >= 0 ? true : false, first : true)
        }
    }
    
    // Méthode qui sauvegarde les données importantes de la partie dans le fichier save.txt
    func saveGame() {
        //let saveUrl : URL = Bundle.main.url(forResource: "save", withExtension: "txt")!
        var saveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        saveUrl = saveUrl.appendingPathComponent("save.txt")
        var strToSave : String = ""
        strToSave.append(String(religionCount) + "\n")
        strToSave.append(String(populationCount) + "\n")
        strToSave.append(String(armyCount) + "\n")
        strToSave.append(String(wealthCount) + "\n")
        strToSave.append(String(popularityCount) + "\n")
        strToSave.append(String(timeCount) + "\n")
        strToSave.append(String(actualYear) + "\n")
        strToSave.append(String(actualDay) + "\n")
        strToSave.append(String(firstElection) + "\n")
        strToSave.append(String(resultatElection) + "\n")
        strToSave.append(String(deathElection) + "\n")
        strToSave.append(String(condRobin) + "\n")
        strToSave.append(String(robinMeet) + "\n")
        strToSave.append(String(robinDeathBool) + "\n")
        strToSave.append(String(eventRobinDeath) + "\n")
        strToSave.append(String(robinIsHere) + "\n")
        strToSave.append(String(templierMeet) + "\n")
        strToSave.append(String(assassinMeet) + "\n")
        strToSave.append(String(templierAssasinDeathBool) + "\n")
        strToSave.append(String(condTemplier) + "\n")
        strToSave.append(String(condAssassin) + "\n")
        strToSave.append(String(eventTemplierAssasinDeath) + "\n")
        strToSave.append(String(condNinja) + "\n")
        strToSave.append(String(ninjaMeet) + "\n")
        strToSave.append(String(ninjaDeathBool) + "\n")
        strToSave.append(String(eventNinjaDeath) + "\n")
        strToSave.append(String(firstLife) + "\n")
        strToSave.append(String(secondLife) + "\n")
        strToSave.append(String(condCreuset) + "\n")
        strToSave.append(String(creusetMeet) + "\n")
        strToSave.append(String(creusetDeathBool) + "\n")
        strToSave.append(String(eventCreusetDeath) + "\n")
        strToSave.append(String(condMage1399) + "\n")
        strToSave.append(String(eventMage1399) + "\n")
        strToSave.append(String(condCultiste) + "\n")
        strToSave.append(String(cultisteMeet) + "\n")
        strToSave.append(String(cultisteDeathBool) + "\n")
        strToSave.append(String(eventCultisteDeath) + "\n")
        strToSave.append(String(preCultiste) + "\n")
        strToSave.append(String(secondGame) + "\n")
        
        for (car, see) in characters {
            strToSave.append("\(car);\(see)\n")
        }
        for (success, s) in successList {
            strToSave.append("\(success);\(s)\n")
        }
        do {
            print(strToSave)
            try strToSave.write(to: saveUrl, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
    
    // Méthode qui charge les donnée du jeu, on récupère la partie
    func loadGame() {
        var saveUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        saveUrl = saveUrl.appendingPathComponent("save.txt")
    
        do {
            let strSave = try String(contentsOf: saveUrl)
            let strSaveLine = strSave.components(separatedBy: .newlines)
            if  religionCount               != Int(strSaveLine[0])!     ||
                populationCount             != Int(strSaveLine[1])!     ||
                armyCount                   != Int(strSaveLine[2])!     ||
                wealthCount                 != Int(strSaveLine[3])!     ||
                popularityCount             != Int(strSaveLine[4])!     ||
                timeCount                   != Int(strSaveLine[5])!     ||
                actualYear                  != Int(strSaveLine[6])!     ||
                firstElection               != Bool(strSaveLine[8])!    ||
                actualDay                   != Int(strSaveLine[7])!     ||
                resultatElection            != Bool(strSaveLine[9])!    ||
                deathElection               != Bool(strSaveLine[10])!   ||
                condRobin                   != Bool(strSaveLine[11])!   ||
                robinMeet                   != Bool(strSaveLine[12])!   ||
                robinDeathBool              != Bool(strSaveLine[13])!   ||
                eventRobinDeath             != Bool(strSaveLine[14])!   ||
                robinIsHere                 != Bool(strSaveLine[15])!   ||
                templierMeet                != Bool(strSaveLine[16])!   ||
                assassinMeet                != Bool(strSaveLine[17])!   ||
                templierAssasinDeathBool    != Bool(strSaveLine[18])!   ||
                condTemplier                != Bool(strSaveLine[19])!   ||
                condAssassin                != Bool(strSaveLine[20])!   ||
                eventTemplierAssasinDeath   != Bool(strSaveLine[21])!   ||
                condNinja                   != Bool(strSaveLine[22])!   ||
                ninjaMeet                   != Bool(strSaveLine[23])!   ||
                ninjaDeathBool              != Bool(strSaveLine[24])!   ||
                eventNinjaDeath             != Bool(strSaveLine[25])!   ||
                firstLife                   != Bool(strSaveLine[26])!   ||
                secondLife                  != Bool(strSaveLine[27])!   ||
                condCreuset                 != Bool(strSaveLine[28])!   ||
                creusetMeet                 != Bool(strSaveLine[29])!   ||
                creusetDeathBool            != Bool(strSaveLine[30])!   ||
                eventCreusetDeath           != Bool(strSaveLine[31])!   ||
                condMage1399                != Bool(strSaveLine[32])!   ||
                eventMage1399               != Bool(strSaveLine[33])!   ||
                condCultiste                != Bool(strSaveLine[34])!   ||
                cultisteMeet                != Bool(strSaveLine[35])!   ||
                cultisteDeathBool           != Bool(strSaveLine[36])!   ||
                eventCultisteDeath          != Bool(strSaveLine[37])!   ||
                preCultiste                 != Bool(strSaveLine[38])!   ||
                secondGame                  != Bool(strSaveLine[39])!{
                load = true
            }
            if load {
                religionCount               = Int(strSaveLine[0])!
                populationCount             = Int(strSaveLine[1])!
                armyCount                   = Int(strSaveLine[2])!
                wealthCount                 = Int(strSaveLine[3])!
                popularityCount             = Int(strSaveLine[4])!
                timeCount                   = Int(strSaveLine[5])!
                actualYear                  = Int(strSaveLine[6])!
                actualDay                   = Int(strSaveLine[7])!
                firstElection               = Bool(strSaveLine[8])!
                resultatElection            = Bool(strSaveLine[9])!
                deathElection               = Bool(strSaveLine[10])!
                condRobin                   = Bool(strSaveLine[11])!
                robinMeet                   = Bool(strSaveLine[12])!
                robinDeathBool              = Bool(strSaveLine[13])!
                eventRobinDeath             = Bool(strSaveLine[14])!
                robinIsHere                 = Bool(strSaveLine[15])!
                templierMeet                = Bool(strSaveLine[16])!
                assassinMeet                = Bool(strSaveLine[17])!
                templierAssasinDeathBool    = Bool(strSaveLine[18])!
                condTemplier                = Bool(strSaveLine[19])!
                condAssassin                = Bool(strSaveLine[20])!
                eventTemplierAssasinDeath   = Bool(strSaveLine[21])!
                condNinja                   = Bool(strSaveLine[22])!
                ninjaMeet                   = Bool(strSaveLine[23])!
                ninjaDeathBool              = Bool(strSaveLine[24])!
                eventNinjaDeath             = Bool(strSaveLine[25])!
                firstLife                   = Bool(strSaveLine[26])!
                secondLife                  = Bool(strSaveLine[27])!
                condCreuset                 = Bool(strSaveLine[28])!
                creusetMeet                 = Bool(strSaveLine[29])!
                creusetDeathBool            = Bool(strSaveLine[30])!
                eventCreusetDeath           = Bool(strSaveLine[31])!
                condMage1399                = Bool(strSaveLine[32])!
                eventMage1399               = Bool(strSaveLine[33])!
                condCultiste                = Bool(strSaveLine[34])!
                cultisteMeet                = Bool(strSaveLine[35])!
                cultisteDeathBool           = Bool(strSaveLine[36])!
                eventCultisteDeath          = Bool(strSaveLine[37])!
                preCultiste                 = Bool(strSaveLine[38])!
                secondGame                  = Bool(strSaveLine[39])!
                var ind = 0
                for i in 0..<characters.count {
                    let car = String(strSaveLine[40+i].split(separator: ";")[0])
                    let see = Bool(String(strSaveLine[40+i].split(separator: ";")[1]))
                    characters[car] = see
                    ind += 1
                }
                for j in 0..<successList.count {
                    let successName = String(strSaveLine[40 + ind + j].split(separator: ";")[0])
                    let see = Bool(String(strSaveLine[40 + ind + j].split(separator: ";")[1]))
                    successList[successName] = see
                }
                updateScreen()
            }
            
        } catch {
            actualDay = 29
            saveGame()
            load = false
            
            print("Premier chargement de l'application : le fichier save.txt n'existe pas")
            print("ERROR -", error)
        }
        if firstLife && secondGame{
            load = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
        // Lorsque l'image est cliquée, on sauvegarde la position actuelle comme étant la dernière position touchée
        if caracterImage.frame.contains(p) {
            lastLocation = p
            pointInit = p
            imageTouch = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
        // On fait un mouvement avec l'image lorsqu'elle est cliquée
        if imageTouch {
            lastTotalAlpha = totalAlpha
            let bottomYImage = coordImage.y + (caracterImage.image?.size.height)!
            
            /* Le but est de représenter virtuellement un triangle rectangle afin de pouvoir calculer l'angle
            qu'il faudra appliquer à l'image lors d'un mouvement.
            
            On fait différent calcul afin de pouvoir récupérer la valeur de l'angle de rotation entre deux droites imaginaires
            la première est la droite entre la dernière position de clic de formule x = lastLocation.x sur laquelle il y a les points A et B
            la deuxième est la droite entre la dernière position de clic et la nouvelle position de formule y = lastLocation.y sur laquelle il y a les points B et C */
            let pointA = CGPoint(x: lastLocation.x, y: bottomYImage)
            let pointB = CGPoint(x: lastLocation.x, y: p.y)
            let pointC = p
            
            // Calcul de la distance entre les points B et C
            var distBC = pow((pointB.x - pointC.x), 2) + pow((pointB.y - pointC.y),2)
            distBC = sqrt(distBC)
            
            // Calcul de la distance entre les points A et C
            var distAC = pow((pointC.x - pointA.x), 2) + pow((pointC.y - pointA.y), 2)
            distAC = sqrt(distAC)
            
            // Calcul de l'angle entre les deux droites imaginaires
            var alpha = asin(distBC / distAC)
            
            if p.x < lastLocation.x {
                alpha = -alpha
            }
            totalAlpha += alpha
            
            //Je regarde l'angle total depuis le debut des mouvements et selon lui,
            //je change l'opacité des reponses (je sais pas si cela marche bien
            //d'augmenter l'opacité mais le principe est de n'afficher qu'une
            //réponse à la fois)
            if totalAlpha < 0 {
                answerA.layer.opacity = 0
                if totalAlpha < lastTotalAlpha && answerB.layer.opacity < 100 {
                    answerB.layer.opacity += 4
                } else {
                    answerB.layer.opacity -= 4
                }
            } else {
                answerB.layer.opacity = 0
                if totalAlpha > lastTotalAlpha && answerA.layer.opacity < 100 {
                    answerA.layer.opacity += 4
                } else {
                    answerA.layer.opacity -= 4
                }
            }
            // Partie pour gérer l'affichage du petit triangle vert ou rouge
            let influenceTabA: [Int] = [actualEvent.influenceReligionA, actualEvent.influencePopulationA, actualEvent.influenceArmyA, actualEvent.influenceWealthA]
            let influenceTabB: [Int] = [actualEvent.influenceReligionB, actualEvent.influencePopulationB, actualEvent.influenceArmyB, actualEvent.influenceWealthB]
            
            if answerA.layer.opacity > 0 {
                for i in 0...influenceTabA.count-1 {
                    if (influenceTabA[i] > 0) {
                        showInfluenceInformations(index: i, imageName: "increase")
                    } else if (influenceTabA[i] < 0 ) {
                        showInfluenceInformations(index : i, imageName:"decrease")
                    } else {
                        showInfluenceInformations(index : i, imageName:"vide")
                    }
                }
            } else if answerB.layer.opacity > 0 {
                for i in 0...influenceTabB.count-1 {
                    if (influenceTabB[i] > 0) {
                        showInfluenceInformations(index : i, imageName:"increase")
                    } else if (influenceTabB[i] < 0 ) {
                        showInfluenceInformations(index : i, imageName:"decrease")
                    } else {
                        showInfluenceInformations(index : i, imageName:"vide")
                    }
                }
            }
            
            // Calcul du déplacement en X et en Y
            let distX = lastLocation.x - p.x
            let distY = lastLocation.y - p.y
            
            // On applique les différentes transformations nécessaire à nos objets
            caracterImage.center.x -= distX
            caracterImage.center.y -= distY
            answerA.center.x -= distX
            answerA.center.y -= distY
            answerB.center.x -= distX
            answerB.center.y -= distY
            caracterImage.transform = caracterImage.transform.rotated(by: alpha)
            answerA.transform = answerA.transform.rotated(by: alpha)
            answerB.transform = answerB.transform.rotated(by: alpha)
            lastLocation = p //dernière position cliquée que l'on actualise
        }
    }
    
    // Méthode qui affiche les triangles vert ou rouge en fonction des données passés en paramètres
    func showInfluenceInformations(index : Int, imageName : String) {
        for influenceInfo in influenceInformations {
            let tag = influenceInfo.tag
            if tag == index {
                if imageName == "vide" {
                    influenceInfo.image = nil
                } else {
                    influenceInfo.image = UIImage(named:imageName)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Si l'image était touché, alors on réinitilaise les valeurs modifiées
        if imageTouch {
            answerA.layer.opacity = 0
            answerB.layer.opacity = 0
            answerA.center = coordAnswerA
            answerB.center = coordAnswerB
            caracterImage.center = coordImage
            caracterImage.transform = caracterImage.transform.rotated(by: -totalAlpha)
            answerA.transform = answerA.transform.rotated(by: -totalAlpha)
            answerB.transform = answerB.transform.rotated(by: -totalAlpha)
            if abs(totalAlpha) >= 0.18 {
                // On fait le changement d'événement pour afficher le suivant,
                // tout en tenant compte de la réponse choisie, en prenant l'angle obtenu donc
                changeEvent(totalAlpha >= 0 ? true : false)
            }
            
            for influenceInfo in influenceInformations {
                influenceInfo.image = nil
            }
            totalAlpha = 0
            imageTouch = false
        }
    }
    
    // Méthode qui lit les données, en tenant compte du format particulier de nos fichiers .txt
    func lectureEvent(nomfichier nom: String, extension e: String = "txt", offset o : Bool, value v : Bool) -> [GameEvent]{
        var t : [GameEvent] = []
        
        let eventUrl : URL = Bundle.main.url(forResource: nom, withExtension: e)!
        do{
            // On récupère le contenu du fichier, et on le découpe ligne par ligne
            let strEvent = try String(contentsOf: eventUrl)
            var strEventLine = strEvent.components(separatedBy: .newlines)
            var i = 0
            var nbEvent = 0
            // Au début de chaque fichier, on a le nombre de personnage différent
            let max = Int(strEventLine.removeFirst())!
            for j in 0..<max {
                // Pour chaque personnage, on a son nombre d'événement et son nom, séparé par un ;
                nbEvent += Int(strEventLine[(3*i)+j].split(separator: ";")[0])!
                let car = String(strEventLine[(3*i)+j].split(separator: ";")[1])
                while i < nbEvent {
                    var tmpEvent : GameEvent
                    if v {
                        let strAnswerA = strEventLine[(3*i)+2+j].split(separator: ";")
                        let strAnswerB = strEventLine[(3*i)+3+j].split(separator: ";")
                        tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i)+1+j], answerA: String(strAnswerA[0]), influenceReligionA: Int(strAnswerA[1])!, influencePopulationA: Int(strAnswerA[2])!, influenceArmyA:Int(strAnswerA[3])!, influenceWealthA: Int(strAnswerA[4])!, influenceElectionA: Int(strAnswerA[5])!, answerB: String(strAnswerB[0]), influenceReligionB: Int(strAnswerB[1])!, influencePopulationB: Int(strAnswerB[2])!, influenceArmyB: Int(strAnswerB[3])!, influenceWealthB: Int(strAnswerB[4])!, influenceElectionB: Int(strAnswerB[5])!)
                    } else {
                        if o {
                            let strAnswerA = strEventLine[(3*i)+2+j].split(separator: ";")
                            let strAnswerB = strEventLine[(3*i)+3+j].split(separator: ";")
                            tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i+1+j)], answerA: String(strAnswerA[0]), answerB: String(strAnswerB[0]))
                            tmpEvent.addOffsetA(Int(strAnswerA[1])!)
                            tmpEvent.addOffsetB(Int(strAnswerB[1])!)
                        }else{
                            tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i+1+j)], answerA: strEventLine[(3*i)+2+j], answerB: strEventLine[(3*i)+3+j])
                        }
                    }
                    i += 1
                    t.append(tmpEvent)
                }
            }
        } catch {
            print(error)
        }
        
        return t
    }
    
    // Méthode qui fait la différence entre les cartes personnages et les cartes Mort, Inconnu etc.
    func isCharacter(_ car : String) -> Bool{
        return car != "inconnu" && car != "mort" && car != "" && car != "success1" && car != "success2" && car != "success3"
    }
    
    // Méthode qui change d'événement en fonction de la situation dans le jeu
    func changeEvent(_ answerA : Bool, first : Bool = false){
        if first {
            actualDay = 0
        }
        
        if isCharacter(actualEvent.caracter) {
            characters[actualEvent.caracter] = true
        }
        
        var eventTmp : GameEvent
        
        // Gestion des événement liés au temps dans le jeu
        if actualYear == 1360 && !robinIsHere {
            robinIsHere = true
            event.append(contentsOf: gameEventRobin)
            changeDay()
            saveGame()
            eventTmp = eventPreventRobin
            actualEvent = eventTmp
            loadRequest(eventTmp)
            updateScreen()
            return
        } else if actualYear == 1362{
            condRobin = true
        } else if actualYear == 1365 && !endEventSouvenir {
            eventTmp = eventSouvenir[indEventSouvenir]
            indEventSouvenir += 1
            if indEventSouvenir >= eventSouvenir.count {
                indEventSouvenir = 0
                endEventSouvenir = true
                changeDay()
                saveGame()
            }
            actualEvent = eventTmp
            loadRequest(eventTmp)
            updateScreen()
            return
        } else if actualYear == 1369 && !robinDeathBool{
            robinDeathBool = true
            eventRobinDeath = true
            indRobin = -1
        } else if actualYear == 1370 {
            condTemplier = true
        } else if actualYear == 1371 {
            condAssassin = true
        } else if actualYear == 1377{
            condNinja = true
        } else if actualYear == 1381 && !templierAssasinDeathBool {
            templierAssasinDeathBool = true
            eventTemplierAssasinDeath = true
        } else if actualYear == 1388 {
            condCreuset = true
        } else if actualYear == 1399 && !condMage1399 {
            condMage1399 = true
            eventMage1399 = true
        } else if actualYear == 1404 {
            condCultiste = true
        } else if actualYear == 1407 && !ninjaDeathBool {
            ninjaDeathBool = true
            eventNinjaDeath = true
            indEventNinja = -1
        } else if actualYear == 1412 && !creusetDeathBool {
            creusetDeathBool = true
            eventCreusetDeath = true
        } else if actualYear == 1419 && preCultiste {
            preCultiste = true
            changeDay()
            saveGame()
            eventTmp = eventPreCultiste
            actualEvent = eventTmp
            loadRequest(eventTmp)
            updateScreen()
            return
        } else if actualYear == 1420 && !cultisteDeathBool {
            cultisteDeathBool = true
            eventCultisteDeath = true
        } else if actualYear == 1421 && actualDay >= 200 && !eventCredits{
            condRevelation = true
            eventRevelation = true
        }
        
        // Gestion de l'impact de la réponse sur les 5 statistiques du jeu
        if answerA {
            if (popularityCount + actualEvent.influenceElectionA <= 100 || actualEvent.influenceElectionA < 0) && popularityCount + actualEvent.influenceElectionA >= 0 {
                popularityCount += actualEvent.influenceElectionA
            } else if actualEvent.influenceElectionA == 20 && popularityCount + 10 <= MAX_COUNT {
                popularityCount += 10
            } else if actualEvent.influenceElectionA == -20 && popularityCount - 10 >= 0 {
                popularityCount -= 10
            }
            if (religionCount + actualEvent.influenceReligionA <= MAX_COUNT || actualEvent.influenceReligionA < 0) && religionCount + actualEvent.influenceReligionA >= 0 {
                religionCount += actualEvent.influenceReligionA
            } else if actualEvent.influenceReligionA == 2 && religionCount + 1 <= MAX_COUNT {
                religionCount += 1
            } else if actualEvent.influenceReligionA == -2 && religionCount - 1 >= 0 {
                religionCount -= 1
            }
            if (populationCount + actualEvent.influencePopulationA <= MAX_COUNT || actualEvent.influencePopulationA < 0) && populationCount + actualEvent.influencePopulationA >= 0 {
                populationCount += actualEvent.influencePopulationA
            } else if actualEvent.influencePopulationA == 2 && populationCount + 1 <= MAX_COUNT {
                populationCount += 1
            } else if actualEvent.influencePopulationA == -2 && populationCount - 1 >= 0 {
                populationCount -= 1
            }
            if (armyCount + actualEvent.influenceArmyA <= MAX_COUNT || actualEvent.influenceArmyA < 0) && armyCount + actualEvent.influenceArmyA >= 0 {
                armyCount += actualEvent.influenceArmyA
            } else if actualEvent.influenceArmyA == 2 && armyCount + 1 <= MAX_COUNT {
                armyCount += 1
            } else if actualEvent.influenceArmyA == -2 && armyCount - 1 >= 0 {
                armyCount -= 1
            }
            if (wealthCount + actualEvent.influenceWealthA <= MAX_COUNT || actualEvent.influenceWealthA < 0) && wealthCount + actualEvent.influenceWealthA >= 0 {
                wealthCount += actualEvent.influenceWealthA
            } else if actualEvent.influenceWealthA == 2 && wealthCount + 1 <= MAX_COUNT {
                wealthCount += 1
            } else if actualEvent.influenceWealthA == -2 && wealthCount - 1 >= 0 {
                wealthCount -= 1
            }
        } else {
            if (popularityCount + actualEvent.influenceElectionB <= 100 || actualEvent.influenceElectionB < 0) && popularityCount + actualEvent.influenceElectionB >= 0 {
                popularityCount += actualEvent.influenceElectionB
            } else if actualEvent.influenceElectionB == 20 && popularityCount + 10 <= MAX_COUNT {
                popularityCount += 10
            } else if actualEvent.influenceElectionB == -20 && popularityCount - 10 >= 0 {
                popularityCount -= 10
            }
            if (religionCount + actualEvent.influenceReligionB <= MAX_COUNT || actualEvent.influenceReligionB < 0) && religionCount + actualEvent.influenceReligionB >= 0 {
                religionCount += actualEvent.influenceReligionB
            } else if actualEvent.influenceReligionB == 2 && religionCount + 1 <= MAX_COUNT {
                religionCount += 1
            } else if actualEvent.influenceReligionB == -2 && religionCount - 1 >= 0 {
                religionCount -= 1
            }
            if (populationCount + actualEvent.influencePopulationB <= MAX_COUNT || actualEvent.influencePopulationB < 0) && populationCount + actualEvent.influencePopulationB >= 0 {
                populationCount += actualEvent.influencePopulationB
            } else if actualEvent.influencePopulationB == 2 && populationCount + 1 <= MAX_COUNT {
                populationCount += 1
            } else if actualEvent.influencePopulationB == -2 && populationCount - 1 >= 0 {
                populationCount -= 1
            }
            if (armyCount + actualEvent.influenceArmyB <= MAX_COUNT || actualEvent.influenceArmyB < 0) && armyCount + actualEvent.influenceArmyB >= 0 {
                armyCount += actualEvent.influenceArmyB
            } else if actualEvent.influenceArmyB == 2 && armyCount + 1 <= MAX_COUNT {
                armyCount += 1
            } else if actualEvent.influenceArmyB == -2 && armyCount - 1 >= 0 {
                armyCount -= 1
            }
            if (wealthCount + actualEvent.influenceWealthB <= MAX_COUNT || actualEvent.influenceWealthB < 0) && wealthCount + actualEvent.influenceWealthB >= 0 {
                wealthCount += actualEvent.influenceWealthB
            } else if actualEvent.influenceWealthB == 2 && wealthCount + 1 <= MAX_COUNT {
                wealthCount += 1
            } else if actualEvent.influenceWealthB == -2 && wealthCount - 1 >= 0 {
                wealthCount -= 1
            }
        }
        
        // Gestion des événements particuliers, qui apparaissent selon certaines conditions
        if !load && indMageEvent < mageEvent.count {
            eventTmp = mageEvent[indMageEvent]
            indMageEvent += 1
            if indMageEvent >= mageEvent.count {
                indMageEvent = 0
                load = true
            }
        } else if condRevelation && eventRevelation {
            indRevelation += 1 + (answerA ? actualEvent.offsetA : actualEvent.offsetB)
            if indRevelation == 17 {
                successList["success1"] = true
            } else if indRevelation == 26 {
                successList["success3"] = true
            } else if indRevelation==30 {
                successList["success2"] = true
            }
            if indRevelation >= endGame.count {
                eventCredits = true
                eventRevelation = false
                indRevelation = 0
                changeEvent(true)
                return
            }
            eventTmp = endGame[indRevelation]
        } else if eventCredits {
            if indCredit >= credits.count {
                secondGame = true
                titleScreen(false)
                return
            }
            eventTmp = credits[indCredit]
            indCredit += 1
        } else if !firstLife && !secondLife {
            actualDay = 0
            eventTmp = gameOverFirst[indMortEvent]
            indMortEvent += 1
            if indMortEvent >= gameOverFirst.count {
                secondLife = true
                indMortEvent = 0
                saveGame()
            }
        } else if condRobin && !robinMeet {
            eventTmp = robinMeeting[indRobin]
            indRobin += 1
            if indRobin >= robinMeeting.count {
                changeDay()
                robinMeet = true
                event.append(contentsOf: robinEvent)
            }
        } else if robinDeathBool && eventRobinDeath {
            indRobin += 1 + (answerA ? actualEvent.offsetA : actualEvent.offsetB)
            eventTmp = robinDeath[indRobin]
            if indRobin >= 13 {
                personnage["mage"] = "Firo Prochainezo"
            }
            if indRobin >= robinDeath.count-1 {
                eventRobinDeath = false
                indRobin = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event{
                    if e.caracter != "robin" {
                        t.append(e)
                    }
                }
                event = t
            }
        } else if condTemplier && !templierMeet {
            eventTmp = templierMeeting[0]
            changeDay()
            templierMeet = true
            event.append(contentsOf: templierEvent)
        } else if condAssassin && !assassinMeet{
            eventTmp = assassinMeeting[0]
            changeDay()
            assassinMeet = true
            event.append(contentsOf: assassinEvent)
        } else if templierAssasinDeathBool && eventTemplierAssasinDeath {
            eventTmp = templierAssassinDeath[indEventTemplierAssassin]
            indEventTemplierAssassin += 1
            if indEventTemplierAssassin >= templierAssassinDeath.count {
                eventTemplierAssasinDeath = false
                indEventTemplierAssassin = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event{
                    if e.caracter != "templier" && e.caracter != "assassin"{
                        t.append(e)
                    }
                }
                event = t
            }
        } else if condNinja && !ninjaMeet {
            eventTmp = ninjaMeeting[0]
            changeDay()
            ninjaMeet = true
            event.append(contentsOf: ninjaEvent)
        } else if ninjaDeathBool && eventNinjaDeath {
            indEventNinja += 1 + (answerA ? actualEvent.offsetA : actualEvent.offsetB)
           
            if indEventNinja >= ninjaDeath.count-1 {
                eventNinjaDeath = false
                indEventNinja = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event {
                    if e.caracter != "ninja"{
                        t.append(e)
                    }
                }
                event = t
                changeEvent(true)
                return
            } else {
                eventTmp = ninjaDeath[indEventNinja]
            }
        } else if condCreuset && !creusetMeet {
            eventTmp = creusetMeeting[0]
            changeDay()
            creusetMeet = true
            event.append(contentsOf: creusetEvent)
        } else if creusetDeathBool && eventCreusetDeath {
            eventTmp = creusetDeath[indEventCreuset]
            indEventCreuset += 1
            if indEventCreuset >= creusetDeath.count {
                eventCreusetDeath = false
                indEventCreuset = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event {
                    if e.caracter != "chevalier_creuset" {
                        t.append(e)
                    }
                }
                event = t
            }
        } else if condMage1399 && eventMage1399 {
            eventTmp = mageEvent1399[indMageEvent]
            indMageEvent += 1
            if indMageEvent >= mageEvent1399.count {
                eventMage1399 = false
                indMageEvent = 0
                changeDay()
            }
        } else if condCultiste && !cultisteMeet {
            eventTmp = cultisteMeeting[indCultiste]
            indCultiste += 1
            if indCultiste >= cultisteMeeting.count {
                changeDay()
                cultisteMeet = true
                indCultiste = -1
                event.append(contentsOf: cultisteEvent)
            }
        } else if cultisteDeathBool && eventCultisteDeath {
            indCultiste += 1 + (answerA ? actualEvent.offsetA : actualEvent.offsetB)
            eventTmp = cultisteDeath[indCultiste]
            if indCultiste >= cultisteDeath.count-1 {
                eventCultisteDeath = false
                indCultiste = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event{
                    if e.caracter != "cultiste" {
                        t.append(e)
                    }
                }
                event = t
            }
        } else if religionCount == 0 {
            if indMortEvent >= gameOverReligion.count {
                titleScreen()
                return
            } else {
                eventTmp = gameOverReligion[indMortEvent]
                indMortEvent += 1
            }
        }else if populationCount == 0{
            if indMortEvent >= gameOverPopulation.count{
                titleScreen()
                return
            }else{
                eventTmp = gameOverPopulation[indMortEvent]
                indMortEvent += 1
            }
        }else if armyCount == 0{
            if indMortEvent >= gameOverArmy.count{
                titleScreen()
                return
            }else{
                eventTmp = gameOverArmy[indMortEvent]
                indMortEvent += 1
            }
        }else if wealthCount == 0{
            if indMortEvent >= gameOverWealth.count{
                titleScreen()
                return
            }else{
                eventTmp = gameOverWealth[indMortEvent]
                indMortEvent += 1
            }
        }else if timeCount == 0 && firstElection{
            eventTmp = firstElectionEvent[indElectionEvent]
            indElectionEvent += 1
            if indElectionEvent == firstElectionEvent.count{
                timeCount += 25
                firstElection = false
                indElectionEvent = 0
            }
        }else if timeCount == 0 && !resultatElection{
            eventTmp = electionEvent[0]
            resultatElection = true
            if popularityCount >= 50 {
                deathElection = false
            }else{
                deathElection = true
            }
        }else if timeCount == 0 && resultatElection && deathElection{
            if indMortEvent >= gameOverElection.count{
                titleScreen()
                return
            }else{
                eventTmp = gameOverElection[indMortEvent]
                indMortEvent += 1
            }
        }else if timeCount == 0 && resultatElection && !deathElection{
            eventTmp = victoryElectionEvent[0]
            timeCount += 25
            resultatElection = false
        }
        else{
            changeDay()
            saveGame()
            eventTmp = event[Int.random(in: 0..<event.count)]
        }
        actualEvent = eventTmp
        loadRequest(eventTmp)
        updateScreen()
    }
    
    // Méthode qui fait évoluer le temps au fil du jeu
    func changeDay(){
        timeCount -= 1
        actualDay += 60
        if actualDay >= 365 {
            actualYear += 1
            gameYear += 1
            actualDay -= 365
        }
    }
    
    // Méthode qui met à jour l'écran et tout les labels, images etc.
    func updateScreen(){
        if gameYear > 0 {
            timeLabel.text = "\(gameYear) an et \(actualDay) jours au pouvoir"
        } else {
            timeLabel.text = "\(actualDay) jours au pouvoir"
        }
        yearLabel.text = "\(actualYear)"
        popularityLabel.text = "\(popularityCount)%"
        religion.image = UIImage(named: "religion\(religionCount)")
        population.image = UIImage(named: "population\(populationCount)")
        army.image = UIImage(named: "army\(armyCount)")
        wealth.image = UIImage(named: "wealth\(wealthCount)")
    }
    
    // Méthode qui permet d echarger l'événement dans les labels et images de l'écran de jeu
    func loadRequest(_ event : GameEvent) {
        requestLabel.text = event.request
        answerA.text = event.answerA
        answerB.text = event.answerB
        if isCharacter(event.caracter) && event.caracter != "robin"{
            var name: String = event.caracter
            var perso : String = personnage[event.caracter]!
            if event.caracter == "mage" {
                if robinDeathBool || (eventRobinDeath && indRobin >= 13) {
                    name = "immortel"
                } else {
                    name = "mage?"
                }
            } else if event.caracter == "viking" {
                if (!requestLabel.text!.contains("Kerosen")) {
                    perso = "Floki"
                }
            } else if event.caracter == "chevalier_creuset" {
                name = "chevalier du Creuset"
            } else if event.caracter == "cultiste" {
                name = "adepte"
            }
            nameLabel.text = "\(name.capitalized) - \(perso)"
        } else if event.caracter == "robin" {
            nameLabel.text = "Robin des Bois"
        } else {
            nameLabel.text = ""
        }
        caracterImage.image = UIImage(named: event.caracter)
    }
    
    // Méthode qui permet de faire un retour à l'écrant titre
    func titleScreen(_ death : Bool = true){
        firstLife = false
        if death {
            resetGame()
        } else {
            resetAllGame()
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! ViewController
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = destinationViewController
            window.makeKeyAndVisible()
        }
    }
    
    // Méthode qui réinitialise partiellement le jeu, souvent en cas de mort du joueur
    func resetGame(){
        //Reinitialise les valeurs importantes apres la mort
        religionCount = 4
        populationCount = 4
        armyCount = 4
        wealthCount = 4
        popularityCount = 50
        timeCount = 25
        actualDay = -60
        saveGame()
    }
    
    // Méthode qui réinitialise complètement le jeu, ce sera pour une nouvelle partie
    func resetAllGame(){
        religionCount               = 4
        populationCount             = 4
        armyCount                   = 4
        wealthCount                 = 4
        popularityCount             = 50
        timeCount                   = 25
        actualYear                  = 1350
        firstElection               = true
        actualDay                   = 29
        resultatElection            = false
        deathElection               = false
        condRobin                   = false
        robinMeet                   = false
        robinDeathBool              = false
        eventRobinDeath             = false
        robinIsHere                 = false
        templierMeet                = false
        assassinMeet                = false
        templierAssasinDeathBool    = false
        condTemplier                = false
        condAssassin                = false
        eventTemplierAssasinDeath   = false
        condNinja                   = false
        ninjaMeet                   = false
        ninjaDeathBool              = false
        eventNinjaDeath             = false
        firstLife                   = true
        secondLife                  = false
        condCreuset                 = false
        creusetMeet                 = false
        creusetDeathBool            = false
        eventCreusetDeath           = false
        condMage1399                = false
        eventMage1399               = false
        condCultiste                = false
        cultisteMeet                = false
        cultisteDeathBool           = false
        eventCultisteDeath          = false
        saveGame()
    }
    
    // Méthode pour jouer la musique quand on arrive sur ce Controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        music!.play()
    }
    
    // Méthode qui met en pause la musique quand on quitte ce Controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        music!.pause()
    }
    
    @IBAction func clic(_ sender: Any) {
        performSegue(withIdentifier: "transition", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! PersonnageViewController
        dest.characters = characters
        dest.successList = successList
    }
    
}
