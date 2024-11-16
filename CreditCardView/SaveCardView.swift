//
//  SaveCardView.swift
//  CreditCardView
//
//  Created by yusuf on 15.11.2024.
//

import SwiftUI

struct CountryCode: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
}

struct SaveCardView: View {
    @ObservedObject var cardManager: CardManager
    @State private var iban: String = ""
    @State private var cardNumber: String = ""
    @State private var cvv2: String = ""
    @State private var cardName: String = ""
    
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    @AppStorage("savedIBAN") private var savedIBAN: String = ""
    @AppStorage("savedCardNumber") private var savedCardNumber: String = ""
    @AppStorage("savedExpirationDate") private var savedExpirationDate: String = ""
    @AppStorage("savedCVV2") private var savedCVV2: String = ""
    @AppStorage("savedCardName") private var savedCardName: String = ""
    @AppStorage("savedCountryCode") private var savedCountryCode: String = "TR"
    
    @State private var selectedCountryCode: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    private let months = Array(1...12)
    private let years = Array(Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date()) + 15))
    
    private let countryCodes = [
        CountryCode(code: "TR", name: "Türkiye"),
        CountryCode(code: "DE", name: "Almanya"),
        CountryCode(code: "GB", name: "İngiltere"),
        CountryCode(code: "FR", name: "Fransa"),
        CountryCode(code: "IT", name: "İtalya"),
        CountryCode(code: "ES", name: "İspanya"),
        CountryCode(code: "NL", name: "Hollanda"),
        
    ]
    
    @State private var emptyAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Card Name", text: $cardName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Menu {
                    ForEach(countryCodes) { country in
                        Button(action: {
                            selectedCountryCode = country.code
                            savedCountryCode = country.code // Seçimi kaydet
                        }) {
                            HStack {
                                Text(country.code)
                                Text("-")
                                Text(country.name)
                            }
                        }
                    }
                } label: {
                    Text(selectedCountryCode)
                        .foregroundColor(.black)
                        .frame(width: 50)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                TextField("IBAN", text: $iban)
                    .onChange(of: iban) { newValue in
                        iban = formatIBAN(newValue)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            TextField("Kart Numarası", text: $cardNumber)
                .onChange(of: cardNumber) { newValue in
                    cardNumber = formatCardNumber(newValue)
                }
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Text("Son Kullanma:")
                    .foregroundColor(.gray)
                Spacer()
                Picker("Ay", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(String(format: "%02d", month))
                            .tag(month)
                    }
                }
                .frame(width: 65)
                .clipped()
                
                Text("/")
                    .font(.title2)
                
                Picker("Yıl", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(format: "%d", year % 100))
                            .tag(year)
                    }
                }
                .frame(width: 65)
                .clipped()
            }
            .padding()
            
            TextField("CVV2", text: $cvv2)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: saveCard) {
                Text("Kaydet")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $emptyAlert) {
                Alert(
                    title: Text("Hata"),
                    message: Text("Lütfen tüm alanları doldurun."),
                    dismissButton: .default(Text("Tamam"))
                )
            }
        }
        .padding()
        .navigationTitle("Kredi Kartı Bilgilerini Kaydet")
        .onAppear {
            selectedCountryCode = savedCountryCode
        }
    }
    
    func saveCard() {
        if cardName.isEmpty || iban.isEmpty || cardNumber.isEmpty || cvv2.isEmpty {
            emptyAlert = true
        } else {
            let newCard = Card(
                cardName: cardName,
                iban: selectedCountryCode + iban,
                cardNumber: cardNumber,
                expirationDate: String(format: "%02d/%02d", selectedMonth, selectedYear % 100),
                cvv2: cvv2
            )
            cardManager.addCard(newCard)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func formatIBAN(_ input: String) -> String {
        // Kullanıcının girilen değerini temizle
        let cleaned = input.uppercased().replacingOccurrences(of: " ", with: "")
        
        // Sadece 22 karakterlik sınırlı bir alan kullan
        let limited = String(cleaned.prefix(24))
        
        // 4'lük gruplara böl ve grupları birleştir
        let grouped = stride(from: 0, to: limited.count, by: 4).map {
            Array(limited)[$0..<min($0 + 4, limited.count)]
        }.map { String($0) }.joined(separator: " ")
        
        return grouped
    }
    
    func formatCardNumber(_ input: String) -> String {
        // Boşlukları kaldır ve harfleri büyük harfe çevir
        let cleaned = input.uppercased().replacingOccurrences(of: " ", with: "")
        let limited = String(cleaned.prefix(16))
        
        // 4'lük gruplara ayır
        let grouped = stride(from: 0, to: limited.count, by: 4).map {
            Array(cleaned)[$0..<min($0 + 4, cleaned.count)]
        }
        return grouped.map { String($0) }.joined(separator: " ")
    }
}

#Preview {
    SaveCardView(cardManager: CardManager())
}
