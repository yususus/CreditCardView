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
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Card Name", text: $cardName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // IBAN ve Ülke Kodu
            HStack {
                // Ülke Kodu Seçici
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            TextField("Kart Numarası", text: $cardNumber)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Ay/Yıl Seçici
            HStack {
                Text("Son Kullanma:")
                    .foregroundColor(.gray)
                Spacer()
                
                // Ay Seçici
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
                
                // Yıl Seçici
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
            
            Button(action: saveCardDetails) {
                Text("Kaydet")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Kredi Kartı Bilgilerini Kaydet")
        .onAppear {
            // Kayıtlı ülke kodunu yükle
            selectedCountryCode = savedCountryCode
        }
    }
    
    func saveCardDetails() {
        savedCardName = cardName
        savedIBAN = selectedCountryCode + iban // Ülke kodu ile IBAN'ı birleştir
        savedCardNumber = cardNumber
        savedExpirationDate = String(format: "%02d/%02d", selectedMonth, selectedYear % 100)
        savedCVV2 = cvv2
    }
}

#Preview {
    SaveCardView()
}
