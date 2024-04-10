//
//  PersonnageViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 04/04/2024.
//

import UIKit

class PersonnageViewController: UIViewController {

    @IBOutlet var gallery: [UIImageView]!
    
    var characters: [String:Bool] = ["mage":false, "paysan":false, "paysanne":false, "marchand":false, "reine":false, "chevalier":false, "templier":false, "ninja":false, "moine":false, "courtisane":false, "pape":false, "cultiste":false, "princesse":false, "seigneur":false, "conseiller":false, "viking":false, "chevalier_creuset":false, "robin":false, "assassin":false, "archer":false, "developpeur":false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var i: Int = 0
        print(gallery.count)
        print(gallery[0])
        print(characters.count)
        
        
        /*for (characterName, discovery) in characters {
            if (discovery) {
                gallery[i].image = UIImage(named:characterName)
            } else {
                gallery[i].image = UIImage(named:"inconnu")
            }
            i += 1
        }*/
    }
}
