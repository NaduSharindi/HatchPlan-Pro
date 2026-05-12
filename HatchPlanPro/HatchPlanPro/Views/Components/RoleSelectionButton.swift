//
//  RoleSelectionButton.swift
//  HatchPlanPro
//
//  Created by Nadunika Sharindi on 2026-05-11.
//

import SwiftUI

struct RoleSelectionButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.title2)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        // Note: If figmaPrimary is broken, change this to Color.orange temporarily
        .background(Color.figmaPrimary)
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
