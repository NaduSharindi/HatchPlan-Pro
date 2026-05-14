import Foundation
import Combine
import SwiftUI

struct SupervisorBatchInsight: Identifiable {
    let id: String
    let breed: String
    let date: String
    let status: String
    let statusColor: Color
}

class SupervisorBatchesViewModel: ObservableObject {
    @Published var approvedBatches: [SupervisorBatchInsight] = []
    @Published var pendingBatches: [SupervisorBatchInsight] = []
    @Published var rejectedBatches: [SupervisorBatchInsight] = []
    @Published var syncedBatches: [SupervisorBatchInsight] = []
    
    @Published var efficiencyIncrease: Double = 4.2
    @Published var reviewMessage: String = "Reviews by Manager Sarah & Ops Lead Mike"
    
    func loadData(from session: AppSessionViewModel) {
        // Normally you'd parse from session.batchInsights. We'll simulate grouping based on UI expectations.
        self.approvedBatches = [
            SupervisorBatchInsight(id: "#B1024", breed: "Ross 308", date: "Oct 24, 2023", status: "APPROVED", statusColor: .hatchGreen),
            SupervisorBatchInsight(id: "#B1028", breed: "Cobb 500", date: "Oct 24, 2023", status: "APPROVED", statusColor: .hatchGreen)
        ]
        
        self.pendingBatches = [
            SupervisorBatchInsight(id: "#B1029", breed: "Ross 708", date: "Oct 24, 2023", status: "PENDING", statusColor: Color(hex: "#FFA500"))
        ]
        
        self.rejectedBatches = [
            SupervisorBatchInsight(id: "#B1022", breed: "Lohmann Brown", date: "Oct 24, 2023", status: "REJECTED", statusColor: Color(hex: "#FF6B6B"))
        ]
        
        self.syncedBatches = [
            SupervisorBatchInsight(id: "#B1020", breed: "Hubbard Efficiency Plus", date: "Oct 24, 2023", status: "SYNCED", statusColor: .hatchGreen)
        ]
    }
}
