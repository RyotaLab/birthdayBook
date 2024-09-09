//
//  EditCategoryView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/10.
//

import SwiftUI

struct EditCategoryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    @State var tabFlag: Visibility = .hidden
    
    @EnvironmentObject var categorySet: CategorySet
    
    @State var isSheet: Bool = false
    
    var body: some View {
        ZStack{
            Color.background
            VStack{
                HStack{
                    
                    Button{
                        //カテゴリ追加
                        isSheet = true
                    }label:{
                        Text("\(Image(systemName: "plus"))追加")
                            .frame(width: 80, height: 45, alignment: .center)
                            .foregroundColor(Color.orange)
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(Color.orange, lineWidth: 1.0)
                            )
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 7))
                            .padding([.top, .horizontal])
                        
                    }
                    
                    Button{
                        //リスト編集
                        if editMode?.wrappedValue == .active {
                            editMode?.wrappedValue = .inactive
                        } else {
                            editMode?.wrappedValue = .active
                        }
                    }label:{
                        Text("\(Image(systemName: "scissors"))編集")
                            .frame(width: 80, height: 45, alignment: .center)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(Color.red, lineWidth: 1.0)
                            )
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 7))
                            .padding([.top, .horizontal])
                        
                    }
                }
                
                List{
                    Section{
                        ForEach(categorySet.categoryList, id: \.self) { category in
                            HStack{
                                Text(category)
                                    .frame(height: 37)
                                    .foregroundColor(Color.button)
                            }
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: moveItem)
                    }
                }
            }
        }
        .sheet(isPresented: $isSheet) {
            MakeCategoryView(categoryList: $categorySet.categoryList)
        }
        .navigationTitle("優先度が高いのは上へ")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    //戻るボタン
                    UserDefaults.standard.set(categorySet.categoryList, forKey: "tagList")
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
    
    func delete(offsets: IndexSet) {
        categorySet.categoryList.remove(atOffsets: offsets)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        categorySet.categoryList.move(fromOffsets: source, toOffset: destination)
        
//        categorySet.moveItems(from: source, to: destination)
//        UserDefaults.standard.set(categorySet.categoryList, forKey: "tagList")
    }
    
}

//#Preview {
//    EditCategoryView()
//}
