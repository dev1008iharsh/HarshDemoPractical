//
//  FavouriteVC.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class FavouriteVC: UIViewController {
    //MARK: -  @IBOutlet
    @IBOutlet weak var tblFavourite: UITableView!
    
    //MARK: -  Properties
    var marrFav = [ModelSwift]()
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        self.title = "Favourites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var marrCoreData = [CoreDataModel]()
        marrCoreData = DataBaseManager.shared.fetchFavourites()
        marrFav.removeAll()
        for data in marrCoreData{
            let model =  ModelSwift(albumId: Int(data.albumId), id: Int(data.id), title: (data.title ?? ""), url: (data.url ?? ""), thumbnailUrl: (data.thumbnailUrl ?? ""))
            marrFav.append(model)
        }
        
        print("self.marrFav",self.marrFav)
        self.tblFavourite.reloadData()
    }
    
    //MARK: - Helper Functions
    private func configureTable() {
        tblFavourite.dataSource = self
        tblFavourite.delegate = self
        let nib = UINib(nibName: Constant.TVC_HOME, bundle: nil)
        tblFavourite.register(nib, forCellReuseIdentifier: Constant.TVC_HOME)
    }
    
    
}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension FavouriteVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TVC_HOME, for: indexPath) as? HomeTVC else { return UITableViewCell()}
        
        cell.configureCellData(data: marrFav[indexPath.row])
        
        cell.selectionStyle = .none
        
        cell.btnFav.addTarget(self, action: #selector(btnFavTapped(sender:)), for:.touchUpInside)
        cell.btnFav.tag = indexPath.row
        
        
        return cell
    }
    
    @objc func btnFavTapped(sender: UIButton) {
        Utility.shared.lightHapticFeedBack()
        
        Utility.shared.showYesNoConfirmAlert(title: "Remove from favourites", message: "Are you sure want to remove it from favourites ?", view: self) { yesAction in
            
            let id = self.marrFav[sender.tag].id
            if Utility.shared.favouriteArrayIDs.contains(id){
                if let index = Utility.shared.favouriteArrayIDs.firstIndex(of: id) {
                    Utility.shared.favouriteArrayIDs.remove(at: index)
                }
                DataBaseManager.shared.deleteFavourites(id: self.marrFav[sender.tag].id)
                self.marrFav.remove(at: sender.tag)
            }
            
            print(Utility.shared.favouriteArrayIDs)
            Utility.shared.letestIDArrayToUserDefaults()
            
            DispatchQueue.main.async {
                self.tblFavourite.reloadData()
            }
            
            
        } NoAction: { noAction in
            print("no")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VC_DETAILS) as? HomeDetailsVC else { return }
        nextVC.dataModel = marrFav[indexPath.row]
        
        nextVC.isFavDetail = { (isfav) in
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeTVC else{
                return
            }
            if !isfav{
                if let indexPath = tableView.indexPath(for: cell) {
                    self.marrFav.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            
        }
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
