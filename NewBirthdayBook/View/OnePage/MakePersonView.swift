//
//  MakePersonView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/09.
//

import SwiftUI
import RealmSwift

struct MakePersonView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    //Realm
    @ObservedResults(PersonList.self) var personLists
    
    //googleAds
    @EnvironmentObject var interstitial: AdmobInterstitialManager
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //計算
    let dateCalculation = DateCalculation()
    
    //通知
    let NotifyManager = NotificationManagement()
    
    //personの登録情報
    @State var inputName: String = ""
    @State var birthDay: Date = Date()
    @State var selectedCategory: String = ""
    @State var notifyBool: Bool = true
    @State var inputMemo: String = ""
    
    @FocusState private var focusedField: Field?
    
    @State var caution: String = ""
    
    //Datepickerの色変え
    init(){
        UIDatePicker.appearance().tintColor = .orange
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            Color.background
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
                            .focused($focusedField, equals: .name)
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
                        CategoryListView(selectedCategory: $selectedCategory, isTwo: false)
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
                            .focused($focusedField, equals: .memo)
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
                        
                        Button{
                            
                            if inputName == ""{
                                caution = "名前を入力してください"
                            }else{
                                print("save")
                                //save処理
                                let personList = PersonList()
                                personList.name = inputName
                                personList.birthday = birthDay
                                personList.category = selectedCategory
                                personList.notificationExist = notifyBool
                                personList.memo = inputMemo
                                personList.day = dateCalculation.DateToDay(date: birthDay)
                                
                                $personLists.append(personList)
                                
                                //通知の作成
                                if notifyBool == true {
                                    NotifyManager.makeNotification(PersonList: personList)
                                }
                                
                                //dismiss
                                tabFlag = .visible
                                selectedCategory = ""
                                dismiss()
                                
                                //インターステシャル広告処理
                                //購入済みの時のみ表示
                                if purchaseManager.perchased {
                                    
                                }else{
                                    interstitial.AdsOpenCount = interstitial.AdsOpenCount + 1
                                    if interstitial.AdsOpenCount % 3 == 0{
                                        interstitial.presentInterstitial()
                                    }
                                }
                                
                                
                            }
                        }label:{
                            Text("登録する")
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
        .onAppear() { 
            print("a")
            interstitial.loadInterstitial()}
                          
        .navigationTitle("登録する")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    //戻るボタン
                    dismiss()
                    tabFlag = .visible
                    
                }label:{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(Color.button)
                    
                }
            }
        }
        .toolbar(tabFlag, for: .tabBar)
    }
}

//enum Field: Hashable {
//    case name
//    case memo
//    case category
//}

//#Preview {
//    MakePersonView()
//}
