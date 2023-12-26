import SwiftUI
import UIKit

extension View
{
    func inject<SomeView: View>(_ view: SomeView) -> some View {
        overlay(view.frame(maxWidth: .infinity, maxHeight: .infinity).allowsHitTesting(false))
    }

    func underlyingViewController(customize: @escaping (UIViewController) -> ()) -> some View {
        inject(
            UIKitUnderlyingViewController(
                sizeDidChangeCallback: customize
            )
        )
    }
}

class UnderlyingUIViewController: UIViewController {
    let sizeDidChangeCallback: ((UIViewController) -> Void)
    required init(sizeDidChangeCallback: @escaping ((UIViewController) -> Void)) {
        self.sizeDidChangeCallback = sizeDidChangeCallback
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = false
        self.view.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let parent = self.parent {
            self.sizeDidChangeCallback(parent)
        }
    }
}

struct UIKitUnderlyingViewController<TargetViewControllerType: UIViewController>: UIViewControllerRepresentable {
    let sizeDidChangeCallback: (UIViewController) -> Void

    init(sizeDidChangeCallback: @escaping (UIViewController) -> Void) {
        self.sizeDidChangeCallback = sizeDidChangeCallback
    }

    func makeUIViewController(
        context _: UIViewControllerRepresentableContext<UIKitUnderlyingViewController>) -> UnderlyingUIViewController {
        UnderlyingUIViewController(sizeDidChangeCallback: sizeDidChangeCallback)
    }

    func updateUIViewController(
        _ uiViewController: UnderlyingUIViewController,
        context _: UIViewControllerRepresentableContext<UIKitUnderlyingViewController>) {
    }
}
