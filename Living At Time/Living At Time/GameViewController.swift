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
    
    init(caracter: String, request: String, answerA: String,  influenceReligionA: Int, influencePopulationA: Int, influenceArmyA: Int, influenceWealthA: Int, influenceElectionA: Int, answerB: String, influenceReligionB: Int, influencePopulationB: Int, influenceArmyB: Int, influenceWealthB: Int, influenceElectionB: Int) {
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
    }
    
    var description : String{
        return "Caracter: \(caracter), Request: \(request), AnswerA: \(answerA), influenceReligionA: \(influenceReligionA), influencePopulationA: \(influencePopulationA), influenceArmyA: \(influenceArmyA), influenceWealthA: \(influenceWealthA), influenceElectionA: \(influenceElectionA), answerB: \(answerB), influenceReligionB: \(influenceReligionB), influencePopulationB: \(influencePopulationB), influenceArmyB: \(influenceArmyB), influenceWealthB: \(influenceWealthB), influenceElectionB: \(influenceElectionB)"
    }
}

let MAX_COUNT : Int = 8

class GameViewController: UIViewController {
    
    var personnage : [String] = ["mage", "paysan", "paysane", "marchand", "reine", "chevalier", "templier", "ninja", "moine", "courtisane", "pape", "cultiste", "princesse", "seigneur", "conseiller"]
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
    
    @IBOutlet weak var caracterImage: UIImageView!
    
    var event : [GameEvent] = []
    var mageEvent : [GameEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
        
        if !load{
            // On joue en premier les evenements du mage
            requestLabel.text = mageEvent[0].request
            answerA.text = mageEvent[0].answerA
            answerB.text = mageEvent[0].answerB
            nameLabel.text = mageEvent[0].caracter.capitalized
            caracterImage.image = UIImage(named: mageEvent[0].caracter)
        }else{
            //On joue un evenement aléatoires des autres personnages
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
            
            if Int(strSaveLine[0])! != religionCount || Int(strSaveLine[1])! != populationCount || Int(strSaveLine[2])! != armyCount || wealthCount != Int(strSaveLine[3])! || popularityCount != Int(strSaveLine[4])! || timeCount != Int(strSaveLine[5])!{
                load = true
            }
            if load{
                religionCount = Int(strSaveLine[0])!
                populationCount = Int(strSaveLine[1])!
                armyCount = Int(strSaveLine[2])!
                wealthCount = Int(strSaveLine[3])!
                popularityCount = Int(strSaveLine[4])!
                timeCount = Int(strSaveLine[5])!
                updateScreen()
            }
            
        }catch{
            print(error)
        }
    }
    
    func updateScreen(){
        timeLabel.text = String(timeCount)
        popularityLabel.text = "\(popularityCount)%"
        religion.image = UIImage(named: "religion\(religionCount)")
        population.image = UIImage(named: "population\(populationCount)")
        army.image = UIImage(named: "army\(armyCount)")
        wealth.image = UIImage(named: "wealth\(wealthCount)")
    }
    
    func finDePartie(){
        
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
            let bottomYImage = coordImage.y + (caracterImage.image?.size.height)!
            
            //Le but est de representer virtuellement un triangle rectangle afin de pouvoir  calculer l'angle qu'il faudra appliquer a mon image lors d'un mouvement.
            
            
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
            print(totalAlpha)
            
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
        answerA.center = coordAnswerA
        answerB.center = coordAnswerB
        caracterImage.center = coordImage
        caracterImage.transform = caracterImage.transform.rotated(by: -totalAlpha)
        answerA.transform = answerA.transform.rotated(by: -totalAlpha)
        answerB.transform = answerB.transform.rotated(by: -totalAlpha)
        if abs(totalAlpha) >= 0.25{
            print("Changement")
        }
        
        totalAlpha = 0
        imageTouch = false
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
