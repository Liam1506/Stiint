//
//  AcknowledgementView.swift
//  Stiint
//
//  Created by Wittig, Liam on 22.12.25.
//

import AcknowList
import SwiftUI

struct AcknowledgementsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            AcknowListSwiftUIView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    AcknowledgementsView()
}
