import UIKit

class HomeViewController: BaseMovieViewController {
    override func loadMovies() {
        filmAPI.getMovies(from: .popularMovies(page: currentPage)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let movies):
                self.movies.append(contentsOf: movies)
                self.currentPage += 1
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }

            DispatchQueue.main.async {
                self.isLoadingData = false
                self.tableView.reloadData()
            }
        }
    }
}
