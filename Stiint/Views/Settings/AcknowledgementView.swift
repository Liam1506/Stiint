//
//  AknwoledmentView.swift
//  Stiint
//
//  Created by Wittig, Liam on 22.12.25.
//

import SwiftUI
import AcknowList

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


