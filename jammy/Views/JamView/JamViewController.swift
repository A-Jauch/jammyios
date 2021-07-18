//
//  JamViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 17/05/2021.
//

import UIKit

class JamViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate {
    
    private var jam: Jam!
    let SessionApi = SessionService()
    let JamApi = JamService()
    @IBOutlet var titleField: UILabel!
    @IBOutlet var descriptionField: UILabel!
    @IBOutlet var createdAtField: UILabel!
    var token:String!
    var id:Int!
    var participants:[UserJam] = []
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "cellIdentifier"
    
    
    class func newInstance(nibName: String?, jam: Jam) -> JamViewController{
        let jamView = JamViewController(nibName: "JamViewController", bundle: nil)
        jamView.jam = jam
        return jamView
    }

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
        self.titleField.text = jam.name
        self.descriptionField.text = jam.description
        self.createdAtField.text = jam.createdAt
        self.getParticipants(token: token, jamId: jam.id)

    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    
    private func getParticipants(token: String, jamId: Int)->Void{
        SessionApi.getSession(token: token, jamId: jamId){
            [self] (result) in
                switch result{
                case.success(let sessionResult):
                    if !sessionResult.results.isEmpty {
                        for s in sessionResult.results {
                            participants.append(s.user)
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.register(UINib(nibName: "JamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
                        
                    }
                    break
                        
                case.failure(let e):
                    print(e)
                    break
                }
        }
    }
    
    private func deleteJam(token: String, uId: Int , jamId: Int)->Void{
        JamApi.deleteJam(token: token, uId: uId, jamId: jamId){
            [self] (result) in
            switch result{
                case.success(_) :
                    DispatchQueue.main.async {
                        let jams = MyJamsViewController(nibName: "MyJamsViewController", bundle: nil)
                        self.navigationController?.pushViewController(jams, animated: true)
                    }
                    break
                case.failure(let e):
                    print(e)
                    break
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.participants.count < 1 ? 1 : self.participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! JamCollectionViewCell
        
        if self.participants.count < 1 {
            cell.name.text = "Aucun Participants"
            return cell
        }
        cell.name.text = self.participants[indexPath.item].name + " " + self.participants[indexPath.item].instrument.name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell \(indexPath)")
    }

    @IBAction func deleteJam(_ sender: Any) {
        self.deleteJam(token: self.token, uId: self.id, jamId: jam.id)
    }
    @IBAction func goToQueries(_ sender: Any) {
        let queries = QueriesViewController.newInstance(nibName: "QueriesViewController", jam: jam)
        self.navigationController?.pushViewController(queries, animated: true)
    }
}
