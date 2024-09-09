//
//  NotificationModel.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/12.
//

import Foundation

class NotificationModel: ObservableObject {
    
    //日時だけ正確ならOK、初期値はtrue
    @Published var notifyTime: Date = Date()
    @Published var setToggle: Bool = UserDefaults.standard.object(forKey: "notifyToday") as? Bool ?? true
    
    init() {
        self.notifyTime = UserDefaults.standard.object(forKey: "notifyTime") as? Date ?? self.StringToDate(dateValue: "2020-01-01 06:00:00", format: "yyyy/MM/dd HH:mm:ss")
    }
    
    func StringToDate(dateValue: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateValue) ?? Date()
    }
    
}
