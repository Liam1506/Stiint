//
//  PaywallViw.swift
//  Stiint
//
//  Created by Liam Wittig on 10.01.26.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    var body: some View {
        SubscriptionStoreView(groupID: PLUS_GROUP_ID){
          PaywallMarketingView()
        }
    }
}

#Preview {
    PaywallView()
}
