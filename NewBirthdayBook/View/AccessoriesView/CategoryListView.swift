//
//  CategoryListView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/10.
//

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject var categorySet: CategorySet
    
    @Binding var selectedCategory: String
    let accessedByTwoPage: Bool
    
    @State var isSheet: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing:10){
                Spacer()
                
                if accessedByTwoPage {
                    Text("All")
                        .frame(width: 70, height: 35, alignment: .center)
                        .foregroundColor(selectedCategory == "" ? .white: .orange)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 1.0)
                        )
                        .background(selectedCategory == "" ? .orange: .white, in: RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            if !(selectedCategory == ""){
                                selectedCategory = ""
                            }
                        }
                }
                
                if !categorySet.categoryList.isEmpty {
                    ForEach(categorySet.categoryList, id: \.self) { category in
                        Text(category)
                            .frame(width: 70, height: 35, alignment: .center)
                            .foregroundColor(selectedCategory == category ? .white: .orange)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 1.0)
                            )
                            .background(selectedCategory == category ? .orange: .white, in: RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if accessedByTwoPage {
                                    selectedCategory = category
                                }else{
                                    if selectedCategory == category{
                                        selectedCategory = ""
                                    }else{
                                        selectedCategory = category
                                    }
                                }
                            }
                    }
                }
                
                
                
                
                
                
                
                Button{
                    //カテゴリ追加
                    isSheet = true
                }label:{
                    Text("\(Image(systemName: "plus"))追加")
                        .frame(width: 65, height: 35, alignment: .center)
                        .foregroundColor(Color.button)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.button, lineWidth: 1.0)
                        )
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                    
                }
                Spacer()
            }//HStack
        }//Scrollview
        .sheet(isPresented: $isSheet) {
            MakeCategoryView(categoryList: $categorySet.categoryList)
        }
    }
}

//#Preview {
//    CategoryListView()
//}
