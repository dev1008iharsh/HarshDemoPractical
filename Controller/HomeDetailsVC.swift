//
//  HomeDetailsVCViewController.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class HomeDetailsVC: UIViewController {
    //MARK: -  @IBOutlet
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    //MARK: -  Properties
    var dataModel : ModelSwift!
    var isFavDetail: ((Bool) -> Void)?
   
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailData()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateFavBtn()
    }
    
    
    //MARK: -  Buttons Actions
    @IBAction func btnFavouriteTapped(_ sender: UIButton) {
        Utility.shared.lightHapticFeedBack()
        print("Before Click :",Utility.shared.favouriteArrayIDs)
        checkForFavourite()
    }
    
    
    //MARK: - Helper Functions
    private func configureDetailData(){
        
        imgData.layer.cornerRadius = imgData.frame.height/2
        imgData.downloadImageWithCaching(urlString: (dataModel.thumbnailUrl))
        lblAlbum.text = "Album ID : \(dataModel.albumId)-\(dataModel.id)"
        lblTitle.text = "Title : \(dataModel.title)"
        
    }
    
    private func updateFavBtn(){
        if Utility.shared.favouriteArrayIDs.contains(dataModel.id){
            btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.isFavDetail?(true)
        }else{
            btnFav.setImage(UIImage(systemName: "star"), for: .normal)
            self.isFavDetail?(false)
        }
    }
     
    private func checkForFavourite(){
        let id = dataModel.id
        if Utility.shared.favouriteArrayIDs.contains(id){
            if let index = Utility.shared.favouriteArrayIDs.firstIndex(of: id) {
                Utility.shared.favouriteArrayIDs.remove(at: index)
            }
            
            DataBaseManager.shared.deleteFavourites(id: id)
        }else{
            Utility.shared.favouriteArrayIDs.append(id)
            DataBaseManager.shared.addFavouite(dataModel)
        }
        updateFavBtn()
        Utility.shared.letestIDArrayToUserDefaults()
        print("After Click :",Utility.shared.favouriteArrayIDs)
    }
    
}
