import SwiftUI

struct SupervisorNotificationsView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @StateObject private var viewModel = SupervisorNotificationsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header
                    HStack {
                        Text("Notifications")
                            .font(.title2.bold())
                            .foregroundColor(.hatchGreen)
                        Spacer()
                        NavigationLink(destination: SupervisorProfileView()) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title2)
                                .foregroundColor(.hatchGreen)
                        }
                    }
                    .padding(.horizontal, 20)

                    ForEach(viewModel.sections) { section in
                        notificationSection(title: section.title, notifications: section.notifications)
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(Color.hatchSurface.ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadData(from: session)
            }
        }
    }

    private func notificationSection(
        title: String,
        notifications: [NotificationSectionItem]
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.bold))
                .kerning(1)
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(notifications) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.title3)
                            .foregroundColor(item.type == "CRITICAL ALERT" ? .white : .hatchGreen)
                            .padding(10)
                            .background(Circle().fill(item.iconBg))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.type)
                                .font(.caption.weight(.bold))
                                .kerning(0.8)
                                .foregroundColor(item.type == "CRITICAL ALERT" ? Color(hex: "#FFA500") : .hatchGreen)

                            Text(item.title)
                                .font(.caption)
                                .foregroundColor(.hatchGreen)
                                .lineLimit(3)
                        }

                        Spacer()

                        Text(item.time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.white))
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(hex: "#FAFAFA")))
        .padding(.horizontal, 16)
    }
}
