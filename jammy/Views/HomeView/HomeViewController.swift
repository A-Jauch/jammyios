//
//  HomeViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 18/04/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var timer:Timer!
    var counter = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginFile = self.getDocumentsDirectory().appendingPathComponent("login.txt")
        do {
            let isLogged = try String(contentsOf: loginFile)
            if isLogged == "logged" {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerMenu), userInfo: nil, repeats: true)
            }else{
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerLogin), userInfo: nil, repeats: true)
            }
        } catch {
            let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navigationController?.pushViewController(login, animated: true);
        }
        
        
        
        // Do any additional setup after loading the view.
    }


    @objc func updateTimerMenu(){
        counter += 1
        if counter > 4 {
            timer?.invalidate()
            timer = nil
            let menu = MenuViewController(nibName: "MenuViewController", bundle: nil)
            self.navigationController?.pushViewController(menu, animated: true);
        }
    }
    
    @objc func updateTimerLogin(){
        counter += 1
        if counter > 4 {
            timer?.invalidate()
            timer = nil
            let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navigationController?.pushViewController(login, animated: true);
        }
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

}
