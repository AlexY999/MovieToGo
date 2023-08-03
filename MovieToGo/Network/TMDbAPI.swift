import Foundation

public struct Environment {
    enum Keys {
        static let apiURL = "API_URL"
        static let apiKey = "API_KEY"
    }

    // Get the BASE_URL
    static let apiURL: String = {
        guard let baseURLProperty = Bundle.main.object(
                forInfoDictionaryKey: Keys.apiURL
        ) as? String
        else {
            fatalError("\(Keys.apiURL) not found")
        }
        return baseURLProperty
    }()

    // Get the API_URL
    static let apiKey: String = {
        guard let apiKeyProperty = Bundle.main.object(
                forInfoDictionaryKey: Keys.apiKey
        ) as? String
        else {
            fatalError("\(Keys.apiKey) not found")
        }
        return apiKeyProperty
    }()
}

class TMDbAPI {
    enum TMDbAPIEndpoint {
        case popularMovies(page: Int)
        case topRatedMovies(page: Int)

        var baseURL: String {
            Environment.apiURL
        }

        var path: String {
            switch self {
            case .popularMovies:
                return "/movie/popular"
            case .topRatedMovies:
                return "/movie/top_rated"
            }
        }

        var apiKey: String {
            Environment.apiKey
        }

        var appLanguage: String {
            guard let preferredLanguageCode = Locale.preferredLanguages.first else {
                return "en-US" // Default to English
            }

            return preferredLanguageCode
        }

        var url: URL? {
            switch self {
            case let .popularMovies(page), let .topRatedMovies(page):
                let urlString = "\(baseURL)\(path)?api_key=\(apiKey)&language=\(appLanguage)&page=\(page)"
                return URL(string: urlString)
            }
        }
    }

    static let imagesURL = "https://image.tmdb.org/t/p/w300"

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    enum APIResult<T> {
        case success(T)
        case failure(Error)
    }

    func getMovies(from endpoint: TMDbAPIEndpoint, completion: @escaping (APIResult<[Movie]>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NSError(domain: "TMDbAPI", code: 404, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data, error == nil else {
                        completion(.failure(error ?? NSError(domain: "TMDbAPI", code: 500, userInfo: nil)))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(MovieListResponse.self, from: data)
                        completion(.success(result.results))
                    } catch {
                        completion(.failure(error))
                    }
                }
                .resume()
    }
}

struct MovieListResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Decimal

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    var posterUrl: URL? {
        guard let posterPath = posterPath,
              let encodedPath = posterPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        else {
            return nil
        }
        return URL(string: TMDbAPI.imagesURL + encodedPath)
    }

    var backdropUrl: URL? {
        guard let backdropPath = backdropPath,
              let encodedPath = backdropPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        else {
            return nil
        }
        return URL(string: TMDbAPI.imagesURL + encodedPath)
    }

    var formattedReleaseDate: String? {
        formatDate(dateString: releaseDate)
    }

    private func formatDate(dateString: String?) -> String? {
        guard let dateString = dateString,
              let date = TMDbAPI.dateFormatter.date(from: dateString)
        else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
