//
//  MenuViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 19/04/2021.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func goToJam(_ sender: Any) {
        let createJam = CreateJamViewController(nibName: "CreateJamViewController", bundle: nil)
        self.navigationController?.pushViewController(createJam, animated: true)
    }
    

    @IBAction func goToMyJams(_ sender: Any) {
        let myJams = MyJamsViewController(nibName: "MyJamsViewController", bundle: nil)
        self.navigationController?.pushViewController(myJams, animated: true)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let loginFile = self.getDocumentsDirectory().appendingPathComponent("login.txt")
        let notLogged = "notLogged"
        do {
            try notLogged.write(to: loginFile, atomically: true, encoding: String.Encoding.utf8)
        } catch (let e) {
            print(e)
        }
        
        let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
}
