//
//  GameViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 02/04/2024.
//

import UIKit

class GameEvent{
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
    
    func addCondition(_ cond : Int){
        self.condition  = cond
    }
    
    func addOffsetA(_ offset : Int){
        self.offsetA = offset
    }
    
    func addOffsetB(_ offset : Int){
        self.offsetB = offset
    }
    
    var description : String{
        return "Caracter: \(caracter), Request: \(request), AnswerA: \(answerA), influenceReligionA: \(influenceReligionA), influencePopulationA: \(influencePopulationA), influenceArmyA: \(influenceArmyA), influenceWealthA: \(influenceWealthA), influenceElectionA: \(influenceElectionA), answerB: \(answerB), influenceReligionB: \(influenceReligionB), influencePopulationB: \(influencePopulationB), influenceArmyB: \(influenceArmyB), influenceWealthB: \(influenceWealthB), influenceElectionB: \(influenceElectionB)"
    }
}

let MAX_COUNT : Int = 8

class GameViewController: UIViewController {
    
    var characters: [String:Bool] = ["mage":false, "paysan":false, "paysanne":false, "marchand":false, "reine":false, "chevalier":false, "templier":false, "ninja":false, "moine":false, "courtisane":false, "pape":false, "cultiste":false, "princesse":false, "seigneur":false, "conseiller":false, "viking":false, "chevalier_creuset":false, "robin":false, "assassin":false, "archer":false, "developpeur":false]
    
    //Variables de gestion du jeu
    var personnage : [String : String] = ["mage" : "Firo", "paysan": "Goedfrey", "paysanne": "Helen", "marchand": "Otto Suwen", "reine": "Rose Oriana", "chevalier": "Rodrigo", "templier": "Hugues de Payns", "ninja": "Sakata Gintoki", "moine": "Frère Tuc", "courtisane": "Roxanne", "pape": "Benoit Ier", "cultiste": "Petelgeuse Romanee-conti", "princesse": "Lily Oriana", "seigneur": "Charles Arbor", "conseiller": "Alfred", "viking" : "Kerøsen", "chevalier_creuset" : "Ordovis", "robin":"Robin des bois", "assassin":"Silencieux", "archer":"Andrew Gilbert", "developpeur":"Guillaume le hardi"]
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
        
    //Variables des objets de la vue
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
    
    //Variables liees aux evenements ou a leur gestion
    var actualEvent : GameEvent = GameEvent(caracter: "", request: "", answerA: "", answerB: "")
    var event : [GameEvent] = []
    var mageEvent : [GameEvent] = []
    
    var gameOverWealth : [GameEvent] = []
    var gameOverArmy : [GameEvent] = []
    var gameOverPopulation : [GameEvent] = []
    var gameOverReligion : [GameEvent] = []
    var gameOverElection : [GameEvent] = []
    
    var electionEvent : [GameEvent] = []
    var firstElectionEvent : [GameEvent] = []
    var victoryElectionEvent : [GameEvent] = []
    
    var robinEvent : [GameEvent] = []
    var robinMeeting : [GameEvent] = []
    var robinDeath : [GameEvent] = []
    var gameEventRobin : [GameEvent] = []
    
    var indMortEvent : Int = 0
    var indElectionEvent : Int = 0
    var indMageEvent : Int = 0
    var indRobin : Int = 0
    
    var firstElection : Bool = true
    var resultatElection : Bool = false
    var deathElection : Bool = false
    var condRobin : Bool = false
    var robinMeet : Bool = false
    var robinDeathBool : Bool = false
    var eventRobinDeath : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //sauvegarde des coordonnées et desaffichage des reponses
        answerA.layer.opacity = 0
        answerB.layer.opacity = 0
        coordImage = caracterImage.center
        coordAnswerA = answerA.center
        coordAnswerB = answerB.center
        
        
        //Je recupere les données dans le fichier de sauvegarde de la derniere partie
        //Si il n'y a pas de derniere partie le fichier contient les données de base
        loadGame()
        updateScreen()
        
        //lecture des evenements de jeu
        mageEvent = lectureEvent(nomfichier: "mageEvent", offset: false, value: false)
        event = lectureEvent(nomfichier: "GameEvent", offset: false, value: true)
        gameOverArmy = lectureEvent(nomfichier: "GameOverMillitaire", offset: false, value: false)
        gameOverWealth = lectureEvent(nomfichier: "GameOverWealth", offset: false, value: false)
        gameOverElection = lectureEvent(nomfichier: "GameOverElection", offset: false, value: false)
        gameOverPopulation = lectureEvent(nomfichier: "GameOverPopulation", offset: false, value: false)
        gameOverReligion = lectureEvent(nomfichier: "GameOverReligion", offset: false, value: false)
        electionEvent = lectureEvent(nomfichier: "electionEvent", offset: false, value: false)
        firstElectionEvent = lectureEvent(nomfichier: "firstElectionEvent", offset: false, value: false)
        victoryElectionEvent = lectureEvent(nomfichier: "victoryElectionEvent", offset: false, value: false)
        
        //lecture des evenements liées a robin des bois
        robinMeeting = lectureEvent(nomfichier: "RobinMeeting", offset: false, value: false)
        robinEvent = lectureEvent(nomfichier: "RobinEvent", offset: false, value: true)
        gameEventRobin = lectureEvent(nomfichier: "GameEventRobin", offset: false, value: true)
        robinDeath = lectureEvent(nomfichier: "RobinDeath", offset: true, value: false)
        
        if robinMeet {
            event.append(contentsOf: gameEventRobin)
            if !robinDeathBool{
                event.append(contentsOf: robinEvent)
            }
        }
        
        if !load{
            // On joue en premier les evenements du mage
            loadRequest(mageEvent[indMageEvent])
            actualEvent = mageEvent[indMageEvent]
            indMageEvent += 1
        }else{
            //On joue un evenement aléatoires des autres personnages
            changeEvent(totalAlpha >= 0 ? true : false)
        }
    }
    
    func saveGame(){
        //Sauvegarde des différentes informations utiles au bon fonctionnement du jeu
        let saveUrl : URL = Bundle.main.url(forResource: "save", withExtension: "txt")!
        var strToSave : String = ""
        strToSave.append(String(religionCount))
        strToSave.append("\n")
        strToSave.append(String(populationCount))
        strToSave.append("\n")
        strToSave.append(String(armyCount))
        strToSave.append("\n")
        strToSave.append(String(wealthCount))
        strToSave.append("\n")
        strToSave.append(String(popularityCount))
        strToSave.append("\n")
        strToSave.append(String(timeCount))
        strToSave.append("\n")
        strToSave.append(String(actualYear))
        strToSave.append("\n")
        strToSave.append(String(actualDay))
        strToSave.append("\n")
        strToSave.append(String(firstElection))
        strToSave.append("\n")
        strToSave.append(String(resultatElection))
        strToSave.append("\n")
        strToSave.append(String(deathElection))
        strToSave.append("\n")
        strToSave.append(String(condRobin))
        strToSave.append("\n")
        strToSave.append(String(robinMeet))
        strToSave.append("\n")
        strToSave.append(String(robinDeathBool))
        strToSave.append("\n")
        strToSave.append(String(eventRobinDeath))
        //print(strToSave)
        for (car, see) in characters{
            strToSave.append("\n")
            strToSave.append("\(car);\(see)")
        }
        do{
            try strToSave.write(to: saveUrl, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print(error)
        }
    }
    
    func loadGame(){
        //lecture du fichier de sauvegarde afin de recuperer la partie
        
        let saveUrl : URL = Bundle.main.url(forResource: "save", withExtension: "txt")!
        
        do{
            var strSave = try String(contentsOf: saveUrl)
            var strSaveLine = strSave.components(separatedBy: .newlines)
            if strSaveLine.count < 3{
                actualDay = 29
                actualYear = 1360
                saveGame()
                strSave = try String(contentsOf: saveUrl)
                strSaveLine = strSave.components(separatedBy: .newlines)
            }
            if  religionCount       != Int(strSaveLine[0])!     ||
                populationCount     != Int(strSaveLine[1])!     ||
                armyCount           != Int(strSaveLine[2])!     ||
                wealthCount         != Int(strSaveLine[3])!     ||
                popularityCount     != Int(strSaveLine[4])!     ||
                timeCount           != Int(strSaveLine[5])!     ||
                actualYear          != Int(strSaveLine[6])!     ||
                firstElection       != Bool(strSaveLine[8])!    ||
                actualDay           != Int(strSaveLine[7])!     ||
                resultatElection    != Bool(strSaveLine[9])!    ||
                deathElection       != Bool(strSaveLine[10])!   ||
                condRobin           != Bool(strSaveLine[11])!   ||
                robinMeet           != Bool(strSaveLine[12])!   ||
                robinDeathBool      != Bool(strSaveLine[13])!   ||
                eventRobinDeath     != Bool(strSaveLine[14])!   {
                load = true
            }
            if load{
                religionCount       = Int(strSaveLine[0])!
                populationCount     = Int(strSaveLine[1])!
                armyCount           = Int(strSaveLine[2])!
                wealthCount         = Int(strSaveLine[3])!
                popularityCount     = Int(strSaveLine[4])!
                timeCount           = Int(strSaveLine[5])!
                actualYear          = Int(strSaveLine[6])!
                actualDay           = Int(strSaveLine[7])!
                firstElection       = Bool(strSaveLine[8])!
                resultatElection    = Bool(strSaveLine[9])!
                deathElection       = Bool(strSaveLine[10])!
                condRobin           = Bool(strSaveLine[11])!
                robinMeet           = Bool(strSaveLine[12])!
                robinDeathBool      = Bool(strSaveLine[13])!
                eventRobinDeath     = Bool(strSaveLine[14])!
                for i in 0..<characters.count{
                    let car = String(strSaveLine[15+i].split(separator: ";")[0])
                    let see = Bool(String(strSaveLine[15+i].split(separator: ";")[1]))
                    characters[car] = see
                }
                updateScreen()
            }
            
        }catch{
            print(error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
        //Si l'image est touché on sauvegarde la position actuelle comme etant
        //la derniere position touché et on change la valeur de imagTouch a true
        if caracterImage.frame.contains(p){
            lastLocation = p
            pointInit = p
            imageTouch = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
        //Si l'image est touché on va alors deplacer l'image et afficher les reponses
        //en fonction de la situation
        if imageTouch{
            lastTotalAlpha = totalAlpha
            let bottomYImage = coordImage.y + (caracterImage.image?.size.height)!
            
            //Le but est de representer virtuellement un triangle rectangle afin de pouvoir calculer l'angle qu'il faudra appliquer a mon image lors d'un mouvement.
            
            
            //Je fais different calcul afin de pouvoir recuperer l'anglee de rotation entre deux droites imaginaires
            // la premiere est la droite entre la derniere position de clic de formule x = lastLocation.x sur laquelle il y a les points A et B
            // la deuxieme est la droite entre la derniere position de clic et la nouvelle position de formule y = lastLocation.y sur laquelle il y a les points B et C
            let pointA = CGPoint(x: lastLocation.x, y: bottomYImage)
            let pointB = CGPoint(x: lastLocation.x, y: p.y)
            let pointC = p
            
            //Je calcule la distance entre les points B et C
            var distBC = pow((pointB.x - pointC.x), 2) + pow((pointB.y - pointC.y),2)
            distBC = sqrt(distBC)
            
            //Je calcule la distance entre les points A et C
            var distAC = pow((pointC.x - pointA.x), 2) + pow((pointC.y - pointA.y), 2)
            distAC = sqrt(distAC)
            
            //Je calcul l'angle entre les droites citer plus haut
            var alpha = asin(distBC / distAC)
            
            if p.x < lastLocation.x{
                alpha = -alpha
            }
            totalAlpha += alpha
            
            //Je regarde l'angle total depuis le debut des mouvements et selon lui,
            //je change l'opacité des reponses (je sais pas si cela marche bien
            //d'augmenter l'opacité mais le principe est de n'afficher qu'une
            //réponse à la fois)
            if totalAlpha < 0{
                answerA.layer.opacity = 0
                if totalAlpha < lastTotalAlpha && answerB.layer.opacity < 100{
                    answerB.layer.opacity += 4
                }else {
                    answerB.layer.opacity -= 4
                }
            }else{
                answerB.layer.opacity = 0
                if totalAlpha > lastTotalAlpha && answerA.layer.opacity < 100{
                    answerA.layer.opacity += 4
                }else {
                    answerA.layer.opacity -= 4
                }
            }
            
            //Je calcule le deplacement en X et en Y
            let distX = lastLocation.x - p.x
            let distY = lastLocation.y - p.y
            
            //J'applique les transformations nescessaire a mes differents objets
            caracterImage.center.x -= distX
            caracterImage.center.y -= distY
            answerA.center.x -= distX
            answerA.center.y -= distY
            answerB.center.x -= distX
            answerB.center.y -= distY
            caracterImage.transform = caracterImage.transform.rotated(by: alpha)
            answerA.transform = answerA.transform.rotated(by: alpha)
            answerB.transform = answerB.transform.rotated(by: alpha)
            lastLocation = p //J'actualise la derniere position du clic
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Si l'image etait touché alorss je reinitialise toutes les valeurs qui
        //ont pu changer
        if imageTouch{
            answerA.layer.opacity = 0
            answerB.layer.opacity = 0
            answerA.center = coordAnswerA
            answerB.center = coordAnswerB
            caracterImage.center = coordImage
            caracterImage.transform = caracterImage.transform.rotated(by: -totalAlpha)
            answerA.transform = answerA.transform.rotated(by: -totalAlpha)
            answerB.transform = answerB.transform.rotated(by: -totalAlpha)
            if abs(totalAlpha) >= 0.25{
                //Je fais le changement d'evenement afin d'afficher le suivant
                //Je regarde aussi si l'angle est positif ou non afin de savoir
                //quelle information je dois appliquer aux valeurs
                changeEvent(totalAlpha >= 0 ? true : false)
            }
            totalAlpha = 0
            imageTouch = false
        }
    }
    
    func lectureEvent(nomfichier nom: String, extension e: String = "txt", offset o : Bool, value v : Bool) -> [GameEvent]{
        //J'initialise un tableau dans lequel j'ajouterai tous les evenements du
        //fichier de nom 'nom' je prend aussi en parametres d'autres informations
        //qui permettrons a mon programme de savoir comment est structure mon
        //fichier à lire
        var t : [GameEvent] = []
        //Je recupere l'url fichier
        let eventUrl : URL = Bundle.main.url(forResource: nom, withExtension: e)!
        do{
            //Je recupere le texte contenu dans le fichier et le separe a chaque
            //fin de ligne
            let strEvent = try String(contentsOf: eventUrl)
            var strEventLine = strEvent.components(separatedBy: .newlines)
            var i = 0
            var nbEvent = 0
            //A chaque debut de fichier on a une indication sur le nombre de personnage
            let max = Int(strEventLine.removeFirst())!
            for j in 0..<max{
                //Pour chaque personnage on a son nombre d'event et son nom
                nbEvent += Int(strEventLine[(3*i)+j].split(separator: ";")[0])!
                let car = String(strEventLine[(3*i)+j].split(separator: ";")[1])
                while i < nbEvent {
                    var tmpEvent : GameEvent
                    if v{
                        let strAnswerA = strEventLine[(3*i)+2+j].split(separator: ";")
                        let strAnswerB = strEventLine[(3*i)+3+j].split(separator: ";")
                        tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i)+1+j], answerA: String(strAnswerA[0]), influenceReligionA: Int(strAnswerA[1])!, influencePopulationA: Int(strAnswerA[2])!, influenceArmyA:Int(strAnswerA[3])!, influenceWealthA: Int(strAnswerA[4])!, influenceElectionA: Int(strAnswerA[5])!, answerB: String(strAnswerB[0]), influenceReligionB: Int(strAnswerB[1])!, influencePopulationB: Int(strAnswerB[2])!, influenceArmyB: Int(strAnswerB[3])!, influenceWealthB: Int(strAnswerB[4])!, influenceElectionB: Int(strAnswerB[5])!)
                    }else{
                        if o{
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
        }catch{
            print(error)
        }
        
        return t
    }
    
    func isCharacter(_ car : String) -> Bool{
        return car != "inconnu" && car != "mort" && car != ""
    }
    
    func changeEvent(_ answerA : Bool){
        //Permet le changement d'evenement en appliquant d'abord les valeurs
        //de l'event actuel puis en choisis un autre en fonction de la
        //situation dans le jeu
        if isCharacter(actualEvent.caracter){
            characters[actualEvent.caracter] = true
        }
        
        if actualYear == 1362{
            condRobin = true
        }else if actualYear == 1369 && !robinDeathBool{
            robinDeathBool = true
            eventRobinDeath = true
            indRobin = -1
        }
        
        if answerA{
            if (popularityCount + actualEvent.influenceElectionA <= 100 || actualEvent.influenceElectionA < 0) && popularityCount + actualEvent.influenceElectionA >= 0{
                popularityCount += actualEvent.influenceElectionA
            }else if actualEvent.influenceElectionA == 20 && popularityCount + 10 <= MAX_COUNT{
                popularityCount += 10
            }else if actualEvent.influenceElectionA == -20 && popularityCount - 10 >= 0{
                popularityCount -= 10
            }
            if (religionCount + actualEvent.influenceReligionA <= MAX_COUNT || actualEvent.influenceReligionA < 0) && religionCount + actualEvent.influenceReligionA >= 0{
                religionCount += actualEvent.influenceReligionA
            }else if actualEvent.influenceReligionA == 2 && religionCount + 1 <= MAX_COUNT{
                religionCount += 1
            }else if actualEvent.influenceReligionA == -2 && religionCount - 1 >= 0{
                religionCount -= 1
            }
            if (populationCount + actualEvent.influencePopulationA <= MAX_COUNT || actualEvent.influencePopulationA < 0) && populationCount + actualEvent.influencePopulationA >= 0{
                populationCount += actualEvent.influencePopulationA
            }else if actualEvent.influencePopulationA == 2 && populationCount + 1 <= MAX_COUNT{
                populationCount += 1
            }else if actualEvent.influencePopulationA == -2 && populationCount - 1 >= 0{
                populationCount -= 1
            }
            if (armyCount + actualEvent.influenceArmyA <= MAX_COUNT || actualEvent.influenceArmyA < 0) && armyCount + actualEvent.influenceArmyA >= 0{
                armyCount += actualEvent.influenceArmyA
            }else if actualEvent.influenceArmyA == 2 && armyCount + 1 <= MAX_COUNT{
                armyCount += 1
            }else if actualEvent.influenceArmyA == -2 && armyCount - 1 >= 0{
                armyCount -= 1
            }
            if (wealthCount + actualEvent.influenceWealthA <= MAX_COUNT || actualEvent.influenceWealthA < 0) && wealthCount + actualEvent.influenceWealthA >= 0 {
                wealthCount += actualEvent.influenceWealthA
            }else if actualEvent.influenceWealthA == 2 && wealthCount + 1 <= MAX_COUNT{
                wealthCount += 1
            }else if actualEvent.influenceWealthA == -2 && wealthCount - 1 >= 0{
                wealthCount -= 1
            }
        }else{
            if (popularityCount + actualEvent.influenceElectionB <= 100 || actualEvent.influenceElectionB < 0) && popularityCount + actualEvent.influenceElectionB >= 0{
                popularityCount += actualEvent.influenceElectionB
            }else if actualEvent.influenceElectionB == 20 && popularityCount + 10 <= MAX_COUNT{
                popularityCount += 10
            }else if actualEvent.influenceElectionB == -20 && popularityCount - 10 >= 0{
                popularityCount -= 10
            }
            if (religionCount + actualEvent.influenceReligionB <= MAX_COUNT || actualEvent.influenceReligionB < 0) && religionCount + actualEvent.influenceReligionB >= 0{
                religionCount += actualEvent.influenceReligionB
            }else if actualEvent.influenceReligionB == 2 && religionCount + 1 <= MAX_COUNT{
                religionCount += 1
            }else if actualEvent.influenceReligionB == -2 && religionCount - 1 >= 0{
                religionCount -= 1
            }
            if (populationCount + actualEvent.influencePopulationB <= MAX_COUNT || actualEvent.influencePopulationB < 0) && populationCount + actualEvent.influencePopulationB >= 0{
                populationCount += actualEvent.influencePopulationB
            }else if actualEvent.influencePopulationB == 2 && populationCount + 1 <= MAX_COUNT{
                populationCount += 1
            }else if actualEvent.influencePopulationB == -2 && populationCount - 1 >= 0{
                populationCount -= 1
            }
            if (armyCount + actualEvent.influenceArmyB <= MAX_COUNT || actualEvent.influenceArmyB < 0) && armyCount + actualEvent.influenceArmyB >= 0{
                armyCount += actualEvent.influenceArmyB
            }else if actualEvent.influenceArmyB == 2 && armyCount + 1 <= MAX_COUNT{
                armyCount += 1
            }else if actualEvent.influenceArmyB == -2 && armyCount - 1 >= 0{
                armyCount -= 1
            }
            if (wealthCount + actualEvent.influenceWealthB <= MAX_COUNT || actualEvent.influenceWealthB < 0) && wealthCount + actualEvent.influenceWealthB >= 0{
                wealthCount += actualEvent.influenceWealthB
            }else if actualEvent.influenceWealthB == 2 && wealthCount + 1 <= MAX_COUNT{
                wealthCount += 1
            }else if actualEvent.influenceWealthB == -2 && wealthCount - 1 >= 0{
                wealthCount -= 1
            }
        }
        var eventTmp : GameEvent
        if !load && indMageEvent < mageEvent.count{
            eventTmp = mageEvent[indMageEvent]
            indMageEvent += 1
        }else if condRobin && !robinMeet{
            eventTmp = robinMeeting[indRobin]
            indRobin += 1
            if indRobin >= robinMeeting.count{
                changeDay()
                robinMeet = true
                event.append(contentsOf: gameEventRobin)
                event.append(contentsOf: robinEvent)
            }
        }else if robinDeathBool && eventRobinDeath{
            print(indRobin)
            print(robinDeathBool)
            print(eventRobinDeath)
            indRobin += 1 + (answerA ? actualEvent.offsetA : actualEvent.offsetB)
            eventTmp = robinDeath[indRobin]
            if indRobin >= robinDeath.count-1{
                eventRobinDeath = false
                indRobin = 0
                changeDay()
                var t : [GameEvent] = []
                for e in event{
                    if e.caracter != "robin"{
                        t.append(e)
                    }
                }
                event = t
                for e in event{
                    if e.caracter == "robin"{
                        print(e.description)
                    }
                }
            }
        }else if religionCount == 0{
            if indMortEvent >= gameOverReligion.count{
                titleScreen()
                return
            }else{
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
            if indElectionEvent > gameOverElection.count{
                titleScreen()
            }
            eventTmp = gameOverElection[indElectionEvent]
            indElectionEvent += 1
            resultatElection = false
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
    
    func changeDay(){
        timeCount -= 1
        actualDay += 60
        if actualDay >= 365 {
            actualYear += 1
            gameYear += 1
            actualDay -= 365
        }
    }
    
    func updateScreen(){
        //Permet d'actualiser tous les labels et images de l'ecran de jeu
        if gameYear > 0{
            timeLabel.text = "\(gameYear) an et \(actualDay) jours au pouvoir"
        }else {
            timeLabel.text = "\(actualDay) jours au pouvoir"
        }
        yearLabel.text = "\(actualYear)"
        popularityLabel.text = "\(popularityCount)%"
        religion.image = UIImage(named: "religion\(religionCount)")
        population.image = UIImage(named: "population\(populationCount)")
        army.image = UIImage(named: "army\(armyCount)")
        wealth.image = UIImage(named: "wealth\(wealthCount)")
    }
    
    func loadRequest(_ event : GameEvent){
        //Permet de charger l'evenemment dans les labels et images de l'ecran de jeu
        requestLabel.text = event.request
        answerA.text = event.answerA
        answerB.text = event.answerB
        if isCharacter(event.caracter){
            print(event.caracter)
            nameLabel.text = "\(event.caracter.capitalized) - \(personnage[event.caracter]!)"
        }else{
            nameLabel.text = ""
        }
        caracterImage.image = UIImage(named: event.caracter)
    }
    
    func titleScreen(){
        //Permet de retourner a l'ecran titre en remplacant la fenetre actuel
        //par la fenetre d'acceuil d'identifiant 'Home' dans le storyboard
        resetGame()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! ViewController
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = destinationViewController
            window.makeKeyAndVisible()
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let dest = segue.destination as! PersonnageViewController
        dest.characters = characters
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
