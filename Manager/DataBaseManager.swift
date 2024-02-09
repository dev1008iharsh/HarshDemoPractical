//
//  DataBaseManager.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//

import Foundation
import CoreData
import UIKit

class DataBaseManager{
    
    static let shared = DataBaseManager()
   
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
     
    func addFavouite(_ user: ModelSwift) {
        let entity = CoreDataModel(context: context)
        entity.albumId  = Int64(user.albumId)
        entity.id = Int64(user.id)
        entity.title = user.title
        entity.url = user.url
        entity.thumbnailUrl = user.thumbnailUrl
        saveContext()
    }

     
    func fetchFavourites() -> [CoreDataModel] {
        var dataEnity: [CoreDataModel] = []
        do {
            dataEnity = try context.fetch(CoreDataModel.fetchRequest())
        }catch {
            print("*** Fetch user error", error)
        }

        return dataEnity
    }
 

    func deleteFavourites(id: Int) {
        
        var arrDataEntity: [CoreDataModel] = []
        do {
            arrDataEntity = try context.fetch(CoreDataModel.fetchRequest())
        }catch {
            print("*** Fetch user error", error)
        }
        
        for entity in arrDataEntity{
            if entity.id == id{
                context.delete(entity)
                break
            }
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save() // aa karya vafar database ma save na thay
            print("*** Action Perfomed Success")
        }catch {
            print("*** Action Perfomed Failed", error)
        }
    }

}
 
