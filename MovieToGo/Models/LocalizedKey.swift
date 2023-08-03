import Foundation

enum LocalizedKey: String {
    case welcome = "Welcome"
    case release = "Release"
    case description = "Description"
    case playMovie = "Play Movie"
    case playMovieConfirmation = "Do you want to play {movieName}?"
    case cancel = "Cancel"
    case play = "Play"
}

enum LocalizedChangeKeys: String {
    case movieName = "{movieName}"
}

extension RawRepresentable where RawValue == String {
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
