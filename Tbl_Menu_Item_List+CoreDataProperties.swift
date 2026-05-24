//
//  Tbl_Menu_Item_List+CoreDataProperties.swift
//  TeamHortons
//
//  Created by vimal maniyar on 02/12/22.
//
//

import Foundation
import CoreData


extension Tbl_Menu_Item_List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tbl_Menu_Item_List> {
        return NSFetchRequest<Tbl_Menu_Item_List>(entityName: "Tbl_Menu_Item_List")
    }

    @NSManaged public var modifiers: String?
    @NSManaged public var tpn: Int64
    @NSManaged public var loyalty_sk_id: String?
    @NSManaged public var loyalty_tpn: Int64
    @NSManaged public var menu_code: String?
    @NSManaged public var name: String?
    @NSManaged public var key_description: String?
    @NSManaged public var sk_id: String?
    @NSManaged public var item_type: String?
    @NSManaged public var max_quantity: Int64
    @NSManaged public var is_drink: Bool
    @NSManaged public var is_popular: Bool
    @NSManaged public var is_multibox: Bool
    @NSManaged public var allow_customize: Bool
    @NSManaged public var calorie: Int64
    @NSManaged public var image: String?
    @NSManaged public var display_image: Bool
    @NSManaged public var title: String?
    @NSManaged public var display_title: Bool
    @NSManaged public var is_root_display: Bool
    @NSManaged public var meal_title: String?
    @NSManaged public var box_title: String?
    @NSManaged public var price: Double
    @NSManaged public var upcharge_price: Double
    @NSManaged public var filters: String?
    @NSManaged public var tax_groups: String?
    @NSManaged public var key_id: String?
    @NSManaged public var start_date: String?
    @NSManaged public var start_time: String?
    @NSManaged public var end_date: String?
    @NSManaged public var end_time: String?
    @NSManaged public var variants: String?
    @NSManaged public var box: String?
    @NSManaged public var meals: String?
    @NSManaged public var attachment: String?
    @NSManaged public var upsell: String?
    @NSManaged public var promotion_price: String?
    @NSManaged public var meal_upcharge_price: String?
    @NSManaged public var is_disable: Bool
    @NSManaged public var is_hidden: Bool
    @NSManaged public var is_favourite:Bool
    @NSManaged public var action_type:String?
    @NSManaged public var nutritional_allergens:String?

    // ATTRIBUTES FOR IDENTIFIENG IS ITEM IS PRESENT IN CURRENT MENU
    @NSManaged public var current_menu_item_identification_name: String?
    @NSManaged public var current_menu_item_entity_type: String?
    @NSManaged public var current_menu_item_entity_image: String?
    @NSManaged public var current_menu_item_entity_id: String?
    @NSManaged public var current_menu_id: String?
}

extension Tbl_Menu_Item_List : Identifiable {
    func toData() -> ItemListData {
        let arrayFilters = self.filters?.split(separator: "-").map({String($0)})
        let arrayTaxGroup = self.tax_groups?.split(separator: "-").map({String($0)})
        
        let obj = ItemListData(modifiers: self.modifiers?.convertToModel(),
                               tpn: Int(self.tpn),
                               loyaltyTPN: Int(self.loyalty_tpn),
                               name: self.name,
                               menuCode: self.menu_code,
                               description: self.key_description,
                               skID: self.sk_id,
                               loyaltySkId: self.loyalty_sk_id,
                               itemType: self.item_type,
                               maxQuantity: Int(self.max_quantity),
                               isDrink: self.is_drink,
                               isPopular: self.is_popular,
                               isMultibox: self.is_multibox,
                               //allowCustomize: self.allow_customize,
                               calorie: Int(self.calorie),
                               image: self.image,
                               title: self.title,
                               displayImage: self.display_image,
                               displayTitle: self.display_title,
                               isRootDisplay: self.is_root_display,
                               mealTitle: self.meal_title,
                               boxTitle: self.box_title,
                               price: self.price,
                               upchargePrice: self.upcharge_price,
                               filters: arrayFilters,
                               taxGroups: arrayTaxGroup,
                               id: self.key_id,
                               startDate: self.start_date,
                               startTime: self.start_time,
                               endDate: self.end_date,
                               endTime: self.end_time,
                               variants: self.variants?.convertToModel(),
                               box: self.box?.convertToModel(),
                               meals: self.meals?.convertToModel(),
                               attachments: self.attachment?.convertToModel(),
                               upsell: self.upsell?.convertToModel(),
                               promotionPrice: self.promotion_price?.convertToModel(),
                               mealUpchargePrice: self.meal_upcharge_price?.convertToModel(),
                               is_disable: self.is_disable,
                               is_hidden: self.is_hidden,
                               is_favourite: self.is_favourite,
                               allowCustomize: self.allow_customize,
                               action_type: EnumActionType(rawValue: self.action_type ?? EnumActionType.item.rawValue),
                               nutritional_allergens: self.nutritional_allergens,
                               current_menu_item_identification_name: self.current_menu_item_identification_name,
                               
                               current_menu_item_entity_type: EnumCurreentMenuItemType(rawValue: self.current_menu_item_entity_type ?? EnumCurreentMenuItemType.notCurrentMenuItem.rawValue)!,
                               
                               current_menu_item_entity_image: self.current_menu_item_entity_image,
                               current_menu_item_entity_id: self.current_menu_item_entity_id,
                               current_menu_id: self.current_menu_id)
        
       return obj
    }
    

}
extension ItemListData{

     var getBindDBData : [String:Any]? {
        guard var objDict = self.dictionary else {
            return nil
        }
         if self.is_hidden == nil{
             objDict[ItemListData.CodingKeys.is_hidden.rawValue] = false
         }
         if self.is_disable == nil{
             objDict[ItemListData.CodingKeys.is_disable.rawValue] = false
         }
         if self.current_menu_item_entity_type == nil{
             objDict[ItemListData.CodingKeys.current_menu_item_entity_type.rawValue] = EnumCurreentMenuItemType.notCurrentMenuItem.rawValue
         }
         if self.current_menu_item_identification_name == nil{
             objDict[ItemListData.CodingKeys.current_menu_item_identification_name.rawValue] = EnumCurreentMenuItemType.notCurrentMenuItem.rawValue
         }
         if self.current_menu_item_entity_image == nil{
             objDict[ItemListData.CodingKeys.current_menu_item_entity_image.rawValue] = ""
         }
         if self.current_menu_item_entity_id == nil{
             objDict[ItemListData.CodingKeys.current_menu_item_entity_id.rawValue] = ""
         }
         if self.current_menu_id == nil{
             objDict[ItemListData.CodingKeys.current_menu_id.rawValue] = ""
         }
         if self.action_type == nil{
             objDict[ItemListData.CodingKeys.action_type.rawValue] = "item"
         }
        // CHANGE KEY OF DICT MODEL
         
         // NOTE IF ANY CHANGE APPERS IN BELOW KEY WHICH CHANGES REQUIRED YOU ALSO NEED TO UPDATE IN updateIdentificationForCurrentMenu FUNC OF CDMenuData 
         objDict = objDict.changeKey(from: ItemListData.CodingKeys.id.rawValue, to: "key_id")
         objDict = objDict.changeKey(from: ItemListData.CodingKeys.description.rawValue, to: "key_description")
        // ABOVE IS CHANGE KEY TO STORE DATA IN DB AND MAKE SAME KEY AS LIKE TABLE KEY
        
        // CONVERT MODEL TO JSON SSTRING AND STRORE IN DB
        // INSIDE DB DATA TYPE WILL BE STRING
        objDict[ItemListData.CodingKeys.modifiers.rawValue] = self.modifiers?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.variants.rawValue] = self.variants?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.box.rawValue] = self.box?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.meals.rawValue] = self.meals?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.attachments.rawValue] = self.attachments?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.upsell.rawValue] = self.upsell?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.mealUpchargePrice.rawValue] = self.mealUpchargePrice?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.promotionPrice.rawValue] = self.promotionPrice?.convertToJSONString()
         
         objDict[ItemListData.CodingKeys.taxGroups.rawValue] = self.taxGroups?.joined(separator:"-")
         objDict[ItemListData.CodingKeys.filters.rawValue] = self.filters?.joined(separator:"-")
         
         objDict[ItemListData.CodingKeys.name.rawValue] = self.name
         
         objDict[ItemListData.CodingKeys.title.rawValue] = self.title
       
        return objDict
    }
}
extension Tbl_Menu_Item_List {
    // batch insert
    internal static func insertData(dictData: [[String: Any]], context: NSManagedObjectContext,completion: ((Bool) -> Void)?) {
        CoreDataManager.sharedInstance.batchInsertData(entity: .Tbl_Menu_Item_List, dictData: dictData, context: context, completion: completion)
    }
    internal static func deleteData(context: NSManagedObjectContext,completion: ((Bool) -> Void)?) {
        CoreDataManager.sharedInstance.batchDeleteData(fetchRequest: Tbl_Menu_Item_List.fetchRequest(), context: context, completion: completion)
    }
    
    // batch update
    internal static func updateData(dictData: [String: Any], context: NSManagedObjectContext,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "key_id == %@", (dictData["key_id"] as? String ?? ""))
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Menu_Item_List, predicate: predicate, dictData: dictData, context: context,completion: completion)
    }
    internal static func updateCurrentMenuIdentificatioReset(arrIds: [String], context: NSManagedObjectContext,completion: ((Bool)->Void)?) {
        let predicate = NSPredicate(format: "key_id IN %@", arrIds)
        let objDict = [ItemListData.CodingKeys.current_menu_item_entity_type.rawValue : EnumCurreentMenuItemType.notCurrentMenuItem.rawValue,
                       
            ItemListData.CodingKeys.current_menu_item_identification_name.rawValue : EnumCurreentMenuItemType.notCurrentMenuItem.rawValue,
                       
            ItemListData.CodingKeys.current_menu_item_entity_image.rawValue : "",
                       
            ItemListData.CodingKeys.current_menu_item_entity_id.rawValue : "",
                       
            ItemListData.CodingKeys.current_menu_id.rawValue : ""]
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Menu_Item_List, predicate: predicate, dictData: objDict, context: context,completion: completion)
    }
    internal static func setFavouriteItems(favaouriteItemIds: [String], context: NSManagedObjectContext,completion: ((Bool)->Void)?) {
        let myGroup = DispatchGroup()
        _ = favaouriteItemIds.map({ id in
            myGroup.enter()
            updateFavouriteItem(isFavourite: true, itemId: id, context: _coreDataShared.getContext()) { Result in
                myGroup.leave()
            }
        })
        myGroup.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            completion?(true)
        })
    }
    internal static func updateFavouriteItem(isFavourite: Bool,itemId:String, context: NSManagedObjectContext,completion: ((Bool)->Void)?) {
        let dictData = ["is_favourite":isFavourite]
        let predicate = NSPredicate(format: "key_id == %@", itemId)
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Menu_Item_List, predicate: predicate, dictData: dictData, context: context,completion: completion)
    }
    
    internal static func updateToSetDisableItemsItems(isDisable: Bool,itemId:String, context: NSManagedObjectContext,completion: ((Bool)->Void)?) {
        let dictData = ["is_disable":isDisable]
        let predicate = NSPredicate(format: "key_id == %@", itemId)
        CoreDataManager.sharedInstance.batchUpdateData(entity: .Tbl_Menu_Item_List, predicate: predicate, dictData: dictData, context: context,completion: completion)
    }

    internal static func getNotAvailableItemsOnCurrentMenu(arrIds: [String], in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        let p1 = NSPredicate(format: "key_id IN %@", arrIds)
        let p2 = NSPredicate(format: "current_menu_item_entity_type == %@ OR is_hidden == %@ OR is_disable == %@", EnumCurreentMenuItemType.notCurrentMenuItem.rawValue,NSNumber(value: true),NSNumber(value: true))
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [p1, p2])
        //Sorting
//        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "contact_id", ascending: true)
//        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    internal static func getRecords(arrTpnIds: [Int64], in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        let p1 = NSPredicate(format: "tpn IN %@", arrTpnIds)
        let p2 = NSPredicate(format: "loyalty_tpn IN %@", arrTpnIds)
        fetchRequest.predicate = NSCompoundPredicate(type: .or, subpredicates: [p1, p2])
        //Sorting
//        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "contact_id", ascending: true)
//        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    internal static func getRecords(arrIds: [String], in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key_id IN %@", arrIds)
        //Sorting
//        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "contact_id", ascending: true)
//        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    
    internal static func getRecords(id: String, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key_id == %@", id)
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
    internal static func getFilterRecordsWhichIsRootTrueNotHiddenNotDisble(filterID: [String],isRootDisplay:Bool,isIgnoreRootDisaply : Bool = false, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        
        if isIgnoreRootDisaply {
            let predicates = filterID.map {
                NSPredicate(format: "(filters CONTAINS %@) AND is_hidden == %@ AND is_disable == %@", $0, NSNumber(value: false),NSNumber(value: false))
            }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
        else{
            let predicates = filterID.map {
                NSPredicate(format: "(filters CONTAINS %@) AND (is_root_display == %@) AND is_hidden == %@ AND is_disable == %@", $0,NSNumber(value: isRootDisplay), NSNumber(value: false),NSNumber(value: false))
            }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
        do {
            let result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                print(result.count)
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    internal static func getFilterRecordsWhichIsRoot(filterID: [String],isRootDisplay:Bool,isIgnoreRootDisaply : Bool = false, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        if isIgnoreRootDisaply {
            let predicates = filterID.map {
                NSPredicate(format: "(filters CONTAINS %@)", $0)
            }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
        else{
            let predicates = filterID.map {
                NSPredicate(format: "(filters CONTAINS %@) AND (is_root_display == %@)", $0,NSNumber(value: isRootDisplay))
            }
            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
        do {
            var result = try context.fetch(fetchRequest)
            if (result.count > 0) {
                print(result.count)
                result = result.uniqued()
                print(result)
                return result.map({$0.toData()})
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return nil
    }
    internal static func getMealRecordsWhichIsRootTrue(mealId: String,isRootDisplay:Bool,isIgnoreRootDisaply : Bool = false, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        if isIgnoreRootDisaply {
            fetchRequest.predicate = NSPredicate(format: "(meals CONTAINS %@) AND is_hidden == %@", mealId, NSNumber(value: false))
        }
        else{
            fetchRequest.predicate = NSPredicate(format: "(meals CONTAINS %@) AND (is_root_display == %@) AND is_hidden == %@", mealId,NSNumber(value: isRootDisplay), NSNumber(value: false))
        }
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
    internal static func getRecordsWhichIsRootTrue(ids: [String],isRootDisplay:Bool,isIgnoreRootDisaply : Bool = false, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        if isIgnoreRootDisaply {
            fetchRequest.predicate = NSPredicate(format: "(key_id in %@) AND is_hidden == %@", ids, NSNumber(value: false))
        }
        else{
            fetchRequest.predicate = NSPredicate(format: "(key_id in %@) AND (is_root_display == %@) AND is_hidden == %@", ids,NSNumber(value: isRootDisplay), NSNumber(value: false))
        }
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

    internal static func getSearchTextRecordsWhichIsRootTrue(searchText: String,isRootDisplay:Bool, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        let p3 = NSPredicate(format: "(name CONTAINS[cd] %@) OR (title CONTAINS[cd] %@)", searchText,searchText,searchText)
        let p2 = NSPredicate(format: "(is_root_display == %@) AND (is_hidden == %@) AND (current_menu_item_entity_type != %@)",NSNumber(value: isRootDisplay), NSNumber(value: false),EnumCurreentMenuItemType.notCurrentMenuItem.rawValue)
        
        let p = NSCompoundPredicate(andPredicateWithSubpredicates: [p3,p2])
        fetchRequest.predicate = p
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
    internal static func getSearchTextCategory(searchText: String,isRootDisplay:Bool, in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        let p3 = NSPredicate(format: "(current_menu_item_identification_name CONTAINS[cd] %@)", searchText,searchText,searchText)
        let p2 = NSPredicate(format: "(is_root_display == %@) AND (is_hidden == %@) AND (current_menu_item_entity_type != %@)",NSNumber(value: isRootDisplay), NSNumber(value: false),EnumCurreentMenuItemType.notCurrentMenuItem.rawValue)
        
        let p = NSCompoundPredicate(andPredicateWithSubpredicates: [p3,p2])
        fetchRequest.predicate = p

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


    internal static func getAllRecordsWhichIsRootTrue(in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_root_display == 1")
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
    internal static func getAllFavouriteItems(in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_favourite == 1")
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
    
    internal static func getRecordsWhichIsRootTrueForSingle(ids: String,isRootDisplay:Bool, isIgnoreRootDisaply : Bool = false,  iscomingFromMealBundle : Bool = false, in context:NSManagedObjectContext) -> [ItemListData]? {
            let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
            if isIgnoreRootDisaply {
                fetchRequest.predicate = NSPredicate(format: "(key_id == %@)  AND is_hidden == %@", ids, NSNumber(value: false))
              //  fetchRequest.predicate = NSPredicate(format: "(key_id == %@)  AND is_hidden == %@ AND current_menu_item_entity_type != %@", ids, NSNumber(value: false), EnumCurreentMenuItemType.notCurrentMenuItem.rawValue)
            }
            else{
                  //  fetchRequest.predicate = NSPredicate(format: "(key_id == %@) AND (is_root_display == %@) AND is_hidden == %@ AND current_menu_item_entity_type != %@", ids, NSNumber(value: isRootDisplay), NSNumber(value: false), EnumCurreentMenuItemType.notCurrentMenuItem.rawValue)
                fetchRequest.predicate = NSPredicate(format: "(key_id == %@) AND (is_root_display == %@) AND is_hidden == %@", ids,NSNumber(value: isRootDisplay), NSNumber(value: false))
            }
            
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

    internal static func getAllRecords(in context:NSManagedObjectContext) -> [ItemListData]? {
        let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
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

    internal static func getRecordsWhichIsNotHiddenNotDisble(ids: [String], in context:NSManagedObjectContext) -> [ItemListData]? {
            let fetchRequest : NSFetchRequest<Tbl_Menu_Item_List>  = self.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "(key_id IN %@) AND is_hidden == %@ AND is_disable == %@", ids, NSNumber(value: false), NSNumber(value: false))
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
}
