//
//  HomeTVC.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import UIKit

class HomeTVC: UITableViewCell {

    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFav: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        imgData.layer.cornerRadius = imgData.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgData.image = nil
        lblAlbum.text = nil
        lblTitle.text = nil
        
    }
   
    
    func configureCellData(data : ModelSwift){
        
        if Utility.shared.favouriteArrayIDs.contains(data.id) {
            btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            btnFav.setImage(UIImage(systemName: "star"), for: .normal)
        }
        imgData.downloadImageWithCaching(urlString: (data.thumbnailUrl))
        lblAlbum.text = "Album ID : \(data.albumId)-\(data.id)"
       
        lblTitle.text = "Title : \(data.title)"
      
    }
    
}

