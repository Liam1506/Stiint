//
//  openAutomationPage.swift
//  Stiint
//
//  Created by Wittig, Liam on 11.12.25.
//
import Foundation
import UIKit

func openAutomationPage() {
    if let url = URL(string: "shortcuts://create-automation") {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
