import SwiftUI

struct WeekStripView: View {
    let weekDays: [WeekDay]
    let selectedDate: Date
    let onSelectDay: (Date) -> Void
    let onShiftWeek: (Int) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let arrowWidth: CGFloat = 28
            let outerPadding: CGFloat = 8
            let outerSpacing: CGFloat = 8
            let innerSpacing: CGFloat = 6
            let available = totalWidth - (outerPadding * 2) - (arrowWidth * 2) - (outerSpacing * 2) - (innerSpacing * 6)
            let baseChip = available / 7
            let minChip: CGFloat = horizontalSizeClass == .regular ? 46 : 32
            let maxChip: CGFloat = horizontalSizeClass == .regular ? 62 : 48
            let chipSize = min(max(baseChip, minChip), maxChip)

            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

                HStack(spacing: outerSpacing) {
                    Button { onShiftWeek(-1) } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                            .frame(width: arrowWidth, height: arrowWidth)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    HStack(spacing: innerSpacing) {
                        ForEach(weekDays) { day in
                            let isToday = Calendar.current.isDate(day.date, inSameDayAs: Date())
                            let isSelected = Calendar.current.isDate(day.date, inSameDayAs: selectedDate)
                            let highlight = isToday || isSelected

                            VStack(spacing: 6) {
                                Text(day.shortWeekday.uppercased())
                                    .font(.caption2)
                                    .foregroundStyle(.gray)

                                ZStack {
                                    Circle()
                                        .fill(highlight ? Color.blue : Color.blue.opacity(0.3))
                                        .frame(width: chipSize, height: chipSize)
                                        .shadow(color: Color.black.opacity(0.08), radius: highlight ? 6 : 3, x: 0, y: highlight ? 6 : 3)

                                    Text(day.dayNumber)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelectDay(day.date)
                            }
                            .overlay(alignment: .bottom) {
                                statusDot(for: day.status)
                                    .offset(y: 8)
                            }
                        }
                    }

                    Button { onShiftWeek(1) } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.primary)
                            .frame(width: arrowWidth, height: arrowWidth)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, outerPadding)
                .padding(.vertical, 12)
            }
        }
        .frame(height: 104)
    }

    @ViewBuilder
    private func statusDot(for status: CompletionState) -> some View {
        switch status {
        case .none:
            Color.clear.frame(height: 6)
        case .partial:
            Circle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 6, height: 6)
        case .full:
            Circle()
                .fill(Color.blue)
                .frame(width: 6, height: 6)
        }
    }
}
