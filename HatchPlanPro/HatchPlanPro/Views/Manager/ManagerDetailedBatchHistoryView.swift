import SwiftUI

struct ManagerDetailedBatchHistoryView: View {
    let batch: BatchHistoryItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header Details
                headerSection
                
                // Analytics
                analyticsSection
                
                // Timeline
                timelineSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.hatchGreen)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(.white))
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(batch.id)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.hatchGreenSoft)
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.hatchGreen)
            }
            
            VStack(spacing: 4) {
                Text("Batch Completed")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.hatchGreen)
                Text(batch.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
    
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("PERFORMANCE ANALYTICS")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                statCard(title: "Hatch Rate", value: batch.rate, icon: "chart.bar.fill", color: .hatchGreen)
                statCard(title: "Quality", value: "A+", icon: "star.fill", color: .hatchOrange)
            }
            
            HStack(spacing: 12) {
                statCard(title: "Mortality", value: "0.8%", icon: "heart.slash.fill", color: .red)
                statCard(title: "Duration", value: "21 Days", icon: "clock.fill", color: .blue)
            }
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("BATCH TIMELINE")
                .font(.caption.weight(.bold))
                .tracking(1.2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 0) {
                timelineEvent(title: "Eggs Set", date: "Oct 7, 2023", description: "12,500 eggs placed in Incubator 3", isLast: false)
                timelineEvent(title: "Candling Day 7", date: "Oct 14, 2023", description: "Fertility confirmed at 94.2%", isLast: false)
                timelineEvent(title: "Transfer to Hatcher", date: "Oct 25, 2023", description: "Moved to Hatcher B successfully", isLast: false)
                timelineEvent(title: "Hatching Completed", date: batch.date.replacingOccurrences(of: "Completed ", with: ""), description: "Final chick count verified", isLast: true)
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 4)
        }
    }
    
    private func timelineEvent(title: String, date: String, description: String, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.hatchGreen)
                    .frame(width: 12, height: 12)
                    .padding(.top, 4)
                
                if !isLast {
                    Rectangle()
                        .fill(Color.hatchGreenSoft)
                        .frame(width: 2)
                        .padding(.vertical, 4)
                }
            }
            .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(date)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.secondary)
                }
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, isLast ? 0 : 20)
        }
    }
}

#Preview {
    NavigationStack {
        ManagerDetailedBatchHistoryView(batch: BatchHistoryItem(id: "#B2023-10-A", date: "Completed Oct 28, 2023", rate: "94.5%"))
    }
}
