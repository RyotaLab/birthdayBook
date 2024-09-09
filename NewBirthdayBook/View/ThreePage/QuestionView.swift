//
//  QuestionView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/16.
//

import SwiftUI

struct QuestionView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    var body: some View {
        ZStack{
            Color.background
            ScrollView(showsIndicators: false){
                VStack{
                    VStack{
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 100))
                            .padding(.top)
                        Text("通知が来ない方へ")
                            .fontWeight(.bold)
                            .padding()
                    }
                    VStack(alignment:.leading){
                        Text("まずは以下をご確認ください")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        
                        Text("◻︎ アプリの通知ON")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                            .padding(.top, 20)
                        Text("◻︎ 人を登録する際の通知ON")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        Text("◻︎ 通知登録者が64人を超えている")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        
                        
                        Text("上記を確認後、1回「通知時間の設定」の時間ずらして「保存」してみてください（全通知が再登録されます）。")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                        Text("それでも通知が来なかった場合、アプリまたはデバイスの不具合の可能性が高いです。")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                        Text("以下のURLから気軽にご報告ください（入力の際に個人情報は必要としません）")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                    }
                    //URL
                    VStack(alignment:.center){
                        Link(destination:URL(string: "https://forms.gle/UTQBe7bNW8y1v4RB7")!, label: {
                            
                            Text("\(Image(systemName:"link"))Googleフォーム")
                                .frame(width: 150, height: 50, alignment: .center)
                                .foregroundColor(.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.orange, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                                .padding(.top, 20)
                            
                        })
                        
                        Text("※当アプリはオフライン通知を採用しています。iPhone(Apple)の制限により、1アプリにつき通知登録数は64個が最大です。64個を超えると通知が届かない場合があります。（アプリに100人登録し、通知するのが64人の場合は正常に動きます。")
                            .font(.subheadline)
                            .foregroundColor(.pink)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationTitle("問い合わせ")
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
//    QuestionView()
//}
