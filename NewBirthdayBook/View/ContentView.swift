//
//  ContentView.swift
//  NewBirthdayBook
//
//  Created by 渡邊涼太 on 2024/04/09.
//

import SwiftUI

struct ContentView: View {
    // AdMob interstitial広告
    @ObservedObject  var interstitial = AdmobInterstitialManager()
    
    @State var selection = 1

    var body: some View {

            TabView(selection: $selection) {

                OnePageView()   // Viewファイル①
                    .tabItem {
                        Label("登録", systemImage: "person.fill.badge.plus")
                    }
                    .tag(1)

                TwoPageView()   // Viewファイル②
                    .tabItem {
                        Label("リスト", systemImage: "list.bullet")
                    }
                    .tag(2)

                ThreePageView()  // Viewファイル③
                    .tabItem {
                        Label("その他", systemImage: "gear")
                    }
                    .tag(3)

            } // TabView ここまで
            .accentColor(Color.orange)

        } // body
}

//#Preview {
//    ContentView()
//}
