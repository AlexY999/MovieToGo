import Foundation
import UIKit

extension UIImageView {
    func loadImage(with url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = nil
                }
            }
        }
    }
}

extension Decimal {
    func truncate(toPlaces places: Int) -> Decimal {
        let handler = NSDecimalNumberHandler(roundingMode: .down,
                                             scale: Int16(places),
                                             raiseOnExactness: false,
                                             raiseOnOverflow: false,
                                             raiseOnUnderflow: false,
                                             raiseOnDivideByZero: false)
        
        let decimalNumber = NSDecimalNumber(decimal: self)
        let truncatedNumber = decimalNumber.rounding(accordingToBehavior: handler)
        
        return truncatedNumber.decimalValue
    }
}
