//
//  GameViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 02/04/2024.
//

import UIKit

enum Personnage{
    case mage
    case paysan
    case paysane
    case marchand
    case reine
    case chevalier
    case templier
    case ninja
    case moine
    case courtisane
    case pape
    case cultiste
    case princesse
    case seigneur
    case conseiller
}


class GameEvent{
    var caracter : Personnage
    var request : String
    var answerA : String
    var answerB : String
    
    var influenceReligion : Int
    var influencePopulation : Int
    var influenceArmy : Int
    var influenceWealth : Int
    var influenceElection : Int
    
    init(caracter: Personnage, request: String, answerA: String, answerB: String, influenceReligion: Int = 0, influencePopulation: Int = 0, influenceArmy: Int = 0, influenceWealth: Int = 0, influenceElection: Int = 0) {
        self.caracter = caracter
        self.request = request
        self.answerA = answerA
        self.answerB = answerB
        self.influenceReligion = influenceReligion
        self.influencePopulation = influencePopulation
        self.influenceArmy = influenceArmy
        self.influenceWealth = influenceWealth
        self.influenceElection = influenceElection
    }
}



class GameViewController: UIViewController {
    
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
    var firstEvent : GameEvent
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
