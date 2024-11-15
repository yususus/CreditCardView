//
//  CardDetailsView.swift
//  CreditCardView
//
//  Created by yusuf on 15.11.2024.
//

import SwiftUI

struct CardDetailsView: View {
    @AppStorage("savedIBAN") private var savedIBAN: String = ""
    @AppStorage("savedCardNumber") private var savedCardNumber: String = ""
    @AppStorage("savedExpirationDate") private var savedExpirationDate: String = ""
    @AppStorage("savedCVV2") private var savedCVV2: String = ""
    @AppStorage("savedCardName") private var savedCardName: String = ""
    
    
    @State private var isFlipped: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: SaveCardView()) {
                    Text("Kredi Kartı Bilgilerini Kaydet")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                ZStack {
                    if isFlipped {
                        CardBackView(cvv2: savedCVV2)
                            .rotation3DEffect(
                                .degrees(180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    } else {
                        CardFrontView(cardNumber: savedCardNumber, expirationDate: savedExpirationDate, iban: savedIBAN, cardName: savedCardName)
                    }
                }
                
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .onTapGesture {
                    withAnimation {
                        isFlipped.toggle()
                    }
                }
                .shadow(radius: 10)
                .padding()
                
            }
            .padding()
        }
    }
}

#Preview {
    CardDetailsView()
}
