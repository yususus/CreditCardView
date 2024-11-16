//
//  Card.swift
//  CreditCardView
//
//  Created by yusuf on 16.11.2024.
//

import Foundation
struct Card: Identifiable, Codable {
    var id = UUID()
    var cardName: String
    var iban: String
    var cardNumber: String
    var expirationDate: String
    var cvv2: String
}

// Kart verilerini yönetmek için bir CardManager sınıfı
class CardManager: ObservableObject {
    @Published var cards: [Card] = [] {
        didSet {
            saveCards()
        }
    }
    
    init() {
        loadCards()
    }
    
    private func saveCards() {
        if let encoded = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(encoded, forKey: "savedCards")
        }
    }
    
    private func loadCards() {
        if let savedCards = UserDefaults.standard.data(forKey: "savedCards"),
           let decodedCards = try? JSONDecoder().decode([Card].self, from: savedCards) {
            self.cards = decodedCards
        }
    }
    
    func addCard(_ card: Card) {
        cards.append(card)
    }
    
    func deleteCard(_ card: Card) {
        cards.removeAll { $0.id == card.id }
    }
}
