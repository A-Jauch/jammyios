//
//  LoginViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 01/05/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    let UserApi = UserService()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickLogin(_ sender: Any) {
        
        guard email.text != nil else {
            return
        }
        
        guard password.text != nil else {
            return
        }
        
        UserApi.connectUser(identifier: email.text!, password: password.text!) {
            [self] (result) in
                switch result{
                case.success(let user):
                    let token = user.accessToken
                    let logged = "logged"
                    let tokenFile = getDocumentsDirectory().appendingPathComponent("token.txt")
                    let loginFile = getDocumentsDirectory().appendingPathComponent("login.txt")
                    do {
                        try token.write(to: tokenFile, atomically: true, encoding: String.Encoding.utf8)
                        try logged.write(to: loginFile, atomically: true, encoding: String.Encoding.utf8)
                    } catch (let e) {
                        print(e)
                    }
                    UserApi.me(token: token){
                        (result) in
                        switch result{
                        case.success(let userDetails):
                            let uidInt = userDetails.results.id
                            let uid = String(uidInt)
                            let name = userDetails.results.name
                            let lastName = userDetails.results.lastname
                            
                            let uidFile = getDocumentsDirectory().appendingPathComponent("id.txt")
                            let nameFile = getDocumentsDirectory().appendingPathComponent("name.txt")
                            let lastNameFile = getDocumentsDirectory().appendingPathComponent("lastName.txt")
                            
                            do {
                                try uid.write(to: uidFile, atomically: true, encoding: String.Encoding.utf8)
                                try name.write(to: nameFile, atomically: true, encoding: String.Encoding.utf8)
                                try lastName.write(to: lastNameFile, atomically: true, encoding: String.Encoding.utf8)
                            }catch(let e){
                                print(e)
                            }
                            
                            break
                        case.failure(let e):
                            print(e)
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        let menu = MenuViewController(nibName: "MenuViewController", bundle: nil)
                        self.navigationController?.pushViewController(menu, animated: true)
                    }
                    break
                        
                case.failure(let e):
                    print(e)
                    break
                }
            
        }
    }
//                    let userid = user.user.id

//                    let idFile = getDocumentsDirectory().appendingPathComponent("id.txt")
//                    let login = self.getDocumentsDirectory().appendingPathComponent("login.txt")
//                    let account = self.getDocumentsDirectory().appendingPathComponent("account.txt")

//                        let stringId = String(userid)
//                        try stringId.write(to: idFile, atomically: true, encoding: String.Encoding.utf8)
//
//                        let input = "isConnected"
//                        try input.write(to: login, atomically: true, encoding: String.Encoding.utf8)
//
//                        var accountString = try String(contentsOf: account)
//                        if  accountString != "true" {
//                            accountString = "true"
//                            try accountString.write(to: account, atomically: true, encoding: String.Encoding.utf8)
//                        }
                        

    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
