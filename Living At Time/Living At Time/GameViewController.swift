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
    
    var personnage : [Int : [String : String]] = [0:["mage" : "Firo"], 1:["paysan": "Goedfrey"], 2:["paysanne": "Helen"], 3:["marchand": "Otto Suwen"], 4:["reine": "Rose Oriana"], 5:["chevalier": "Rodrigo"], 6:["templier": "Hugues de Payns"], 7:["ninja": "Sakata Gintoki"], 8:["moine": "Frère Tuc"], 9:["courtisane": "Roxanne"], 10:["pape": "Benoit Ier"], 11:["cultiste": "Petelgeuse Romanee-conti"], 12:["princesse": "Lily Oriana"], 13:["seigneur": "Charles Arbor"], 14:["conseiller": "Alfred"], 15:["viking" : "Kerøsen"], 16:["chevalier_creuset" : "Ordovis"], 17:["robin":"Robin des bois"], 18:["assassin":"Silencieux"], 19:["archer":"Andrew Gilbert"], 20:["developpeur":"Guillaume le hardi"]]
    var load : Bool = false
    var projectPath : String = ""
    var dataPath : String = ""
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
    var firstElection : Bool = true
    var robinMeet : Bool = false
        
    
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
    
    var actualEvent : GameEvent = GameEvent(caracter: "", request: "", answerA: "", answerB: "")
    var event : [GameEvent] = []
    var mageEvent : [GameEvent] = []
    var indMageEvent : Int = 0
    var gameOverWealth : [GameEvent] = []
    var gameOverArmy : [GameEvent] = []
    var gameOverPopulation : [GameEvent] = []
    var gameOverReligion : [GameEvent] = []
    var gameOverElection : [GameEvent] = []
    var robinEvent : [GameEvent] = []
    var eventPostRobin : [GameEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        answerA.layer.opacity = 0
        answerB.layer.opacity = 0
        coordImage = caracterImage.center
        coordAnswerA = answerA.center
        coordAnswerB = answerB.center
        
        //Je recupere les differents emplacement de fichier qui me serons utiles
        var THIS_FILES_PATH_AS_ARRAY:[String] = #file.split(separator: "/").map({String($0)})
        THIS_FILES_PATH_AS_ARRAY.removeLast(3)
        projectPath = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        THIS_FILES_PATH_AS_ARRAY.append("data")
        dataPath = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        
        //Je recupere les données dans le fichier de sauvegarde de la derniere partie
        //Si il n'y a pas de derniere partie le fichier contient les données de base
        loadGame()
        
        mageEvent = lectureEvent(nomfichier: "mageEvent.txt", offset: false, condition: false, value: false)
        event = lectureEvent(nomfichier: "test.txt", offset: false, condition: false, value: true)
                
        if !load{
            // On joue en premier les evenements du mage
            loadRequest(mageEvent[indMageEvent])
            actualEvent = mageEvent[indMageEvent]
            indMageEvent += 1
        }else{
            //On joue un evenement aléatoires des autres personnages
            changeEvent(totalAlpha >= 0 ? true : false)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func saveGame(){
        let saveUrl : URL = URL(fileURLWithPath: "\(dataPath)/save.txt", isDirectory: false)
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
        strToSave.append(String(firstElection))
        do{
            try strToSave.write(to: saveUrl, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print(error)
        }
    }
    
    func loadGame(){
        let saveUrl : URL = URL(fileURLWithPath: "\(dataPath)/save.txt", isDirectory: false)
        
        do{
            var strSave = try String(contentsOf: saveUrl)
            var strSaveLine = strSave.components(separatedBy: .newlines)
            if strSaveLine.count < 3{
                saveGame()
            }
            strSave = try String(contentsOf: saveUrl)
            strSaveLine = strSave.components(separatedBy: .newlines)
            if Int(strSaveLine[0])! != religionCount || Int(strSaveLine[1])! != populationCount || Int(strSaveLine[2])! != armyCount || wealthCount != Int(strSaveLine[3])! || popularityCount != Int(strSaveLine[4])! || timeCount != Int(strSaveLine[5])! || actualYear != Int(strSaveLine[6])! || firstElection != Bool(strSaveLine[7])!{
                load = true
            }
            if load{
                religionCount = Int(strSaveLine[0])!
                populationCount = Int(strSaveLine[1])!
                armyCount = Int(strSaveLine[2])!
                wealthCount = Int(strSaveLine[3])!
                popularityCount = Int(strSaveLine[4])!
                timeCount = Int(strSaveLine[5])!
                actualYear = Int(strSaveLine[6])!
                firstElection = Bool(strSaveLine[7])!
                updateScreen()
            }
            
        }catch{
            print(error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
        if caracterImage.frame.contains(p){
            lastLocation = p
            pointInit = p
            imageTouch = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        
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
        answerA.layer.opacity = 0
        answerB.layer.opacity = 0
        answerA.center = coordAnswerA
        answerB.center = coordAnswerB
        caracterImage.center = coordImage
        caracterImage.transform = caracterImage.transform.rotated(by: -totalAlpha)
        answerA.transform = answerA.transform.rotated(by: -totalAlpha)
        answerB.transform = answerB.transform.rotated(by: -totalAlpha)
        if abs(totalAlpha) >= 0.25{
            print("Changement")
            changeEvent(totalAlpha >= 0 ? true : false)
        }
        
        totalAlpha = 0
        imageTouch = false
    }
    
    func lectureEvent(nomfichier nom: String, offset o : Bool, condition cond : Bool, value v : Bool) -> [GameEvent]{
        var t : [GameEvent] = []
        let eventUrl : URL = URL(fileURLWithPath: "\(dataPath)/\(nom)", isDirectory: false)
        do{
            let strEvent = try String(contentsOf: eventUrl)
            var strEventLine = strEvent.components(separatedBy: .newlines)
            var i = 0
            var nbEvent = 0
            let max = Int(strEventLine.removeFirst())!
            for j in 0..<max{
                nbEvent += Int(strEventLine[(3*i)+j].split(separator: ";")[0])!
                let car = String(strEventLine[(3*i)+j].split(separator: ";")[1])
                while i < nbEvent {
                    var tmpEvent : GameEvent
                    if v{
                        let strAnswerA = strEventLine[(3*i)+2+j].split(separator: ";")
                        let strAnswerB = strEventLine[(3*i)+3+j].split(separator: ";")
                        tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i)+1+j], answerA: String(strAnswerA[0]), influenceReligionA: Int(strAnswerA[1])!, influencePopulationA: Int(strAnswerA[2])!, influenceArmyA:Int(strAnswerA[3])!, influenceWealthA: Int(strAnswerA[4])!, influenceElectionA: Int(strAnswerA[5])!, answerB: String(strAnswerB[0]), influenceReligionB: Int(strAnswerB[1])!, influencePopulationB: Int(strAnswerB[2])!, influenceArmyB: Int(strAnswerB[3])!, influenceWealthB: Int(strAnswerB[4])!, influenceElectionB: Int(strAnswerB[5])!)
                    }else{
                        tmpEvent = GameEvent(caracter: car, request: strEventLine[(3*i+1+j)], answerA: strEventLine[(3*i)+2+j], answerB: strEventLine[(3*i)+3+j])
                    }
                    if cond{
                        tmpEvent.addCondition(Int(strEventLine[i].split(separator: ";")[2])!)
                    }
                    if o{
                        let strAnswerA = strEventLine[(3*i)+1].split(separator: ";")
                        let strAnswerB = strEventLine[(3*i)+2].split(separator: ";")
                        tmpEvent.addOffsetA(Int(strAnswerA.last!)!)
                        tmpEvent.addOffsetB(Int(strAnswerB.last!)!)
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
    
    func changeEvent(_ answerA : Bool){
        if answerA{
            popularityCount += actualEvent.influencePopulationA
            religionCount += actualEvent.influenceReligionA
            populationCount += actualEvent.influencePopulationA
            armyCount += actualEvent.influenceArmyA
            wealthCount += actualEvent.influenceWealthA
        }else{
            popularityCount += actualEvent.influencePopulationB
            religionCount += actualEvent.influenceReligionB
            populationCount += actualEvent.influencePopulationB
            armyCount += actualEvent.influenceArmyB
            wealthCount += actualEvent.influenceWealthB
        }
        updateScreen()
        var eventTmp : GameEvent
        if !load && indMageEvent < mageEvent.count{
            eventTmp = mageEvent[indMageEvent]
            indMageEvent += 1
        }else{
            actualDay += 60
            if actualDay >= 365 {
                actualYear += 1
                gameYear += 1
                actualDay -= 365
            }
            saveGame()
            eventTmp = event[Int.random(in: 0..<event.count)]
        }
        actualEvent = eventTmp
        loadRequest(eventTmp)
        
    }
    
    func updateScreen(){
        print(gameYear)
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
        requestLabel.text = event.request
        answerA.text = event.answerA
        answerB.text = event.answerB
        if event.caracter != "inconnu"{
            nameLabel.text = event.caracter.capitalized
        }else{
            nameLabel.text = ""
        }
        caracterImage.image = UIImage(named: event.caracter)
    }
    
    func finDePartie(){
        
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
