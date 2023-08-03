import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!

    var movie: Movie? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.configure(onBackButtonClick: onBackButtonClick)

        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        setMovie()
    }

    private func setMovie() {
        guard let movie = movie else {
            return
        }

        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        voteAverage.text = "\(movie.voteAverage)"
        if let backdropUrl = movie.backdropUrl {
            backdropImageView.loadImage(with: backdropUrl)
            backdropImageView.contentMode = .scaleAspectFill
        } else {
            backdropImageView.image = nil
        }

        backdropImageView.layer.cornerRadius = 8

        if let releaseDate = movie.formattedReleaseDate {
            releaseLabel.text = "\(LocalizedKey.release.localized): \(releaseDate)"
        } else {
            releaseLabel.text = nil
        }
    }

    private func onBackButtonClick() {
        navigationController?.popViewController(animated: true)
    }

    private func showAlertWithMovieName() {
        guard let movieName = movie?.title else {
            return
        }

        let title = LocalizedKey.playMovie.localized
        let message = String(format: LocalizedKey.playMovieConfirmation.localized, movieName)

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedKey.cancel.localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedKey.play.localized, style: .default, handler: { _ in
            print("\(movieName)")
        }))

        present(alert, animated: true, completion: nil)
    }

    @IBAction func onPlayButtonClick(_ sender: Any) {
        showAlertWithMovieName()
    }
}
