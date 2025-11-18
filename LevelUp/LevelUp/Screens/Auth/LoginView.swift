//
//  LoginView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingRegister = false
    
    @State private var phone = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("GradientFirst"), location: 0.0),
                    .init(color: .white, location: 0.33),
                    .init(color: .white, location: 0.69),
                    .init(color: Color("GradientSecond"), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 10) {
                    Image("KnightCharacter")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.top, 20)
                    
                    Text("Войди в свой LevelUp")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("С возвращением, герой")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Телефон *")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        TextField("+7 987 123-23-23", text: $phone)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Пароль *")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        SecureField("Введите пароль", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                    }) {
                        Text("Войти")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                    }
                    .background(Color("ButColor"))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    HStack(spacing: 4) {
                        Text("Все еще нет аккаунта?")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Зарегистрироваться")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}

