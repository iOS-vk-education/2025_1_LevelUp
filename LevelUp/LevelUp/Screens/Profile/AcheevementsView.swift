//
//  AcheevementsView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct AcheevementStep {
    let title: String
    let description: String
    let wage: Int
}

struct Acheevement {
    let completed: Int
    let steps: [AcheevementStep]
}

let levelUp = Acheevement(
    completed: 1,
    steps: [
        AcheevementStep(
            title: "Прокачка 1",
            description: "Достигните 10 уровня",
            wage: 100,
        ),
        AcheevementStep(
            title: "Прокачка 2",
            description: "Достигните 20 уровня",
            wage: 150,
        ),
        AcheevementStep(
            title: "Прокачка 3",
            description: "Достигните 30 уровня",
            wage: 200,
        ),
    ]
)

let hardwork = Acheevement(
    completed: 3,
    steps: [
        AcheevementStep(
            title: "Трудная работа 1",
            description: "Выполните 10 задач",
            wage: 100,
        ),
        AcheevementStep(
            title: "Трудная работа 2",
            description: "Выполните 100 задач",
            wage: 150,
        ),
        AcheevementStep(
            title: "Трудная работа 3",
            description: "Выполните 500 задач",
            wage: 200,
        ),
        AcheevementStep(
            title: "Трудная работа 4",
            description: "Выполните 1000 задач",
            wage: 300,
        ),
        AcheevementStep(
            title: "Трудная работа 5",
            description: "Выполните 5000 задач",
            wage: 400,
        ),
    ]
)


let acheevements = [levelUp, hardwork]


public struct AcheevementsView: View {
    
    public var body: some View {
        VStack {
            HStack {
                Button("", systemImage: "chevron.backward") {
                }
                .frame(width: 44, height: 44)
                .foregroundColor(.black)
                Spacer()
            }
            .overlay(
                Text("Достижения")
                    .font(.system(size: 20))
                    .frame(alignment: .center)
            )
            .padding(.horizontal, 26)
            
            VStack(spacing: 15) {
                ZStack {
                    AcheevementBackgroundView(height: 180)
                    Text("Выполняйте достижения и получайте ОП за их выполнение!\n\nВыполнено 4 из 120 достижений.")
                        .font(.system(size: 20))
                        .padding(.horizontal, 20)
                        .frame(width: 320)
                }
                
                
                ForEach(Array(acheevements.enumerated()), id: \.offset) { idx, ach in
                    
                    let currentStep = ach.steps[min(ach.completed, ach.steps.count - 1)]
                    
                    ZStack {
                        AcheevementBackgroundView(height: 100)
                        HStack {
                            StarsView(completed: ach.completed, total: ach.steps.count)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(currentStep.title)
                                    .font(.system(size: 20, weight: .semibold))
                                Text(currentStep.description)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 320)
                    }
                }
            }
            .foregroundColor(.white)
        }
        Spacer()
    }
}

#Preview {
    AcheevementsView()
}
