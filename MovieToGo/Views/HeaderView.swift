import UIKit

class HeaderView: UIView {
    @IBOutlet weak var windowLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    private var onBack: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        guard let contentView = loadViewFromNib() else {
            return
        }

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = "HeaderView"
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func configure(onBackButtonClick: (() -> Void)? = nil) {
        guard let onBackButtonClick = onBackButtonClick else {
            backButton.isHidden = true
            return
        }

        backButton.isHidden = false
        onBack = onBackButtonClick
    }

    @IBAction func onExitButtonClick(_ sender: Any) {
        onBack?()
    }
}
