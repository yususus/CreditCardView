//
//  Card.swift
//  CreditCardView
//
//  Created by yusuf on 16.11.2024.
//

import Foundation
struct Card: Identifiable {
    let id = UUID()
    var cardName: String
    var iban: String
    var cardNumber: String
    var expirationDate: String
    var cvv2: String
}
