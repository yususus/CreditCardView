//
//  CardBackView.swift
//  CreditCardView
//
//  Created by yusuf on 15.11.2024.
//

import SwiftUI

struct CardBackView: View {
    let cvv2: String
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 40)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.47))
                .padding(.top, 10)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("CVV2: \(cvv2)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Button(action: {
                    UIPasteboard.general.string = cvv2
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 20)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 300,height: 180)
        .background(LinearGradient(stops: [.init(color: .black.opacity(0.9), location: 0), .init(color: .black.opacity(0.6), location: 1)], startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        
    }
}

#Preview {
    CardBackView(cvv2: "785")
}
