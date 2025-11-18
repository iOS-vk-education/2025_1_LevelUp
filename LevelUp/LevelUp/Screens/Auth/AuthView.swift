//
//  AuthView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct AuthView: View {
    @State private var showingRegister = false
    
    var body: some View {
        NavigationStack {
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
                
                VStack() {
                    Spacer()
                        .frame(height: 41)
                    
                    Image("MainAuth")
                    
                    Text("Добро пожаловать в LevelUp")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Ставь цели. Строй привычки. Копи опыт.")
                        .multilineTextAlignment(.center)
                    NavigationLink(destination: RegisterView()){
                        Text("Зарегистрироваться")
                            .frame(width: 380, height: 54)
                            .background(Color("ButColor"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    NavigationLink(destination: LoginView()) {
                        Text("Войти")
                            .frame(width: 380, height: 54)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .foregroundColor(Color("LoginColorText"))
                    }
                }
            }
            .sheet(isPresented: $showingRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    AuthView()
}

