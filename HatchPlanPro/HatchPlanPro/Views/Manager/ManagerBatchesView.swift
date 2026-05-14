import SwiftUI

struct ManagerBatchesView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @StateObject private var viewModel = ManagerBatchesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.batches, id: \.name) { batch in
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
            }
            .padding()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .onAppear {
            viewModel.loadData(from: session)
        }
        .navigationTitle("Batches Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}
