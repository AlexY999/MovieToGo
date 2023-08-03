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
