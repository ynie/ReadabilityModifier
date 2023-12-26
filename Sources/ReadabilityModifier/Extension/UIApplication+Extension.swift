import UIKit

public extension UIApplication
{
    ///
    /// Returns `true` when if the app is running on an iPad in splitscreen mode
    ///
    var isSplitOrSlideOver: Bool
    {
#if targetEnvironment(macCatalyst)
        return true
#else
        guard let window = windows
            .filter(\.isKeyWindow)
            .first
        else { return false }
        return !(window.frame.width == window.screen.bounds.width)
#endif
    }

    ///
    /// Returns the safeAreaInsets of the currently displayed window
    ///
    var safeAreaInsets: UIEdgeInsets
    {
        UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
    }
}
