import SwiftUI

struct LiquidGlassCircleButton: View {
    let systemImage: String
    let tint: Color
    let buttonSize: CGFloat
    let iconSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.thinMaterial)
                    .overlay(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        tint.opacity(0.55),
                                        tint.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 1.3)
                    )

                Image(systemName: systemImage)
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.25),
                            radius: 4, x: 0, y: 1)
            }
            .frame(width: buttonSize, height: buttonSize)
            .shadow(color: Color.black.opacity(0.2), radius: 18, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.4), radius: 8, x: 0, y: -3)
        }
    }
}
