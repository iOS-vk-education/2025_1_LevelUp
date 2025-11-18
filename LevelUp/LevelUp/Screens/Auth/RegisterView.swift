//
//  RegisterView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
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
                VStack() {
                    Image("WinCup")
                        .padding(.top, 10)
                    
                    HStack(spacing: 4) {
                        Text("Начни свой путь")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        Text("🚀")
                            .font(.system(size: 32))
                    }
                    .multilineTextAlignment(.center)
                    
                    Text("Создай свой аккаунт и зарабатывай опыт за каждую задачу")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Имя *")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        TextField("Введите имя", text: $name)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
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
                        
                        HStack {
                            if showPassword {
                                TextField("Введите пароль", text: $password)
                            } else {
                                SecureField("Введите пароль", text: $password)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Подтверждение пароля *")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        
                        HStack {
                            if showConfirmPassword {
                                TextField("Повторите пароль", text: $confirmPassword)
                            } else {
                                SecureField("Повторите пароль", text: $confirmPassword)
                            }
                            
                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    

                    Button(action: {
                    }) {
                        Text("Создать аккаунт")
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
                        Text("Уже есть аккаунт?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Войти")
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
        RegisterView()
    }
}

