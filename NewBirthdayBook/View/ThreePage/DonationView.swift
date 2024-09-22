//
//  DonationView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/10.
//

import SwiftUI

struct DonationView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @State var isShowMailView:Bool = false
    @State var isShowPig:Bool = false
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing:20){
                Image("pig")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding()
                
                Text("\"奢る\"とは開発者の収入源であり、開発者に対し「良いアプリだ！これくらい奢ってやるよ！」というものです。")
                    .foregroundColor(.button)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(.horizontal, 15)
                Text("開発者がたまに美味しいものを食べられるようになるだけです。そして感謝としていただくお金はとても嬉しいです。")
                    .foregroundColor(.button)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(.horizontal,15)
                
                List{
                    HStack{
                        Image("juice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                        Text("ジュースを奢る")
                        Spacer()
                        Button{
                            //ジュース購入処理
                            Task{
                                do{
                                    let juice = purchaseManager.ConsumableProducts.first(where: {$0.id == "tanabi.NewBirthdayBook.donation.item1"})
                                    if juice != nil {
                                        try await purchaseManager.purchase(juice!)
                                    }
                                }catch{
                                    print(error)
                                }
                            }
                        }label:{
                            Text("120円")
                                .frame(width: 65, height: 40, alignment: .center)
                                .foregroundColor(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 1.0)
                                )
                                .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    HStack{
                        Image("gyoza")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                        Text("餃子を奢る")
                        Spacer()
                        Button{
                            //餃子購入処理
                            Task{
                                do{
                                    let gyoza = purchaseManager.ConsumableProducts.first(where: {$0.id == "tanabi.NewBirthdayBook.donation.item2"})
                                    if gyoza != nil {
                                        try await purchaseManager.purchase(gyoza!)
                                    }
                                }catch{
                                    print(error)
                                }
                            }
                        }label:{
                            Text("490円")
                                .frame(width: 65, height: 40, alignment: .center)
                                .foregroundColor(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 1.0)
                                )
                                .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    HStack{
                        Image("ra-men")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                        Text("ラーメンを奢る")
                        Spacer()
                        Button{
                            //ラーメン購入処理
                            Task{
                                do{
                                    let ramen = purchaseManager.ConsumableProducts.first(where: {$0.id == "tanabi.NewBirthdayBook.donation.item3"})
                                    if ramen != nil {
                                        try await purchaseManager.purchase(ramen!)
                                    }
                                }catch{
                                    print(error)
                                }
                            }
                        }label:{
                            Text("980円")
                                .frame(width: 65, height: 40, alignment: .center)
                                .foregroundColor(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 1.0)
                                )
                                .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }//List
                .buttonStyle(.plain)
                
            }//VStack
            
            
            
        }
        .navigationBarTitle("奢る", displayMode: .inline)
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
        
        .alert("伝えたいメッセージはありますか？", isPresented: $purchaseManager.donation){
            Button("YES", role: .cancel){
                if MailView.canSendMail() {
                    isShowMailView = true
                } else {
                    // MailViewを表示できない
                }
            }
            Button("NO", role: .destructive){
            }
        }message:{
            
        }
        
        .sheet(isPresented: $isShowMailView) {
            MailView(
                address: ["newbirthdaybook@gmail.com"],
                subject: "開発者に伝えたいこと",
                body: ""
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//#Preview {
//    DonationView()
//}
