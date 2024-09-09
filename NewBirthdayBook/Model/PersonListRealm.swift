//
//  PersonListRealm.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/09.
//

import Foundation
import RealmSwift

class PersonList: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var birthday: Date
    @Persisted var category: String
    @Persisted var notificationExist: Bool
    @Persisted var memo: String
    @Persisted var day: Int
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
