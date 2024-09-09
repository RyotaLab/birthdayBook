//
//  MakeCategoryView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/10.
//

import SwiftUI

struct MakeCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var categoryList: [String]
    
    @FocusState private var focusedField: Field?
    @State var inputCategoryName:String = ""
    @State var displayText:String = ""
    @State var doubleflag:Bool = false
    
    //@Binding var selectedCategory: String
    
    var body: some View {
        VStack(spacing:30){
            Text("カテゴリー名")
                .foregroundColor(Color.button)
                .fontWeight(.bold)
                .overlay(
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 100, height: 1)
                    , alignment: .bottom
                )
                .padding(.bottom)
            
            TextField("3文字以下がおすすめ", text: $inputCategoryName)
                .focused($focusedField, equals: .category)
                .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                        .stroke(Color.gray, lineWidth: 1.5)
                        .padding(-8.0)
                )
                .padding(.horizontal, 100)
            
            
            Button{
                if !(inputCategoryName == "") {
                    if categoryList.isEmpty{
                        //カテゴリーに追加＆UserDefaultに保存&初期化
                        categoryList.append(inputCategoryName)
                        UserDefaults.standard.set(categoryList, forKey: "tagList")
                        inputCategoryName = ""
                        dismiss()
                    }else{
                        //同じ名前チェック
                        for name in categoryList {
                            if name == inputCategoryName{
                                doubleflag = true
                                displayText = "既に存在します"
                            }
                        }
                        if !doubleflag {
                            categoryList.append(inputCategoryName)
                            UserDefaults.standard.set(categoryList, forKey: "tagList")
                            inputCategoryName = ""
                            dismiss()
                        }
                    }
                }
                //カテゴリーに追加＆UserDefaultに保存&初期化
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
                    .padding(.vertical, 50)
            }
            
            
            Text(displayText)
                .foregroundStyle(Color.pink)
            
        }
    }
}

//#Preview {
//    MakeCategoryView()
//}
