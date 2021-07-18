//
//  CreateJamViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 04/05/2021.
//

import UIKit

class CreateJamViewController: UIViewController {
    @IBOutlet var jamName: UITextField!
    @IBOutlet var jamDescription: UITextField!
    let JamApi = JamService()
    var token: String!
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenFile = getDocumentsDirectory().appendingPathComponent("token.txt")
        let idFile = getDocumentsDirectory().appendingPathComponent("id.txt")
        
        do {
            token = try String(contentsOf: tokenFile)
            
            let uid = try String(contentsOf: idFile)
            id = Int(uid)
        } catch {
            print("fail")
        }
        
    }

    @IBAction func createJam(_ sender: Any) {
        guard jamName.text != nil else {
            return
        }
        
        guard jamDescription.text != nil else {
            return
        }
        
        JamApi.createJam(token: self.token, uId: self.id, name: jamName.text!, description: jamDescription.text!){
            [self] (result) in
            switch result{
            case.success(let jam) :
                DispatchQueue.main.async {
                    let jamView = JamViewController.newInstance(nibName: "JamViewController", jam: jam.results)
                    self.navigationController?.pushViewController(jamView, animated: true)
                }
                break
            case.failure(let e) :
                print(e)
                break
            }
        }
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

}
