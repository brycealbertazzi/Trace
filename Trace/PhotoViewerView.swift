//
//  PhotoViewerView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/26/26.
//

import SwiftUI
import UIKit

struct PhotoViewerView: View {
    let image: UIImage
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZoomableScrollView {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)

        context.coordinator.hostingController = hostingController

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        context.coordinator.hostingController?.rootView = content

        DispatchQueue.main.async {
            let contentSize = context.coordinator.hostingController?.view.intrinsicContentSize ?? .zero
            scrollView.contentSize = contentSize

            if let hostingView = context.coordinator.hostingController?.view {
                hostingView.frame.size = contentSize
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController?.view
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerContent(in: scrollView)
        }

        private func centerContent(in scrollView: UIScrollView) {
            guard let contentView = hostingController?.view else { return }

            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)

            contentView.frame.origin = CGPoint(x: offsetX, y: offsetY)
        }
    }
}
