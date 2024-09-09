//
//  DateCalculation.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/14.
//

import Foundation

class DateCalculation {
    
    let calendar = Calendar.current
    //personListを取得、残り日数を返す関数（閏年を考えとこう）
    func restDay(PersonList: PersonList) -> String {
        let now = Date()
        //両方の月＋日を取得し、どっちが大きいか比較する
        let nowDay = DateToDay(date: now)
        let nowMonth = DateToMonth(date: now)
        let nowYear = DateToYear(date: now)
        
        let Day = PersonList.day
        let Month = DateToMonth(date: PersonList.birthday)
        
        //来年ならtrue
        var NextYear :Bool = false
        var NextBirthDay :Date = Date()
        var isBirthDay :Bool = false
        
        if nowMonth > Month{
            
            NextYear = true
        }else if nowMonth < Month{
            //今４月　、　誕生日が６月 ->　今年のまま
            //NextYear = false
        }else{
            //両方４月
            if nowDay > Day {
                //今5日　誕生日４日 =>　来年
                
                NextYear = true
            }else if nowDay < Day{
                
                //NextYear = false
            }else{
                //誕生日
                isBirthDay = true
            }
        }
        
        //誕生日ならもう出る
        if isBirthDay {
            return "-1"
        }
        
        //閏年はどうするか。NextYearがtrue -> +1して4で割れたら2/29　違かったら2/28
        if NextYear{
            if ((nowYear + 1) % 4) == 0 {
                //閏年、来年の誕生日
                NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear+1, month: Month, day: Day).date ?? Date()

            }else{
                //not閏年
                if (Month == 2) && (Day == 29) {
                    //閏日が誕生日の場合&来年の誕生日
                    NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear+1, month: 2, day: 28).date ?? Date()
                    
                }else{
                    //来年の誕生日
                    NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear+1, month: Month, day: Day).date ?? Date()
                }
                
                
            }
        }else{
            if (nowYear % 4) == 0 {
                //閏年、今年の誕生日
                NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear, month: Month, day: Day).date ?? Date()
                
            }else{
                //not閏年
                if (Month == 2) && (Day == 29) {
                    //閏日が誕生日の場合
                    NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear, month: 2, day: 28).date ?? Date()
                }else{
                    //今年の誕生日
                    NextBirthDay = DateComponents(calendar: Calendar.current, year: nowYear, month: Month, day: Day).date ?? Date()
                }
            }
        }
        
        let rest = calendar.dateComponents([.day], from: now, to: NextBirthDay)
        return String((rest.day ?? 0) + 1)
        
    }
    
    //Dateを取得、年を返す
    func DateToYear(date: Date) -> Int {
        let year = calendar.component(.year, from: date) // 日付の部分を取得します
        return year
    }
    
    //Dateを取得、月を返す
    func DateToMonth(date: Date) -> Int {
        let month = calendar.component(.month, from: date) // 日付の部分を取得します
        return month
    }
    
    //Dateを取得、日付を返す
    func DateToDay(date: Date) -> Int {
        let day = calendar.component(.day, from: date) // 日付の部分を取得します
        return day
    }
    
}


