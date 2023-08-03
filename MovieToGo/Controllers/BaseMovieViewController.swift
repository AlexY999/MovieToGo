import UIKit

class BaseMovieViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let filmCellTag = "filmCell"
    private var selectedIndex: IndexPath? = nil
    
    let filmAPI = TMDbAPI()
    var currentPage = 1
    var movies: [Movie] = []
    var isLoadingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        loadInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(.zero, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MovieViewController {
            if let selectedIndex = selectedIndex {
                controller.movie = movies[selectedIndex.row]
            }
        }
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 4))
        tableView.tableFooterView = footer
        
        tableView.register(UINib(nibName: FilmViewCell.nibName, bundle: nil), forCellReuseIdentifier: filmCellTag)
    }
    
    private func loadInfo() {
        guard !isLoadingData else { return }
        isLoadingData = true
        loadMovies()
    }
    
    // Method to be implemented by subclasses to load specific movies
    func loadMovies() {
        
    }
}

extension BaseMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: filmCellTag, for: indexPath)  as! FilmViewCell
        let movie = movies[indexPath.row]
        tableCell.configure(with: movie)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = movies.count - 1
        if indexPath.row == lastRowIndex {
            loadInfo()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: SegueTags.goToFilmWindowTag.rawValue, sender: nil)
    }
}
