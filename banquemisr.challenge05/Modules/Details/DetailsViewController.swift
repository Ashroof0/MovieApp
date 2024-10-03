//
//  DetailsViewController.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 03/10/2024.
//

import UIKit

class DetailsViewController: UIViewController {
    var viewModel = MovieDetailsViewModel()
    var movieId: Int!
    private var movie: MovieDetails!
    
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Received Movie ID: \(movieId ?? -1)") // Check the ID received
        fetchDetails()
    }


    private func fetchDetails() {
        guard let movieId = movieId else {
            showErrorAlert(message: "Movie ID is nil.")
            return
        }
        
        loadingIndicator.startAnimating()
        viewModel.fetchMovieDetails(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                switch result {
                case .success(let movieDetails):
                    self?.updateUI(with: movieDetails)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }


    private func updateUI(with movieDetails: MovieDetails) {
        titleLabel.text = movieDetails.title
        overViewLabel.text = movieDetails.overview
        revenueLabel.text = String(movieDetails.revenue)
        runtimeLabel.text = String(movieDetails.runtime) + " minutes"
        genresLabel.text = movieDetails.genres.map { $0.name }.joined(separator: "")
    
        if let posterPath = movieDetails.posterPath {
            viewModel.downloadImage(from: posterPath) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.posterImageView.image = image
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        } else {
            posterImageView.image = nil
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
