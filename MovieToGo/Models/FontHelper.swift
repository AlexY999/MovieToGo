import Foundation
import UIKit

class FontHelper {
    enum AppFont: String {
        case semiBold = "Raleway-SemiBold"
        case regular = "Raleway-Regular"
        case bold = "Raleway-Bold"

        func withSize(_ size: CGFloat) -> UIFont {
            UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }

    static func attributedStringWithCustomFont(for text: String, targetWord: String, customFont: AppFont, size: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: targetWord)
        attributedString.addAttribute(.font, value: customFont.withSize(size), range: range)
        return attributedString
    }
}
