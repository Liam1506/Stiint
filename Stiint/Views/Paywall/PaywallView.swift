//
//  PaywallView.swift
//  Stiint
//
//  Created by Liam Wittig on 10.01.26.
//

import StoreKit
import SwiftUI

struct PaywallView: View {
    var body: some View {
        SubscriptionStoreView(groupID: PLUS_GROUP_ID) {
            PaywallMarketingView()
        }
    }
}

#Preview {
    PaywallView()
}
