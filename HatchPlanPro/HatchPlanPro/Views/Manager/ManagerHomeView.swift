import SwiftUI

struct ManagerHomeView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @StateObject private var viewModel = ManagerDashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Manager Workspace")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(Color.figmaPrimary)
                            Text("Good morning, \(viewModel.fullName)")
                                .font(.title2.bold())
                                .foregroundColor(.figmaTextDark)
                        }
                        Spacer()
                        Image(systemName: "briefcase.fill")
                            .font(.title2)
                            .foregroundColor(.figmaPrimary)
                            .padding(14)
                            .background(Circle().fill(Color.figmaPrimary.opacity(0.12)))
                    }
                    
                    Text(viewModel.summary)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.white, Color.figmaPrimary.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
                
                // MARK: - Metrics
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(viewModel.metrics, id: \.title) { metric in
                        MetricCardView(title: metric.title, value: metric.value, change: metric.change, tint: metric.tint)
                    }
                }
                
                // MARK: - Critical Batches
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("Critical Batches", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline)
                            .foregroundColor(.figmaTextDark)
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.criticalBatches, id: \.name) { batch in
                            BatchRowView(
                                name: batch.name,
                                stage: batch.stage,
                                eggs: batch.eggs,
                                temperature: batch.temperature,
                                humidity: batch.humidity,
                                isCritical: batch.isCritical,
                                progress: batch.completionProgress,
                                turnerStatus: batch.turnerStatus
                            )
                        }
                        if viewModel.criticalBatches.isEmpty {
                            Text("No critical batches at the moment.")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
                .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)

                // MARK: - Today's Focus
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("Today's Focus", systemImage: "checklist")
                            .font(.headline)
                            .foregroundColor(.figmaTextDark)
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(viewModel.tasks, id: \.title) { task in
                            TaskRowView(
                                title: task.title,
                                subtitle: task.subtitle,
                                isDone: task.state == .done,
                                dueLabel: task.dueLabel,
                                iconName: task.iconName
                            )
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
                .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)
            }
            .padding()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .onAppear {
            viewModel.loadData(from: session)
        }
        .navigationTitle("HatchPlan Pro")
        .navigationBarTitleDisplayMode(.inline)
    }
}
