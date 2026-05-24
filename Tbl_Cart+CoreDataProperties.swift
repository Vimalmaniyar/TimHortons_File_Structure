//
//  Tbl_Cart+CoreDataProperties.swift
//  TeamHortons
//
//  Created by vimal maniyar on 28/12/22.
//
//

import Foundation
import CoreData


extension Tbl_Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tbl_Cart> {
        return NSFetchRequest<Tbl_Cart>(entityName: "Tbl_Cart")
    }

    @NSManaged public var id: String?
    @NSManaged public var strore_id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var created_at: String?
    @NSManaged public var inactivate_at: String?
    @NSManaged public var price: Double
    @NSManaged public var discount: Double
    @NSManaged public var is_active: Bool
    @NSManaged public var is_showed_cart_upsell: Bool
    @NSManaged public var upsell_showed_for_store_id: String
    
    @NSManaged public var menu_id: String?
    @NSManaged public var menu_name: String?

}
struct Tbl_Cart_DBBind:Codable{
    var id: String?
    var strore_id: String?
    var latitude: Double?
    var longitude: Double?
    var created_at: String?
    var inactivate_at: String?
    var price: Double
    var discount:Double
    var is_active: Bool
    var is_showed_cart_upsell:Bool
    var upsell_showed_for_store_id:String?
    
    var menu_id: String
    var menu_name: String

}
extension Tbl_Cart : Identifiable {
    func toData() -> Tbl_Cart_DBBind {
        let obj = Tbl_Cart_DBBind(id: self.id,
                                  strore_id: self.strore_id,
                                  latitude: self.latitude,
                                  longitude: self.longitude,
                                  created_at: self.created_at,
                                  inactivate_at: self.inactivate_at,
                                  price: self.price,
                                  discount: self.discount,
                                  is_active: self.is_active, 
                                  is_showed_cart_upsell: self.is_showed_cart_upsell,
                                  upsell_showed_for_store_id: self.upsell_showed_for_store_id,
                                  menu_id:self.menu_id ?? "",
                                  menu_name:self.menu_name ?? "")
       return obj
    }
}
extension Tbl_Cart_DBBind{

     var getBindDBData : [String:Any]? {
        guard let objDict = self.dictionary else {
            return nil
        }
        return objDict
    }
}
extension Tbl_Cart {
    // batch insert
    internal static func insertData(dictData: [[String: Any]], context: NSManagedObjectContext,completion: ((Bool) -> Void)?) {
        CoreDataManager.sharedInstance.batchInsertData(entity: .Tbl_Cart, dictData: dictData, context: context, completion: completion)
    }
    internal static func deleteData(context: NSManagedObjectContext,completion: ((Bool) -> Void)?) {
        CoreDataManager.sharedInstance.batchDeleteData(fetchRequest: Tbl_Cart.fetchRequest(), context: context, completion: completion)
    }
    
    // batch update
    internal static func updateData(dictData: [String: Any], context: NSManagedObjectContext ,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "id == %@", (dictData["id"] as? String ?? ""))
        //CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context)
        
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context,completion: completion)
        
    }
    internal static func updateData(cartId:String,isUpSellShowed:Bool, context: NSManagedObjectContext ,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "id == %@", cartId)
        //CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context)
        var dictData = ["is_showed_cart_upsell":isUpSellShowed] as [String : Any]
        if isUpSellShowed{
            let currentRestaurant = Global.getSelectedResataurant()
            dictData = ["is_showed_cart_upsell":isUpSellShowed,"upsell_showed_for_store_id":currentRestaurant] as [String : Any]
        }
       
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context,completion: completion)
        
    }
    internal static func updateData(cartId:String,menuId:String,menuName:String, context: NSManagedObjectContext ,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "id == %@", cartId)
        //CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context)
        let dictData = ["menu_id":menuId,"menu_name":menuName] as [String : Any]
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context,completion: completion)
        
    }
    
    internal static func changeToUnActiveCart(cartID: String, context: NSManagedObjectContext ,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "id == %@", cartID)
        //CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context)
        let dictData = ["is_active":false,"inactivate_at":"".getCurrentTime_yyyy_MM_dd_T_HH_mm_ssz(isUTC: true)] as [String : Any]
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context,completion: completion)
        
    }
    internal static func updateOfferDiscountOnCart(cartID: String,discount:Double, context: NSManagedObjectContext ,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "id == %@", cartID)
        //CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context)
        let dictData = ["discount":discount] as [String : Any]
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Cart, predicate: predicate, dictData: dictData, context: context,completion: completion)
        
    }
    
    internal static func updateData(objFolder: Tbl_Cart_DBBind, context: NSManagedObjectContext) {
        //Update
        guard let objUpdatedDict = objFolder.getBindDBData else {
            return
        }
        Tbl_Cart.updateData(dictData: objUpdatedDict, context: context,completion: nil)
    }
    
    internal static func getRecords(id: String, in context:NSManagedObjectContext) -> [Tbl_Cart_DBBind]? {
        let fetchRequest : NSFetchRequest<Tbl_Cart>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                print(result.count)
                print(result)
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    internal static func getAllCartActiveRecords(isActive:Bool,in context:NSManagedObjectContext) -> [Tbl_Cart_DBBind]? {
        let fetchRequest : NSFetchRequest<Tbl_Cart>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_active == %@", NSNumber(value: isActive))
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                
                print(result.count)
                print(result)
                let arr = result.map({$0.toData()})
                return arr
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
}
