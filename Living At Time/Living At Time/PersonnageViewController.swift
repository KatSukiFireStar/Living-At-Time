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
    
    @IBOutlet var successGallery: [UIImageView]!
    
    var characters: [String:Bool] = [:]
    
    var successList: [String:Bool] = [:]
    
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
                successGallery[i].image = UIImage(named:"success" + String(i))
            } else {
                successGallery[i].image = UIImage(named:"inconnu")
            }
            i += 1
        }
        
    }
    
}
