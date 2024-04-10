//
//  PersonnageViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 04/04/2024.
//

import UIKit

class PersonnageViewController: UIViewController {

    @IBOutlet var gallery: [UIImageView]!

    @IBOutlet var success: [UILabel]!
    
    var characters: [String:Bool] = ["mage":false, "paysan":false, "paysanne":false, "marchand":false, "reine":false, "chevalier":false, "templier":false, "ninja":false, "moine":false, "courtisane":false, "pape":false, "cultiste":false, "princesse":false, "seigneur":false, "conseiller":false, "viking":false, "chevalier_creuset":false, "robin":false, "assassin":false, "archer":false, "developpeur":false]
    
    var successList: [String:Bool] = ["Plongeon éternel dans le temps...":false, "Partons à l'aventure !":false, "Sous un beau soleil":false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i: Int = 0
        for (characterName, discovery) in characters {
            if (discovery) {
                gallery[i].image = UIImage(named:characterName)
            } else {
                gallery[i].image = UIImage(named:"inconnu")
            }
            i += 1
        }
        
        i = 0
        for (successName, discovery) in successList {
            if (discovery) {
                success[i].text = successName
            }
            i += 1
        }
    }
    
    // Méthode qui permet de débloquer l'affichage d'un personnage dans la galerie quand on découvre ce personnage en jeu.
    func discoverCharacter(characterName: String) {
        characters[characterName] = true
    }
    
    // Méthode qui permet de débloquer l'affichage d'un succès dans la galerie quand on découvre ce succès.
    func discoverSuccess(successName: String) {
        successList[successName] = true
    }
    
}
