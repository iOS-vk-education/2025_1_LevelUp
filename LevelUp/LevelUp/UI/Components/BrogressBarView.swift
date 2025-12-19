import SwiftUI

enum Brogress {
    struct BarView: View {
        let progress: Double
        var height: CGFloat = 14
        var label: String?

        private var clampedProgress: Double {
            min(max(progress, 0), 1)
        }

        var body: some View {
            ZStack {
                AppProgressView(progress: clampedProgress, height: height)

                if let label {
                    Text(label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.black)
                }
            }
            .frame(height: height)
        }
    }
}

