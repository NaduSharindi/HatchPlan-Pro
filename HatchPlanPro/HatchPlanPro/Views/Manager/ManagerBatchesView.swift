import SwiftUI

struct ManagerApprovalsView: View {
    @EnvironmentObject private var session: AppSessionViewModel

    private let approvals: [ManagerApprovalItem] = [
        .init(name: "Nadunika", batchID: "#B1024", location: "Meegoda", requestedAt: "09:41 AM", chicksNeeded: "12.5k chicks needed", avatarSeed: "N", isUrgent: true),
        .init(name: "Marcus Thorne", batchID: "#B1025", location: "Kosgama", requestedAt: "08:15 AM", chicksNeeded: "12.5k chicks needed", avatarSeed: "M", isUrgent: false),
        .init(name: "Elena Rodriguez", batchID: "#A9982", location: "Meegoda", requestedAt: "Yesterday • 04:30 PM", chicksNeeded: "12.5k chicks needed", avatarSeed: "E", isUrgent: false),
        .init(name: "Jin Wei", batchID: "#B1020", location: "Halwatura", requestedAt: "Oct 24 • 11:20 AM", chicksNeeded: "12.5k chicks needed", avatarSeed: "J", isUrgent: false)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                header

                VStack(alignment: .leading, spacing: 10) {
                    Text("QUEUE")
                        .font(.caption.weight(.bold))
                        .tracking(1.8)
                        .foregroundColor(.hatchOrange)
                    Text("8 Pending")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }

                VStack(spacing: 14) {
                    ForEach(approvals) { item in
                        NavigationLink(destination: ManagerApprovalPlanView()) {
                            ApprovalRowView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }

                bulkReviewCard
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color.hatchSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.hatchGreen)
                    .frame(width: 42, height: 42)
            }

            Spacer()

            Text("Approvals")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.hatchGreen)

            Spacer()

            Circle()
                .fill(LinearGradient(colors: [.brown.opacity(0.7), .black.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(Text("M").font(.caption.weight(.bold)).foregroundColor(.white))
                .frame(width: 42, height: 42)
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }

    private var bulkReviewCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Bulk Review")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
            Text("Accelerate your workflow by processing all verified standard requests.")
                .font(.body)
                .foregroundColor(.white.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)

            Button(action: {}) {
                Text("Start Batch Approval")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.hatchGreenDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.hatchOrangeSoft))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(colors: [.hatchGreenDeep, .hatchGreen], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(color: .hatchGreen.opacity(0.18), radius: 16, x: 0, y: 10)
    }
}

private struct ManagerApprovalItem: Identifiable {
    let id = UUID()
    let name: String
    let batchID: String
    let location: String
    let requestedAt: String
    let chicksNeeded: String
    let avatarSeed: String
    let isUrgent: Bool
}

private struct ApprovalRowView: View {
    let item: ManagerApprovalItem

    var body: some View {
        HStack(spacing: 14) {
            AvatarBadge(seed: item.avatarSeed, isUrgent: item.isUrgent)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(item.name)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.primary)
                    Text(item.batchID)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.hatchGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.hatchGreenSoft))
                }

                Text("\(item.chicksNeeded), \(item.location)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("REQUESTED \(item.requestedAt.uppercased())")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
    }
}

private struct AvatarBadge: View {
    let seed: String
    let isUrgent: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(colors: [Color(red: 0.15, green: 0.2, blue: 0.25), Color(red: 0.07, green: 0.1, blue: 0.13)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 52, height: 52)
                .clipShape(Circle())

            Text(seed)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)

            Circle()
                .fill(isUrgent ? Color.hatchOrange : Color.hatchGreen)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .offset(x: 2, y: 2)
        }
    }
}

#Preview {
    NavigationStack {
        ManagerApprovalsView()
            .environmentObject(AppSessionViewModel())
    }
}
