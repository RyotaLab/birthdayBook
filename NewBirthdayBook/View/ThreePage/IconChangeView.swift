//
//  IconChangeView1.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/06/01.
//

import SwiftUI

struct IconChangeView1: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //@EnvironmentObject var iconChange: IconChange
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    //@State var isShowPremium: Bool = false
    
    var isPurchased: Bool
    
    let ImageNameList = ["AppIconImage11","AppIconImage12","AppIconImage5","AppIconImage6","AppIconImage4","AppIconImage9","AppIconImage10", "AppIconImage13","AppIconImage7","AppIconImage8"]
    
    let IconNameList = ["AppIcon 11","AppIcon 12","AppIcon 5","AppIcon 6","AppIcon 4","AppIcon 9","AppIcon 10","AppIcon 13","AppIcon 7","AppIcon 8"]
    
    let IconTextList = ["ロウソク1", "ロウソク2", "ショートケーキ", "チョコレートケーキ", "ホワイトサークル", "緑付箋", "青付箋", "紫付箋", "赤付箋", "オレンジ付箋"]
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing:20){
                
                Text("プレミアムプランの方のみ使用いただけます")
                    .foregroundColor(.button)
                    .padding(.top, 20)
                Text("是非使ってみてね！")
                    .foregroundColor(.button)
                Text("クリックすればそのアイコンに変わります")
                    .foregroundColor(.button)
                List{
                    //初期アイコン
                    HStack{
                        Image("AppIconImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        Button{
                            UIApplication.shared.setAlternateIconName(nil)
                        }label:{
                            Text("初期アイコン")
                                .foregroundColor(Color.button)
                        }
                        Spacer()
                    }
                    //カスタムアイコン
                    
                    ForEach(0..<10) { i in
                        
                        if isPurchased {//購入ずみ
                            HStack{
                                Image(ImageNameList[i])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                Button{
                                    UIApplication.shared.setAlternateIconName(IconNameList[i])
                                }label:{
                                    Text(IconTextList[i])
                                        .foregroundColor(Color.button)
                                }
                                Spacer()
                            }
                        }else{//購入してない
                            HStack{
                                Image(ImageNameList[i])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                Text(IconTextList[i])
                                    .foregroundColor(Color.button)
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 20))
                            }
                        }
                    }//ForEach
                }
            }
        }
        
        .navigationBarTitle("icon変更", displayMode: .inline)
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

//#Preview {
//    IconChangeView1()
//}
