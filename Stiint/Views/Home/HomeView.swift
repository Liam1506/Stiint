//
//  HomeView.swift
//  Pattrn
//
//  Created by Liam Wittig on 07.12.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("My Day").navigationTitle("My Day")
        }
    }
}

#Preview {
    HomeView()
}
