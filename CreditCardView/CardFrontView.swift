//
//  CardFrontView.swift
//  CreditCardView
//
//  Created by yusuf on 15.11.2024.
//

import SwiftUI

struct CardFrontView: View {
    let cardNumber: String
    let expirationDate: String
    let iban: String
    let cardName: String
    
    private var countryCode: String {
        String(iban.prefix(2))
    }
    
    private var ibanNumber: String {
        String(iban.dropFirst(2))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            Text(cardName)
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                Text(cardNumber)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = cardNumber
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                }
            }
            
            HStack {
                Text("Son Kullanma Tarihi: \(expirationDate)")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            
            HStack {
                Text("IBAN:")
                    .font(.footnote)
                    .foregroundColor(.white)
                Text(countryCode)
                    .font(.footnote)
                    .foregroundColor(.yellow)
                    .bold()
                Text(ibanNumber)
                    .font(.footnote)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = iban
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(width: 300, height: 180)
        .background(
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.9), location: 0),
                    .init(color: .black.opacity(0.6), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
    }
}

#Preview {
    CardFrontView(cardNumber: "4345 0000", expirationDate: "12/27", iban: "TR31231", cardName: "dasda")
}
