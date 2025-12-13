//
//  TimeLineScrollableView.swift
//  Stiint
//
//  Created by Wittig, Liam on 13.12.25.
//

import SwiftUI
import UIKit

struct TimeLineScrollableView<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding var verticalScale: CGFloat
    
    let minScale: CGFloat
    let maxScale: CGFloat
    
    init(verticalScale: Binding<CGFloat>, minScale: CGFloat = 0.5, maxScale: CGFloat = 3.0, @ViewBuilder content: () -> Content) {
        self._verticalScale = verticalScale
        self.minScale = minScale
        self.maxScale = maxScale
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostingController.view)
        
        context.coordinator.hostingController = hostingController
        context.coordinator.scrollView = scrollView
        context.coordinator.setupConstraints()
        
        // Add pinch gesture for vertical scaling
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(_:)))
        scrollView.addGestureRecognizer(pinchGesture)
        
        return scrollView
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        context.coordinator.hostingController?.rootView = content
        context.coordinator.updateScale(verticalScale)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(verticalScale: $verticalScale, minScale: minScale, maxScale: maxScale)
    }
    
    class Coordinator: NSObject {
        @Binding var verticalScale: CGFloat
        var hostingController: UIHostingController<Content>?
        var scrollView: UIScrollView?
        var heightConstraint: NSLayoutConstraint?
        var initialScale: CGFloat = 1.0
        let minScale: CGFloat
        let maxScale: CGFloat
        
        init(verticalScale: Binding<CGFloat>, minScale: CGFloat, maxScale: CGFloat) {
            self._verticalScale = verticalScale
            self.minScale = minScale
            self.maxScale = maxScale
        }
        
        func setupConstraints() {
            guard let hostingView = hostingController?.view,
                  let scrollView = scrollView else { return }
            
            heightConstraint = hostingView.heightAnchor.constraint(equalToConstant: 2000)
            
            NSLayoutConstraint.activate([
                hostingView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                hostingView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                hostingView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                heightConstraint!
            ])
        }
        
        func updateScale(_ scale: CGFloat) {
            heightConstraint?.constant = 2000 * scale
            scrollView?.layoutIfNeeded()
        }
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            switch gesture.state {
            case .began:
                initialScale = verticalScale
            case .changed:
                let newScale = initialScale * gesture.scale
                verticalScale = min(max(newScale, minScale), maxScale)
            default:
                break
            }
        }
    }
}
