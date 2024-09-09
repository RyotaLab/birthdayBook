//
//  NotificationManager.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/12.

import Foundation
import UserNotifications

class NotificationManagement {
    
    //通知の作成（Realm全体と、その日の時間を設定）
    func makeNotification(PersonList: PersonList){
        //日時
        var notificationDate = PersonList.birthday
        
        //ここの時点で前日or当日を分ける必要あるな
        //isToggle=false(前日じゃない)なら日付のみ1日減らす必要がある
        let isToggle = UserDefaults.standard.bool(forKey: "notifyToday")
        if isToggle == false {
            notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: notificationDate)!
        }
        
        var BirthDay = Calendar.current.dateComponents([ .month, .day], from: notificationDate)
        let NotificationTime = UserDefaults.standard.object(forKey: "notifyTime") as? Date ?? self.StringToDate(dateValue: "2020-01-01 06:00:00", format: "yyyy/MM/dd HH:mm:ss")
        let Notificationtime = Calendar.current.dateComponents([.hour, .minute], from: NotificationTime)
        
        //時間だけは合わせる
        BirthDay.hour = Notificationtime.hour
        BirthDay.minute = Notificationtime.minute
        BirthDay.second = 0
        
        //トリガー（実際は１年ごと繰り返す）
        let trigger = UNCalendarNotificationTrigger(dateMatching: BirthDay, repeats: true)
        
        //通知内容（bodyはあとで変更）
        let content = UNMutableNotificationContent()
        content.title = "お知らせ"
        
        //前日　or　当日で分ける
        
        if isToggle == false {
            content.body = "\(PersonList.name)の誕生日の前日です！"
        }else{
            content.body = "\(PersonList.name)さんの誕生日です🎉"
        }
        content.sound = UNNotificationSound.default
        
        //リクエスト作成（idをあとで変更）
        let request = UNNotificationRequest(identifier: "\(PersonList.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知作成Error : \(error.localizedDescription)")
            }else {
                print(trigger)
                print("通知が作成されました")
            }
        }
    }//makeNotification
    
    //idはあとで変更
    func removeNotification(PersonList: PersonList) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(PersonList.id)"])
        print("通知を削除：\(PersonList.name)")
    }//removeNotification
    
    
    func StringToDate(dateValue: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateValue) ?? Date()
    }
}

//通知の権限リクエストに使うクラス
final class NotificationManager {
   static let instance: NotificationManager = NotificationManager()
    
   func requestPermission() {
       UNUserNotificationCenter.current()
           .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
               print("Permission granted: \(granted)")
           }
   }
}
