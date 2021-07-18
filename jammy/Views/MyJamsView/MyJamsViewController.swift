//
//  MyJamsViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 17/05/2021.
//

import UIKit

class MyJamsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    let JamApi = JamService()
    private var jams:[Jam] = []
    var token:String!
    var id:Int!
    @IBOutlet var collectionView: UICollectionView!
    let cellIdentifier = "cellIdentifier"
    
    class func newInstance(nibName:String?, jams:[Jam]) -> MyJamsViewController{
        let myJams = MyJamsViewController(nibName: "MyJamsViewController", bundle: nil)
        myJams.jams = jams
        return myJams
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
        self.getJamsById(token: self.token, id: self.id)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func getJamsById(token: String, id: Int)->Void{
        JamApi.getJamsById(token: token, uid: id){
            [self] (result) in
                switch result{
                case.success(let jamsResult):
                    let j = jamsResult.results
                    for jam in j {
                        jams.append(jam)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
                        self.collectionView.register(UINib(nibName: "JamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
                    }
                    
                    break
                        
                case.failure(let e):
                    print(e)
                    break
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.jams.count < 1 ? 1 : self.jams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! JamCollectionViewCell
        
        if self.jams.count < 1 {
            cell.name.text = "Aucune Jam Créée"
            return cell
        }
        
        cell.name.text = jams[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let jamView = JamViewController.newInstance(nibName: "JamViewController", jam: jams[indexPath.item])
        self.navigationController?.pushViewController(jamView, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

}
