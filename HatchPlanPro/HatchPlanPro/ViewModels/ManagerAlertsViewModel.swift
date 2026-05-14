import Foundation
import Combine
import SwiftUI

class ManagerAlertsViewModel: ObservableObject {
    @Published var alerts: [HatcheryAlert] = []
    
    func loadData(from session: AppSessionViewModel) {
        self.alerts = session.alerts
    }
}
