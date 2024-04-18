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
    
    let successTitle: [String:String] = ["success1" : "Un plongeon éternel dans le temps...", "success2":"Immortalité, Aventure et égypte !", "success3":"Une fin heureuse, sous un beau soleil..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("avant ", successList)
        
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
            print(successName, successTitle[successName]!)
            if (discovery) {
                success[i].text = successTitle[successName]!
                successGallery[i].image = UIImage(named:successName)
            } else {
                successGallery[i].image = UIImage(named:"inconnu")
            }
            i += 1
        }
        
    }
    
}
