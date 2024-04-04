//
//  ViewController.swift
//  Living At Time
//
//  Created by Flavien Gonin on 02/04/2024.
//

import UIKit

class ViewController: UIViewController {

    var projectPath : String = ""
    @IBOutlet weak var loadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var THIS_FILES_PATH_AS_ARRAY:[String] = #file.split(separator: "/").map({String($0)})
        THIS_FILES_PATH_AS_ARRAY.removeLast(3)
        projectPath = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        THIS_FILES_PATH_AS_ARRAY.append("data/save.txt")
        let path = THIS_FILES_PATH_AS_ARRAY.joined(separator: "/")
        
        let saveUrl : URL = URL(fileURLWithPath: path, isDirectory: false)
        do{
            let strSave = try String(contentsOf: saveUrl)
            if strSave == ""{
                loadButton.isEnabled = false
            }
        }catch{
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let gvc = segue.destination as! GameViewController
        let b = sender as! UIButton
        gvc.load = (b.tag == 1)
    }

}

