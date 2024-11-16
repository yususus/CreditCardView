//
//  CardDetailsView.swift
//  CreditCardView
//
//  Created by yusuf on 15.11.2024.
//

import SwiftUI

struct CardDetailsView: View {
    @State private var cards: [Card] = []
    @State private var selectedCard: Card? = nil
    @State private var isFlipped: Bool = false
    @State private var showSaveCardView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if selectedCard != nil {
                    // Seçili kartın detaylı görünümü
                    VStack {
                        ZStack {
                            if isFlipped {
                                CardBackView(cvv2: selectedCard?.cvv2 ?? "")
                                    .rotation3DEffect(
                                        .degrees(180),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                            } else {
                                CardFrontView(
                                    cardNumber: selectedCard?.cardNumber ?? "",
                                    expirationDate: selectedCard?.expirationDate ?? "",
                                    iban: selectedCard?.iban ?? "",
                                    cardName: selectedCard?.cardName ?? "",
                                    CardCompany: getCardCompany(selectedCard?.cardNumber ?? "")
                                )
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
                        .padding()
                        .shadow(radius: 10)
                        
                        // Silme butonu
                        Button(action: {
                            deleteCard(selectedCard)
                        }) {
                            Text("Sil")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(cards) { card in
                            CardFrontView(
                                cardNumber: card.cardNumber,
                                expirationDate: card.expirationDate,
                                iban: card.iban,
                                cardName: card.cardName,
                                CardCompany: getCardCompany(card.cardNumber)
                            )
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    selectedCard = card
                                    isFlipped = false
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                // Yeni kart ekleme butonu
                NavigationLink(destination: SaveCardView(cards: $cards)) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
    
    func getCardCompany(_ cardNumber: String) -> String {
        if cardNumber.hasPrefix("4") {
            return "VISA"
        } else if cardNumber.hasPrefix("5") {
            return "MasterCard"
        } else {
            return "UNKNOWN"
        }
    }

    func deleteCard(_ card: Card?) {
        guard let card = card else { return }
        cards.removeAll { $0.id == card.id }
        selectedCard = nil
    }
}

#Preview {
    CardDetailsView()
}
