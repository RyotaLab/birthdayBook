//
//  CategorySet.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/10.
//

import Foundation

class CategorySet: ObservableObject {
    
    @Published var categoryList: [String] = UserDefaults.standard.array(forKey: "tagList") as? [String] ?? []

}


