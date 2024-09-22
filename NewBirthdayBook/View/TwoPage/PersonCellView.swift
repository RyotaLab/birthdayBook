//
//  PersonCellView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/11.
//

import SwiftUI
import RealmSwift

struct PersonCellView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    //Realm
    @ObservedRealmObject var personList: PersonList
    
    //googleAds
    @EnvironmentObject var interstitial: AdmobInterstitialManager
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //通知
    let NotifyManager = NotificationManagement()
    
    //計算
    let dateCalculation = DateCalculation()
    
    //personの登録情報
    @State var inputName: String = ""
    @State var birthDay: Date = Date()
    @State var selectedCategory: String = ""
    @State var notifyBool: Bool = false
    @State var inputMemo: String = ""
    
    @FocusState private var focusedField: Field?
    
    @State var caution: String = ""
    @State var isShowAlert: Bool = false
    @State var saveAlert:Bool = false
    @State var beforeNotification = false
    
    init(personList: PersonList){
        self.personList = personList
        
        _inputName = State.init(initialValue: personList.name)
        _birthDay = State.init(initialValue: personList.birthday)
        _selectedCategory = State.init(initialValue: personList.category)
        _notifyBool = State.init(initialValue: personList.notificationExist)
        _inputMemo = State.init(initialValue: personList.memo)
        
        UIDatePicker.appearance().tintColor = .orange
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            Color.background
                .onAppear() { interstitial.loadInterstitial()}
            ScrollView(showsIndicators: false) {
                
                ZStack{
                    Color.background
                        .onTapGesture {
                            focusedField = nil
                            print("onTap")
                        }
                    
                    VStack(spacing:30){
                        
                        Text("名前")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        TextField("名前を入力してください", text: $inputName)
                            .focused($focusedField, equals: .name1)
                            .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                    .stroke(Color.gray, lineWidth: 1.5)
                                    .padding(-8.0)
                            )
                            .padding(8.0)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 40)
                        
                            
                        
                        Text("誕生日")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        
                        DatePicker("", selection: $birthDay, in: ...Date(), displayedComponents: .date)
                            //.datePickerStyle(CompactDatePickerStyle())
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                        
                        
                        
                        Text("カテゴリー")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        //CategoryView
                        CategoryListView(selectedCategory: $selectedCategory, accessedByTwoPage: false)
                            .padding()
                            .background(Color.background)
                        
                        Text("Memo")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        
                        TextEditor(text: $inputMemo)
                            .focused($focusedField, equals: .memo1)
                            .frame(width:300, height: 300)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1.5))
                            .overlay(alignment: .topLeading) {
                                if inputMemo.isEmpty {
                                    Text("Memo")
                                        .allowsHitTesting(false) // タップ判定を無効化
                                        .foregroundColor(Color(uiColor: .placeholderText))
                                        .padding(6)
                                }
                            }
                        
                        HStack{
                            Text("通知")
                                .foregroundColor(Color.button)
                                .fontWeight(.bold)
                            Text(notifyBool ? "ON" : "OFF")
                                .frame(width: 70, height: 50, alignment: .leading)
                                .foregroundColor(notifyBool ? .orange : .primary)
                            Toggle(isOn: $notifyBool) {}.padding()
                                .labelsHidden()
                                .tint(notifyBool ? .orange: .gray)
                                
                        }
                        
                        Text(caution)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.pink)
                        
                        //保存ボタン
                        Button{
                            if inputName == ""{
                                caution = "名前を入力してください"
                            }else{
                                //save処理
                                
                                update()
                                
                                saveAlert = true
                            }
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

                        
                    }//VStack1
                }//ZStack
            }//scroll
        }//ZStack
        .navigationBarTitle("更新する", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    if checkEdit(personList: personList) {
                        isShowAlert = true
                    }else{
                        //戻るボタン
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
                    //update
                    if inputName == ""{
                        caution = "名前を入力してください"
                    }else{
                        //save処理
                        update()
                        saveAlert = true
                    }
                    
                }label:{
                    Text("保存")
                        .fontWeight(.bold)
                }
            }
            
        }
        
        .toolbar(tabFlag, for: .tabBar)
        //編集アラート
        .alert("確認", isPresented: $isShowAlert){
            Button("戻る", role: .cancel){
            }
            Button("無視", role: .destructive){
                //編集せずに戻る
                dismiss()
                tabFlag = .visible
            }
        }message:{
            Text("編集データが保存されていません")
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
    
    //編集されているか確認
    func checkEdit(personList:PersonList) -> Bool{
        if personList.name == inputName{
            if personList.birthday == birthDay{
                if personList.category == selectedCategory{
                    if personList.notificationExist == notifyBool {
                        if personList.memo == inputMemo{
                            //全部同じ
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func update() {
        
        //通知の削除　true -> falseの時のみ
        if personList.notificationExist == true {
            if notifyBool == false{
                //通知が必要なくなった
                NotifyManager.removeNotification(PersonList: personList)
            }else{
                //通知を消す必要はない
                beforeNotification = true
            }
        }
        
        do{
            let realm = try Realm()
            guard let objectToUpdate = realm.object(ofType: PersonList.self, forPrimaryKey: personList.id) else {
                return
            }
            try realm.write{
                objectToUpdate.name = inputName
                objectToUpdate.birthday = birthDay
                objectToUpdate.category = selectedCategory
                objectToUpdate.notificationExist = notifyBool
                objectToUpdate.memo = inputMemo
                objectToUpdate.day = dateCalculation.DateToDay(date: birthDay)
            }
            
        }catch{
            print("updateErroeです")
        }
        
        if notifyBool {
            //通知が必要
            if beforeNotification {
                //過去に通知は作成されている　→ 削除　→ 更新
                NotifyManager.removeNotification(PersonList: personList)
                NotifyManager.makeNotification(PersonList: personList)
            }else{
                //過去に作成をしたことがない　→ 作成
                NotifyManager.makeNotification(PersonList: personList)
            }
        }
        
        
    }
    
}

//#Preview {
//    PersonCellView()
//}
