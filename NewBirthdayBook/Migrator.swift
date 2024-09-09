//
//  Migrator.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/14.
//

import Foundation
import RealmSwift

class Migrator {
    
    init() {
        updateSchema()
    }
    
    func updateSchema() {
        
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1{
                migration.enumerateObjects(ofType: PersonList.className()) { _, newObject in
                    newObject!["day"] = 1
                }
            }
            
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        
    }
    
}


/*
 <key>CFBundleIcons</key>
 <dict>
     <key>CFBundlePrimaryIcon</key>
     <dict>
         <key>CFBundleIconFiles</key>
         <array>
             <string>AppIcon</string>
         </array>
         <key>UIPrerenderedIcon</key>
         <false/>
     </dict>
     <key>CFBundleAlternateIcons</key>
     <dict>
         <key>blackCircle</key>
         <dict>
             <key>CFBundleIconFiles</key>
             <array>
                 <string>blackCircle</string>
             </array>
             <key>UIPrerenderedIcon</key>
             <false/>
         </dict>
     </dict>
 </dict>
 */
