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



class GameViewController: UIViewController {
    
    var personnage : [String] = ["mage", "paysan", "paysane", "marchand", "reine", "chevalier", "templier", "ninja", "moine", "courtisane", "pape", "cultiste", "princesse", "seigneur", "conseiller"]
    var load : Bool = false
    var projectPath : String = ""
    var dataPath : String = ""
    
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

        //Je recupere les differents emplacement de fichier qui me serons utiles
        var THIS_FILES_PATH_AS_ARRAY:[String] = #file.split(separator: "/").map({String($0)})
        THIS_FILES_PATH_AS_ARRAY.removeLast(3)
        projectPath = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        THIS_FILES_PATH_AS_ARRAY.append("data")
        dataPath = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        let gameEventUrl : URL = URL(fileURLWithPath: "\(dataPath)/GameEvent.txt", isDirectory: false)
        do{
            let strEvent = try String(contentsOf: gameEventUrl)
            let strEventLine = strEvent.components(separatedBy: .newlines)
            print(strEventLine)
            
            //On recuere les informations du fichiers textes puis on les ajoute aux tableau d'evenement
            var persoAct = 0
            var nbPerso : Int = Int(strEventLine[0])!
            var i = 1
            while persoAct < 1{
                let nbEventPersoI : Int = Int(strEventLine[i])!
                print(nbEventPersoI)
                i += 1
                print(i)
                print(strEventLine[i+2])
                print(type(of: strEventLine[i+2]))
                print(Int(strEventLine[i+2])!)
                print(type(of: Int(strEventLine[i+2])!))
                let initialI = i
                print(strEventLine[28])
                while i < (initialI + (nbEventPersoI * 13)){
                    let tmpEvent : GameEvent = GameEvent(caracter: personnage[persoAct], request: strEventLine[i], answerA: strEventLine[i+1], influenceReligionA: Int(strEventLine[i+2])!, influencePopulationA: Int(strEventLine[i+3])!, influenceArmyA: Int(strEventLine[i+4])!, influenceWealthA: Int(strEventLine[i+5])!, influenceElectionA: Int(strEventLine[i+6])!, answerB: strEventLine[i+7], influenceReligionB: Int(strEventLine[i+8])!, influencePopulationB: Int(strEventLine[i+9])!, influenceArmyB: Int(strEventLine[i+10])!, influenceWealthB: Int(strEventLine[i+11])!, influenceElectionB: Int(strEventLine[i+12])!)
                    i += 13
                    print(i)
                    print((initialI + (nbEventPersoI * 14)))
                    if persoAct == 0{
                        mageEvent.append(tmpEvent)
                    }else{
                        event.append(tmpEvent)
                    }
                }
                persoAct += 1
            }            
        }catch{
            print(error)
        }
        for e in mageEvent{
            print(e.description)
        }
        
        
        
        // Do any additional setup after loading the view.
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
