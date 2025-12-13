//
//  SankyDiagramView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import Sankey
import SwiftUI

struct SankyDiagramView: View {
    
    let data = SankeyData(
            nodes: [
                SankeyNode("Avaible Time (24h)", color: .blue),
                SankeyNode("Sleep (8h)", color: .red),
                SankeyNode("Instagram (4h)", color: .yellow),
                SankeyNode("Driving (3h)", color: .green),
                
                SankeyNode("Work (9h)", color: .green),
            ],
            links: [
                SankeyLink(8, from: "Avaible Time (24h)", to: "Sleep (8h)"),
                SankeyLink(4, from: "Avaible Time (24h)", to: "Instagram (4h)"),
                SankeyLink(3, from: "Avaible Time (24h)", to: "Driving (3h)"),
                SankeyLink(9, from: "Avaible Time (24h)", to: "Work (9h)"),
            ]
        )
    
    var body: some View {
        SankeyDiagram(data)
                .nodeOpacity(1)
                .linkColorMode(.target)
                .padding(30)
                .frame(height: 300)
                .background(.regularMaterial)
                .cornerRadius(40)
    }
}

#Preview {
    SankyDiagramView()
}
