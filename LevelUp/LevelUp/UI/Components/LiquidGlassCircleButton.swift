import SwiftUI

struct LiquidGlassCircleButton: View {
    let systemImage: String
    let tint: Color
    let buttonSize: CGFloat
    let iconSize: CGFloat
    let useMaterial: Bool
    let action: () -> Void
    let imageShadow: CGFloat
    
    
    init(
        systemImage: String,
        tint: Color,
        buttonSize: CGFloat,
        iconSize: CGFloat,
        useMaterial: Bool = true,
        imageShadow: CGFloat = 0.25,
        action: @escaping () -> Void,
    ) {
        self.systemImage = systemImage
        self.tint = tint
        self.buttonSize = buttonSize
        self.iconSize = iconSize
        self.useMaterial = useMaterial
        self.action = action
        self.imageShadow = imageShadow
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if useMaterial {
                    Circle()
                        .fill(.thinMaterial)
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                tint.opacity(0.55),
                                tint.opacity(0.55) // 0,1
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 1.3)
                    )

                Image(systemName: systemImage)
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(imageShadow),
                            radius: 4, x: 0, y: 1)
            }
            .frame(width: buttonSize, height: buttonSize)
        }
    }
}
