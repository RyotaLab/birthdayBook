//
//  IconChange.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/18.
//

import Foundation

class IconChange: ObservableObject {
    
    //もしも初期アイコン以外を選択してたら変更する
    @Published var selectedIcon: String? = UserDefaults.standard.object(forKey: "selectedIcon") as? String
    
}
