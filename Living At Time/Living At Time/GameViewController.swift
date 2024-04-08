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
    
    init(caracter: String, request: String, answerA: String,  influenceReligionA: Int = 0, influencePopulationA: Int = 0, influenceArmyA: Int = 0, influenceWealthA: Int = 0, influenceElectionA: Int = 0, answerB: String, influenceReligionB: Int = 0, influencePopulationB: Int = 0, influenceArmyB: Int = 0, influenceWealthB: Int = 0, influenceElectionB: Int = 0, condition: Int = 0) {
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
    }
    
    var description : String{
        return "Caracter: \(caracter), Request: \(request), AnswerA: \(answerA), influenceReligionA: \(influenceReligionA), influencePopulationA: \(influencePopulationA), influenceArmyA: \(influenceArmyA), influenceWealthA: \(influenceWealthA), influenceElectionA: \(influenceElectionA), answerB: \(answerB), influenceReligionB: \(influenceReligionB), influencePopulationB: \(influencePopulationB), influenceArmyB: \(influenceArmyB), influenceWealthB: \(influenceWealthB), influenceElectionB: \(influenceElectionB)"
    }
}

let MAX_COUNT : Int = 8

class GameViewController: UIViewController {
    
    var personnage : [Int : [String : String]] = [0:["mage" : "Firo"], 1:["paysan": "NOM"], 2:["paysane": "NOM"], 3:["marchand": "Otto Suwen"], 4:["reine": "NOM"], 5:["chevalier": "Rodrigo"], 6:["templier": "NOM"], 7:["ninja": "Sakata Gintoki"], 8:["moine": "NOM"], 9:["courtisane": "NOM"], 10:["pape": "NOM"], 11:["cultiste": "Petelgeuse romanee-conti"], 12:["princesse": "Lily"], 13:["seigneur": "NOM"], 14:["conseiller": "Alfred"]]
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
    
    var event : [GameEvent] = []
    var mageEvent : [GameEvent] = []
    var indMageEvent : Int = 0
    var robinEvent : [GameEvent] = []
    
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
        
        //On recupere l'url du fichier contenant les evenements du jeu
        let gameEventUrl : URL = URL(fileURLWithPath: "\(dataPath)/GameEvent.txt", isDirectory: false)
        let mageEventUrl : URL = URL(fileURLWithPath: "\(dataPath)/mageEvent.txt", isDirectory: false)
        do{
            let strEvent = try String(contentsOf: mageEventUrl)
            let strEventLine = strEvent.components(separatedBy: .newlines)
            for i in 0...7{
                let tmpEvent = GameEvent(caracter: (personnage[0]?.first?.key)!, request: strEventLine[(3 * i)], answerA: strEventLine[(3 * i) + 1], answerB: strEventLine[(3 * i) + 2])
                mageEvent.append(tmpEvent)
            }
        }catch{
            print(error)
        }
        
        /*
        do{
            let strEvent = try String(contentsOf: gameEventUrl)
            let strEventLine = strEvent.components(separatedBy: .newlines)
            
            //On recuere les informations du fichiers texte puis on les ajoutes aux tableaux d'evenement
            var persoAct = load ? 1 : 0
            var nbPerso : Int = Int(strEventLine[0])!
            var i = 1
            while persoAct < 1{ // a changer quand l'ecriture des event sera fini
                let nbEventPersoI : Int = Int(strEventLine[i])!
                i += 1
                let initialI = i
                while i < (initialI + (nbEventPersoI * 13)){
                    let tmpEvent : GameEvent = GameEvent(caracter: personnage[persoAct], request: strEventLine[i], answerA: strEventLine[i+1], influenceReligionA: Int(strEventLine[i+2])!, influencePopulationA: Int(strEventLine[i+3])!, influenceArmyA: Int(strEventLine[i+4])!, influenceWealthA: Int(strEventLine[i+5])!, influenceElectionA: Int(strEventLine[i+6])!, answerB: strEventLine[i+7], influenceReligionB: Int(strEventLine[i+8])!, influencePopulationB: Int(strEventLine[i+9])!, influenceArmyB: Int(strEventLine[i+10])!, influenceWealthB: Int(strEventLine[i+11])!, influenceElectionB: Int(strEventLine[i+12])!)
                    i += 13
                    if persoAct == 0{
                        mageEvent.append(tmpEvent)
                    }else{
                        event.append(tmpEvent)
                    }
                }
                persoAct += 1
            }
            //lecture event conditionnel
        }catch{
            print(error)
        }*/
        
        if !load{
            // On joue en premier les evenements du mage
            loadRequest(mageEvent[indMageEvent])
            indMageEvent += 1
        }else{
            //On joue un evenement aléatoires des autres personnages
            changeEvent()
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
        print(strToSave)
        do{
            try strToSave.write(to: saveUrl, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            print(error)
        }
    }
    
    func loadGame(){
        let saveUrl : URL = URL(fileURLWithPath: "\(dataPath)/save.txt", isDirectory: false)
        
        do{
            let strSave = try String(contentsOf: saveUrl)
            let strSaveLine = strSave.components(separatedBy: .newlines)
            
            if Int(strSaveLine[0])! != religionCount || Int(strSaveLine[1])! != populationCount || Int(strSaveLine[2])! != armyCount || wealthCount != Int(strSaveLine[3])! || popularityCount != Int(strSaveLine[4])! || timeCount != Int(strSaveLine[5])! || actualYear != Int(strSaveLine[6])!{
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
                updateScreen()
            }
            
        }catch{
            print(error)
        }
    }
    
    func updateScreen(){
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
            
            print(answerA.layer.opacity)
            print(answerB.layer.opacity)
            
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
            changeEvent()
        }
        
        totalAlpha = 0
        imageTouch = false
    }
    
    func changeEvent(){
        var eventTmp : GameEvent
        if indMageEvent < mageEvent.count{
            eventTmp = mageEvent[indMageEvent]
            indMageEvent += 1
        }else{
            actualDay += 60
            if actualDay >= 365 {
                actualYear += 1
                actualDay -= 365
            }
            saveGame()
            eventTmp = event[Int.random(in: 0..<event.count)]
        }
        loadRequest(eventTmp)
        
    }
    
    func loadRequest(_ event : GameEvent){
        requestLabel.text = event.request
        answerA.text = event.answerA
        answerB.text = event.answerB
        nameLabel.text = event.caracter.capitalized
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
