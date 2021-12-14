//
//  ToDoListItems+CoreDataProperties.swift
//  ToDoList22
//
//  Created by Ayub Ali on 14/12/2021.
//
//

import Foundation
import CoreData


extension ToDoListItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItems> {
        return NSFetchRequest<ToDoListItems>(entityName: "ToDoListItems")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItems : Identifiable {

}
