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
    
    var characters: [String:Bool] = [:]
    
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
    
    //ToDo
    // Méthode qui permet de débloquer l'affichage d'un succès dans la galerie quand on découvre ce succès.
    func discoverSuccess(successName: String) {
        successList[successName] = true
    }
    
}
