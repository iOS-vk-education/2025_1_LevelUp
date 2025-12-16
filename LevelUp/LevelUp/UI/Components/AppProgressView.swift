import SwiftUI

struct AppProgressView: View {
    let progress: Double
    var height: CGFloat = 12

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(Color("BachgroundColor"))
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)

                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [GlassBlueMain, GlassBlueMain.opacity(0.5)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * CGFloat(clampedProgress))
                    .overlay(
                        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                            .stroke(Color.white.opacity(0.45), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 16) {
        AppProgressView(progress: 0.2)
        AppProgressView(progress: 0.6, height: 14)
        AppProgressView(progress: 1.0)
    }
    .padding()
    .background(Color("BachgroundColor"))
}
