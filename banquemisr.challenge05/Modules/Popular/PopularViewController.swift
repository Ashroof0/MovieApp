//
//  PopularViewController.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 03/10/2024.
//

import UIKit

class PopularViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var popularTableView: UITableView!
    private let viewModel = MovieViewModel()
    private var loadingIndicatorView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    private var isAlertPresented = false
    private var selectedIndexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.startNetworkMonitoring(endPoint: .popular)
    }

   

    private func setupUI() {
        popularTableView.dataSource = self
        popularTableView.delegate = self
        setupLoadingIndicator()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        popularTableView.register(nib, forCellReuseIdentifier: "MovieCell")

        // Bind view model
        viewModel.movieloading = { [weak self] in
            DispatchQueue.main.async {
                self?.popularTableView.reloadData()
                self?.hideLoadingIndicator()
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.hideLoadingIndicator()
                self?.showNoConnectionAlert(message: errorMessage)
            }
        }
    }

    private func fetchMovies() {
        showLoadingIndicator()

    }

    private func setupLoadingIndicator() {
        loadingIndicatorView = UIView(frame: view.bounds)
        loadingIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingIndicatorView.center
        loadingIndicatorView.addSubview(activityIndicator)

        loadingIndicatorView.isHidden = true
        view.addSubview(loadingIndicatorView)
    }

    private func showLoadingIndicator() {
        loadingIndicatorView.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        loadingIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }

    private func showNoConnectionAlert(message: String) {
        guard !isAlertPresented else { return }
        isAlertPresented = true

        let alert = UIAlertController(title: "Connection Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.isAlertPresented = false
        })
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        
        performSegue(withIdentifier: "ShowDetails", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails",
           let destinationVC = segue.destination as? DetailsViewController {
            
            let selectedMovie = viewModel.movies[selectedIndexPath.row]
            destinationVC.movieId = selectedMovie.id
            
            print("Selected Movie ID: \(selectedMovie.id)")
        }
    }

}

extension PopularViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.movies[indexPath.row]
        
        cell.movieName.text = movie.title
        cell.movieImageView.image = nil

        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            viewModel.getMovieImage(posterPath: posterPath) { image in
                DispatchQueue.main.async {
                    if let visibleCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                        visibleCell.movieImageView.image = image
                    }
                }
            }
        }

        return cell
    }
}
