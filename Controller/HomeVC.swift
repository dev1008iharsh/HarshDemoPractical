//
//  HomeVC.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var tblHomeFeed: UITableView!
    
    
    //MARK: -  Properties
    var marrData = [ModelSwift]()
    var marrfilteredData = [ModelSwift]()
    var totalPage = 10
    var currentPage = 0
    var isSearching = false
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        Utility.shared.showLoader(true)
        
        configureTable()
        configureSearchController()
        fetchHomeData()
        getGetSavedData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblHomeFeed.reloadData()
    }
    
    //MARK: - Helper Functions
    private func getGetSavedData() {
        if let savedArray: [Int] = UserDefaults.standard.customModelArray(forKey: "SavedArray") {
            Utility.shared.favouriteArrayIDs = savedArray
            print("favouriteArrayIDs",Utility.shared.favouriteArrayIDs)
        }else{
            print("favouriteArrayIDs",Utility.shared.favouriteArrayIDs)
        }
    }
    
    private func configureTable() {
        
        tblHomeFeed.dataSource = self
        tblHomeFeed.delegate = self
        let nib = UINib(nibName: Constant.TVC_HOME, bundle: nil)
        tblHomeFeed.register(nib, forCellReuseIdentifier: Constant.TVC_HOME)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a data"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    
    //MARK: -  API Call Functions
    private func fetchHomeData(){
        currentPage += 1
        NetworkManager.shared.requestApi(modelType: [ModelSwift].self, urlString: "photos?albumId=\(currentPage)", httpMethod: .get) { result in
            DispatchQueue.main.async {
                Utility.shared.showLoader(false)
                Utility.shared.heavyHapticFeedBack()
                self.tblHomeFeed.stopLoading()
            }
            
            switch result {
            case .success(let dataFromApi):
                
                DispatchQueue.main.async {
                    self.marrData += dataFromApi
                    self.tblHomeFeed.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
//MARK: -  UISearchResultsUpdating
extension HomeVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            marrfilteredData.removeAll()
            isSearching = false
            self.tblHomeFeed.reloadData()
            isSearching = false
            return
        }
        
        isSearching = true
        marrfilteredData = marrData.filter { $0.title.lowercased().contains(filter.lowercased()) }
        self.tblHomeFeed.reloadData()
    }
    
}

//MARK: -  UITableViewDelegate, UITableViewDataSource
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? marrfilteredData.count : marrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TVC_HOME, for: indexPath) as? HomeTVC else { return UITableViewCell()}
        
        cell.configureCellData(data: isSearching ? marrfilteredData[indexPath.row] : marrData[indexPath.row])
        
        cell.selectionStyle = .none
        
        cell.btnFav.addTarget(self, action: #selector(btnFavTapped(sender:)), for:.touchUpInside)
        cell.btnFav.tag = indexPath.row
        
        return cell
    }
    
    @objc func btnFavTapped(sender: UIButton) {
        Utility.shared.lightHapticFeedBack()
        
        
        if isSearching{
            let id = marrfilteredData[sender.tag].id
            
            if Utility.shared.favouriteArrayIDs.contains(id){
                if let index = Utility.shared.favouriteArrayIDs.firstIndex(of: id) {
                    Utility.shared.favouriteArrayIDs.remove(at: index)
                }
                DataBaseManager.shared.deleteFavourites(id: marrfilteredData[sender.tag].id)
            }else{
                Utility.shared.favouriteArrayIDs.append(id)
                DataBaseManager.shared.addFavouite(marrfilteredData[sender.tag])
            }
            
        }else{
            let id = marrData[sender.tag].id
            if Utility.shared.favouriteArrayIDs.contains(id){
                if let index = Utility.shared.favouriteArrayIDs.firstIndex(of: id) {
                    Utility.shared.favouriteArrayIDs.remove(at: index)
                }
                
                DataBaseManager.shared.deleteFavourites(id: marrData[sender.tag].id)
            }else{
                Utility.shared.favouriteArrayIDs.append(id)
                DataBaseManager.shared.addFavouite(marrData[sender.tag])
            }
        }
        print(Utility.shared.favouriteArrayIDs)
        Utility.shared.letestIDArrayToUserDefaults()
        
        DispatchQueue.main.async {
            self.tblHomeFeed.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.VC_DETAILS) as? HomeDetailsVC else { return }
        
        if isSearching{
            nextVC.dataModel = ModelSwift(albumId: marrfilteredData[indexPath.row].albumId, id: marrfilteredData[indexPath.row].id, title: marrfilteredData[indexPath.row].title, url: marrfilteredData[indexPath.row].url, thumbnailUrl: marrfilteredData[indexPath.row].thumbnailUrl)
            
        }else{
            nextVC.dataModel = ModelSwift(albumId: marrData[indexPath.row].albumId, id: marrData[indexPath.row].id, title: marrData[indexPath.row].title, url: marrData[indexPath.row].url, thumbnailUrl: marrData[indexPath.row].thumbnailUrl)
        }
        
        
        nextVC.isFavDetail = { (isfav) in
            guard let cell = tableView.cellForRow(at: indexPath) as? HomeTVC else{
                return
            }
            if isfav{
                cell.btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                cell.btnFav.setImage(UIImage(systemName: "star"), for: .normal)
            }
            
        }
        
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
            if tableView.visibleCells.contains(cell) {
                if (indexPath.row == self.marrData.count - 1) && (self.totalPage > self.currentPage){
                    
                    self.fetchHomeData()
                    tableView.addLoading(indexPath)
                }
            }
        }
        
        
    }
    
    
    
}
