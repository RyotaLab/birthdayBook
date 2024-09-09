//
//  TwoPageView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/09.
//

import SwiftUI
import RealmSwift

struct TwoPageView: View {
    @State var selectedCategory: String = ""
    
    //@ObservedResults(PersonList.self) var personLists
    @ObservedResults(PersonList.self, sortDescriptor: SortDescriptor(keyPath: "day", ascending: true)) var personLists
    
    @State var viewCount: Int = 0
    
    //通知
    let NotifyManager = NotificationManagement()
    
    //計算
    let c = DateCalculation()
    
    let nowDate = Date()
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background
                VStack{
                    
                    CategoryListView(selectedCategory: $selectedCategory, accessedByTwoPage: true)
                        .padding()
                        .background(Color.background)
                        .padding(.top)
                    
                    if personLists.isEmpty {
                        Text("登録がありません")
                            .foregroundColor(Color.button)
                    }
                    
                    
                    
                    //PersonのList
                    List{
                        
                        //4月〜12月
                        ForEach(c.DateToMonth(date: Date())..<13, id: \.self){i in
                            ForEach(personLists, id: \.id) { personList in
                                //一致しているとき
                                if c.DateToMonth(date: personList.birthday) == i {
                                    if c.DateToMonth(date: Date()) == i{//今月
                                        if Int(c.restDay(PersonList: personList))! < 50 {//50日以下に限定
                                            
                                            
                                            if selectedCategory == ""{
                                                NavigationLink{
                                                    PersonCellView(personList: personList)
                                                }label:{
                                                    HStack{
                                                        Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                            .foregroundColor(Color.gray)
                                                            .fontWeight(.bold)
                                                            .overlay(
                                                                Rectangle()
                                                                    .fill(Color.orange)
                                                                    .frame(width: 35, height: 1)
                                                                , alignment: .bottom
                                                            )
                                                            .frame(width: 50, height: 50)
                                                        Text("： \(personList.name)")
                                                            .foregroundColor(Color.button)
                                                        
                                                        Spacer()
                                                        
                                                        if c.restDay(PersonList: personList) == "-1" {
                                                            Text("誕生日🎉")
                                                                .foregroundColor(Color.green)
                                                                .fontWeight(.bold)
                                                        }else{
                                                            Text("あと\(c.restDay(PersonList: personList))日")
                                                                .foregroundColor(Color.button)
                                                        }
                                                    }
                                                }
                                            }else{
                                                //カテゴリ選択あり
                                                if personList.category == selectedCategory{
                                                    NavigationLink{
                                                        PersonCellView(personList: personList)
                                                    }label:{
                                                        HStack{
                                                            Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                                .foregroundColor(Color.gray)
                                                                .fontWeight(.bold)
                                                                .overlay(
                                                                    Rectangle()
                                                                        .fill(Color.orange)
                                                                        .frame(width: 35, height: 1)
                                                                    , alignment: .bottom
                                                                )
                                                                .frame(width: 50, height: 50)
                                                            Text("： \(personList.name)")
                                                                .foregroundColor(Color.button)
                                                            
                                                            Spacer()
                                                            
                                                            if c.restDay(PersonList: personList) == "-1" {
                                                                Text("誕生日🎉")
                                                                    .foregroundColor(Color.green)
                                                                    .fontWeight(.bold)
                                                            }else{
                                                                Text("あと\(c.restDay(PersonList: personList))日")
                                                                    .foregroundColor(Color.button)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                    }else{//今月以外
                                        
                                        
                                        if selectedCategory == ""{
                                            NavigationLink{
                                                PersonCellView(personList: personList)
                                            }label:{
                                                HStack{
                                                    Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                        .foregroundColor(Color.gray)
                                                        .fontWeight(.bold)
                                                        .overlay(
                                                            Rectangle()
                                                                .fill(Color.orange)
                                                                .frame(width: 35, height: 1)
                                                            , alignment: .bottom
                                                        )
                                                        .frame(width: 50, height: 50)
                                                    Text("： \(personList.name)")
                                                        .foregroundColor(Color.button)
                                                    
                                                    Spacer()
                                                    
                                                    Text("あと\(c.restDay(PersonList: personList))日")
                                                        .foregroundColor(Color.button)
                                                }
                                            }
                                        }else{
                                            //カテゴリ選択あり
                                            if personList.category == selectedCategory{
                                                NavigationLink{
                                                    PersonCellView(personList: personList)
                                                }label:{
                                                    HStack{
                                                        Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                            .foregroundColor(Color.gray)
                                                            .fontWeight(.bold)
                                                            .overlay(
                                                                Rectangle()
                                                                    .fill(Color.orange)
                                                                    .frame(width: 35, height: 1)
                                                                , alignment: .bottom
                                                            )
                                                            .frame(width: 50, height: 50)
                                                        Text("： \(personList.name)")
                                                            .foregroundColor(Color.button)
                                                        
                                                        Spacer()
                                                        
                                                        Text("あと\(c.restDay(PersonList: personList))日")
                                                            .foregroundColor(Color.button)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }//月が一致
                            }//personLists
                        }.onDelete(perform: delete)
                    
                        
                        //1月〜4月
                        ForEach(1..<c.DateToMonth(date: Date())+1, id:\.self){i in
                            ForEach(personLists, id: \.id) { personList in
                                //一致しているとき
                                if c.DateToMonth(date: personList.birthday) == i {
                                    if c.DateToMonth(date: Date()) == i{//今月
                                        if Int(c.restDay(PersonList: personList))! > 50 {//50日以下に限定ならOK
                                            
                                            
                                            if selectedCategory == ""{
                                                NavigationLink{
                                                    PersonCellView(personList: personList)
                                                }label:{
                                                    HStack{
                                                        Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                            .foregroundColor(Color.gray)
                                                            .fontWeight(.bold)
                                                            .overlay(
                                                                Rectangle()
                                                                    .fill(Color.orange)
                                                                    .frame(width: 35, height: 1)
                                                                , alignment: .bottom
                                                            )
                                                            .frame(width: 50, height: 50)
                                                        Text("： \(personList.name)")
                                                            .foregroundColor(Color.button)
                                                        
                                                        Spacer()
                                                        
                                                        Text("あと\(c.restDay(PersonList: personList))日")
                                                            .foregroundColor(Color.button)
                                                    }
                                                }
                                            }else{
                                                //カテゴリ選択あり
                                                if personList.category == selectedCategory{
                                                    NavigationLink{
                                                        PersonCellView(personList: personList)
                                                    }label:{
                                                        HStack{
                                                            Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                                .foregroundColor(Color.gray)
                                                                .fontWeight(.bold)
                                                                .overlay(
                                                                    Rectangle()
                                                                        .fill(Color.orange)
                                                                        .frame(width: 35, height: 1)
                                                                    , alignment: .bottom
                                                                )
                                                                .frame(width: 50, height: 50)
                                                            Text("： \(personList.name)")
                                                                .foregroundColor(Color.button)
                                                            
                                                            Spacer()
                                                            
                                                            Text("あと\(c.restDay(PersonList: personList))日")
                                                                .foregroundColor(Color.button)
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                    }else{//今月以外
                                        
                                        
                                        if selectedCategory == ""{
                                            NavigationLink{
                                                PersonCellView(personList: personList)
                                            }label:{
                                                HStack{
                                                    Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                        .foregroundColor(Color.gray)
                                                        .fontWeight(.bold)
                                                        .overlay(
                                                            Rectangle()
                                                                .fill(Color.orange)
                                                                .frame(width: 35, height: 1)
                                                            , alignment: .bottom
                                                        )
                                                        .frame(width: 50, height: 50)
                                                    Text("： \(personList.name)")
                                                        .foregroundColor(Color.button)
                                                    
                                                    Spacer()
                                                    
                                                    Text("あと\(c.restDay(PersonList: personList))日")
                                                        .foregroundColor(Color.button)
                                                }
                                            }
                                        }else{
                                            //カテゴリ選択あり
                                            if personList.category == selectedCategory{
                                                NavigationLink{
                                                    PersonCellView(personList: personList)
                                                }label:{
                                                    HStack{
                                                        Text("\(c.DateToMonth(date: personList.birthday))/\(c.DateToDay(date: personList.birthday))")
                                                            .foregroundColor(Color.gray)
                                                            .fontWeight(.bold)
                                                            .overlay(
                                                                Rectangle()
                                                                    .fill(Color.orange)
                                                                    .frame(width: 35, height: 1)
                                                                , alignment: .bottom
                                                            )
                                                            .frame(width: 50, height: 50)
                                                        Text("： \(personList.name)")
                                                            .foregroundColor(Color.button)
                                                        
                                                        Spacer()
                                                        
                                                        Text("あと\(c.restDay(PersonList: personList))日")
                                                            .foregroundColor(Color.button)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }//月が一致
                            }//personLists
                        }.onDelete(perform: delete)
                    }//List
                    .onChange(of: selectedCategory){
                        viewCount = 0
                    }
                    .scrollContentBackground(.hidden)
                }//ZStack
                .navigationBarTitle("リスト", displayMode: .inline)
            }//navigationStack
        }
    }
    
    func delete(offsets: IndexSet) {
        
        offsets.forEach { index in
            NotifyManager.removeNotification(PersonList: personLists[index])
        }
        
        $personLists.remove(atOffsets: offsets)
    }
    
}

//#Preview {
//    TwoPageView()
//}

/*
 やりたいこと
 
 ・カテゴリが選択されたときにListの中身を変更
 ・OnDeleteに対応
 
 
 ForEach(personLists, id: \.id) { personList in
     if selectedCategory == ""{
         //同じ月
         if dateCalculation.DateToMonth(date: personList.birthday) == i {
             if Int(dateCalculation.restDay(PersonList: personList))! < 50 {
                 NavigationLink{
                     PersonCellView(personList: personList)
                 }label:{
                     HStack{
                         Text(dateCalculation.restDay(PersonList: personList))
                         Text(personList.name)
                     }
                 }
             }
         }
     }else{
         if dateCalculation.DateToMonth(date: personList.birthday) == i {
             if Int(dateCalculation.restDay(PersonList: personList))! < 50 {
                 NavigationLink{
                     PersonCellView(personList: personList)
                 }label:{
                     HStack{
                         Text(dateCalculation.restDay(PersonList: personList))
                         Text(personList.name)
                     }
                 }
             }
         }
     }
 }.onDelete(perform: delete) // ForEach
 
 
 ForEach(personLists, id: \.id) { personList in
     if selectedCategory == ""{
         //全表示
         NavigationLink{
             PersonCellView(personList: personList)
         }label:{
             HStack{
                 Text(dateCalculation.restDay(PersonList: personList))
                 Text(personList.name)
             }
         }
     }else{
         //もしEmptyなら変える
         if personList.category == selectedCategory{
             NavigationLink{
                 PersonCellView(personList: personList)
             }label:{
                 HStack{
                     Text(dateCalculation.restDay(PersonList: personList))
                     Text(personList.name)
                 }
             }
         }
     }
 }.onDelete(perform: delete) // ForEach
 
 
 */


