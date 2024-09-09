/*
 datepicker、通知の内容の変更（プレミアム）
 */

import SwiftUI
import RealmSwift
import UserNotifications

struct SetNotificationView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var notificationModel: NotificationModel
    let NotifyManager = NotificationManagement()
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //googleAds
    @EnvironmentObject var interstitial: AdmobInterstitialManager
    
    @State private var NowTime:Date = Date()
    
    @State private var isShowAlert: Bool = false
    @State private var saveAlert:Bool = false
    @State var isPresentedProgressView = false
    
    @State private var selected = 0
    
    
    var body: some View {
        ZStack{
            if isPresentedProgressView {
                ProgressView("通知設定中")
            }
            Color.background
            VStack{
                //通知の時刻設定　environment(日時のみ
                Text("通知の時刻")
                    .foregroundColor(Color.button)
                    .fontWeight(.bold)
                    .overlay(
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 80, height: 1)
                        , alignment: .bottom
                    )
                
                DatePicker("Date",
                           selection: $notificationModel.notifyTime,
                           displayedComponents: [.hourAndMinute]
                ).labelsHidden()
                    .datePickerStyle(.wheel)
                //前日or当日（toggle、falseは当日
                Text("通知の日")
                    .foregroundColor(Color.button)
                    .fontWeight(.bold)
                    .overlay(
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 80, height: 1)
                        , alignment: .bottom
                    )
                
                Toggle(isOn: $notificationModel.setToggle) {
                    Text(notificationModel.setToggle ? "当日" : "前日")
                }.padding()
                    .tint(notificationModel.setToggle ? .orange : .green)
                    .toggleStyle(.button)
                
                Button{
                    //更新されていた場合
                    if isUpdated(){
                        update()
                        NotificationUpdate()
                    }
                    
                    saveAlert = true
                }label:{
                    Text("保存する")
                        .fontWeight(.bold)
                        .frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(.orange)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.orange, lineWidth: 1.0)
                        )
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                        .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle("通知設定")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    if isUpdated() {
                        isShowAlert = true
                    }else{
                        //更新なし
                        dismiss()
                        tabFlag = .visible
                    }
                }label:{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(Color.button)
                    
                }
            }
            
            //右
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    //更新されていた場合
                    if isUpdated(){
                        update()
                        NotificationUpdate()
                        print("update")
                    }
                    
                    saveAlert = true
                }label:{
                    Text("保存")
                        .fontWeight(.bold)
                }
            }
        }
        .toolbar(tabFlag, for: .tabBar)
        .alert("確認", isPresented: $isShowAlert){
            Button("戻る", role: .cancel){
            }
            Button("無視", role: .destructive){
                
                //編集せずに戻る
                dismiss()
                tabFlag = .visible
            }
        }message:{
            Text("更新データは保存されていません")
        }
        //保存アラート
        .alert("保存されました", isPresented: $saveAlert){
            //インターステシャル広告処理
            Button("OK", role: .cancel){
                
                if purchaseManager.perchased {
                    //購入済み
                }else{
                    interstitial.AdsOpenCount = interstitial.AdsOpenCount + 1
                    if interstitial.AdsOpenCount % 3 == 0{
                        interstitial.presentInterstitial()
                    }
                }
                
            }
        }message: {
        }
    }
    
    
    //すべての更新処理
    func update() {
        print("update")
        UserDefaults.standard.set(notificationModel.notifyTime, forKey: "notifyTime")
        //setToggleがfalseなら前日通知
        UserDefaults.standard.set(notificationModel.setToggle, forKey: "notifyToday")
    }
    
    //通知の総入れ替え
    func NotificationUpdate(){
        //インジケーター表示
        isPresentedProgressView = true
        do{
            //通知ONのにとをPersonTableTrueで取得
            let realm = try Realm()
            let PersonTableTrue = realm.objects(PersonList.self).where({
                $0.notificationExist == true
            })
            //通知している人数を把握
            let count = PersonTableTrue.count
            print(count)
            
            if !(count == 0) {
                //新しい通知を作るために、一旦通知を全削除
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
                
                //新しい通知を作成していく
                for i in 0..<count {
                    NotifyManager.makeNotification(PersonList: PersonTableTrue[i])
                }
                
            }
            
        }catch{
            print(error)
        }
        //インジケーター非表示
        isPresentedProgressView = false
    }
    
    
    //更新されたかチェック
    func isUpdated() -> Bool{
        //過去の時間一致確認の準備
        let beforeTime = UserDefaults.standard.object(forKey: "notifyTime") as? Date ?? self.StringToDate(dateValue: "2020-01-01 06:00:00", format: "yyyy/MM/dd HH:mm:ss")
        let beforeTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: beforeTime)
        let nowComponent = Calendar.current.dateComponents([.hour, .minute], from: notificationModel.notifyTime)
        //今日or昨日が変更されていないか
        let beforeSetToggle: Bool = UserDefaults.standard.object(forKey: "notifyToday") as? Bool ?? true
        
        //Calendar.current.dateComponents([.hour, .minute], from: NotificationTime)
        if beforeTimeComponent == nowComponent {
            if beforeSetToggle == notificationModel.setToggle {
                //全部一致してたらisUpdate = false
                return false
            }
        }
        return true
    }
    
    //isUpdatedで使用
    func StringToDate(dateValue: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateValue) ?? Date()
    }
}

//#Preview {
//    SetNotificationView()
//}
