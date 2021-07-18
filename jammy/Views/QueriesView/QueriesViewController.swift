//
//  QueriesViewController.swift
//  jammy
//
//  Created by Antoine THIEL on 01/06/2021.
//

import UIKit

class QueriesViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var jam: Jam!
    let QueryApi = QueriesService()
    var queries:[UserQuery] = []
    var queriesUser:[QueryUser] = []
    var token:String!
    var id:Int!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, QueryUser>!
    var snapShot: NSDiffableDataSourceSnapshot<Section, QueryUser>!
    
    class func newInstance(nibName: String?, jam: Jam) -> QueriesViewController{
        let query = QueriesViewController(nibName: "QueriesViewController", bundle: nil)
        query.jam = jam
        return query
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            let action1 = UIContextualAction(style: .normal, title: "Accepter") { (action, view, completion) in
                handleSwipe1(for: action, item: item, index: indexPath.row)
                completion(true)
            }
            action1.backgroundColor = .systemGreen
            
            let action2 = UIContextualAction(style: .normal, title: "Rejeter") { (action, view, completion) in
                handleSwipe2(for: action, item: item, index: indexPath.row)
                completion(true)
            }
            action2.backgroundColor = .systemPink
            
            return UISwipeActionsConfiguration(actions: [action2, action1])
            
        }
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
        ])
        
        let tokenFile = getDocumentsDirectory().appendingPathComponent("token.txt")
        let idFile = getDocumentsDirectory().appendingPathComponent("id.txt")
        do {
            token = try String(contentsOf: tokenFile)
            
            let uid = try String(contentsOf: idFile)
            id = Int(uid)
        } catch {
            print("fail")
        }
        self.getQueries(token: token, jamId: jam.id)
        
    }
    
    private func getQueries(token: String, jamId: Int)->Void{
        QueryApi.getQueriesByJam(token: token, jamId: jamId){
            [self] (result) in
                switch result{
                case.success(let queriesResult):
                    if !queriesResult.results.isEmpty {
                        for q in queriesResult.results {
                            if q.status == 0 {
                                queriesUser.append(QueryUser(name: q.user.name + " " + q.user.lastname, instrument: q.user.instrument.name, queryId: q.id))
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        
                        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, QueryUser> { (cell, indexPath, item) in
                            
                            var content = cell.defaultContentConfiguration()
                            content.text = item.name + " " + item.instrument
                            cell.contentConfiguration = content
                        }
                        
                        dataSource = UICollectionViewDiffableDataSource<Section, QueryUser>(collectionView: collectionView) {
                            (collectionView: UICollectionView, indexPath:IndexPath, identifier: QueryUser) -> UICollectionViewCell? in
                            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
                            cell.accessories = [.disclosureIndicator()]
                            
                            return cell
                        }
                     snapShot = NSDiffableDataSourceSnapshot<Section, QueryUser>()
                     snapShot.appendSections([.main])
                     snapShot.appendItems(queriesUser, toSection: .main)
                     
                     dataSource.apply(snapShot, animatingDifferences: false)
                        
                    }
                    break
                        
                case.failure(let e):
                    print(e)
                    break
                }
        }
    }
    
    private func updateQuery(token: String, jamId: Int, queryId: Int, userId: Int, accept: Int, index: Int)->Void{
        QueryApi.updateQuery(token: token, queryId: queryId, jamId: jamId, userId: userId, accept: accept){
            [self] (result) in
                switch result{
                case.success(_):
                    DispatchQueue.main.async {
                        //Remove Cell
                        self.queriesUser.remove(at: index)
                        snapShot = NSDiffableDataSourceSnapshot<Section, QueryUser>()
                        snapShot.appendSections([.main])
                        snapShot.appendItems(self.queriesUser, toSection: .main)
                        
                        dataSource.apply(snapShot, animatingDifferences: false)
                        print("data reloaded")
                    }
                    break
                        
                case.failure(let e):
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

private extension QueriesViewController {
    func handleSwipe1(for action: UIContextualAction, item: QueryUser, index: Int) {
        //Accept User In Jam
        print("swipe 1")
        self.updateQuery(token: self.token, jamId: jam.id, queryId: item.queryId, userId: id, accept: 1, index: index)
    }
    
    func handleSwipe2(for action: UIContextualAction, item: QueryUser, index: Int) {
        //Decline User In Jam
        print("swipe 2")
        self.updateQuery(token: self.token, jamId: jam.id, queryId: item.queryId, userId: id, accept: 2, index: index)
    }
}
