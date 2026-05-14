import SwiftUI

struct ManagerProfileView: View {
    @EnvironmentObject private var session: AppSessionViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 12) {
                    Image(systemName: session.currentRole.displaySymbol)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 96, height: 96)
                        .background(Circle().fill(Color.figmaPrimary))

                    Text(session.currentUser.fullName)
                        .font(.title2.bold())
                        .foregroundColor(.figmaTextDark)

                    Text(session.currentUser.email)
                        .foregroundColor(.secondary)

                    Text("Security: \(session.currentUser.preferredSecurity)")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(Color.figmaPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.figmaPrimary.opacity(0.12)))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(.white))
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Workspace")
                        .font(.headline)
                        .foregroundColor(.figmaTextDark)
                    
                    VStack(spacing: 12) {
                        profileRow(label: "Role", value: session.currentRole.rawValue)
                        profileRow(label: "Onboarding", value: "Complete")
                        profileRow(label: "Last sync", value: session.lastSyncSummary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(.white))
                .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)

                Button {
                    session.signOut()
                } label: {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.figmaPrimary))
                }
                .accessibilityLabel("Sign out of the app")
            }
            .padding()
        }
        .background(Color.figmaBackground.ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func profileRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.figmaTextDark)
        }
        .padding(.vertical, 4)
    }
}
