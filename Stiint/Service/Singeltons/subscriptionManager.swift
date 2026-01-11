//
//  paywallManager.swift
//  Stiint
//
//  Created by Liam Wittig on 10.01.26.
//
import Foundation
import StoreKit

@Observable
public final class SubscriptionManager {
    public private(set) var isPro: Bool
    public var displayPaywall: Bool

    private var updateListenerTask: Task<Void, Never>?

    init() {
        isPro = false
        displayPaywall = false

        Task {
            await checkSubscriptionStatus()
        }

        startTransactionListener()
    }

    deinit {
        updateListenerTask?.cancel()
    }

    public func showPaywall() {
        if !isPro {
            displayPaywall = true
        }
    }

    @MainActor
    public func checkSubscriptionStatus() async {
        var isSubscribed = false

        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                if transaction.revocationDate == nil {
                    isSubscribed = true
                    displayPaywall = false
                    break
                }
            }
        }

        isPro = isSubscribed
    }

    private func startTransactionListener() {
        updateListenerTask = Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case let .verified(transaction) = result {
                    await transaction.finish()

                    await self?.checkSubscriptionStatus()
                }
            }
        }
    }

    public func hasAccess(to productID: String) async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result,
               transaction.productID == productID,
               transaction.revocationDate == nil
            {
                return true
            }
        }
        return false
    }
}

public extension SubscriptionManager {
    static let shared = SubscriptionManager()
}
