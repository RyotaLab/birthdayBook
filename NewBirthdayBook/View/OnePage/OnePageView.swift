/*
 
 完成
 
 
 */

import SwiftUI

struct OnePageView: View {
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background
                VStack{
                    NavigationLink(destination: SecretView()){
                        Image(systemName: "books.vertical.fill")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 100))
                    }
                    
//                    Image(systemName: "books.vertical.fill")
//                        .foregroundColor(Color.orange)
//                        .font(.system(size: 100))
//                    
                    Text("あなただけの本を作りましょう")
                        .foregroundColor(.button)
                        .frame(height: 100)
                        .font(.body)
                    
                    NavigationLink(destination: MakePersonView()){
                        HStack{
                            Text("\(Image(systemName: "plus"))登録")
                                .fontWeight(.bold)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.orange, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
                .navigationBarTitle("追加しよう", displayMode: .inline)
            }//navigationStack
        }
    }
}

//#Preview {
//    OnePageView()
//}
