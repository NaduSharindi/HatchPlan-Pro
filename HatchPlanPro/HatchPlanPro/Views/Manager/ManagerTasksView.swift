import SwiftUI

struct ManagerTasksView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    @StateObject private var viewModel = ManagerTasksViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
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
            .padding()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .onAppear {
            viewModel.loadData(from: session)
        }
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
