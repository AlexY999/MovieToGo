import UIKit

class FilmViewCell: UITableViewCell {
    
    static let nibName = "FilmViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        if let posterURL = movie.posterUrl {
            posterImageView.loadImage(with: posterURL)
            posterImageView.contentMode = .scaleAspectFill
        } else {
            posterImageView.image = nil
        }
        
        posterImageView.layer.cornerRadius = 8
        posterBg.layer.cornerRadius = 12
        
        if let releaseDate = movie.formattedReleaseDate {
            releaseLabel.text = "\(LocalizedKey.release.localized): \(releaseDate)"
        } else {
            releaseLabel.text = nil
        }
    }
}
