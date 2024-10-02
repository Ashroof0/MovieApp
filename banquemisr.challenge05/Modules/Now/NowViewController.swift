//
//  NowViewController.swift
//  banquemisr.challenge05
//
//  Created by Enas Mohamed on 02/10/2024.
//

import UIKit

class NowViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var NowTableView: UITableView!
    private let viewModel = MovieViewModel()
    private var loadingIndicatorView: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NetworkMonitor.shared.reset() // Reset on view load
        checkInternetConnection()
    }
    

    private func setupUI() {
        NowTableView.dataSource = self
        NowTableView.delegate = self
        setupLoadingIndicator()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        NowTableView.register(nib, forCellReuseIdentifier: "MovieCell")

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
    
    private func checkInternetConnection() {
        print("Current connection status: \(NetworkMonitor.shared.isConnected)")
        if NetworkMonitor.shared.isConnected {
            print("Fetching movies...")
            fetchMovies()
        } else {
            print("No internet connection.")
            showNoConnectionAlert()
        }
    }

    private func fetchMovies() {
        showLoadingIndicator()
        viewModel.fetchMovies(endpoint: "now_playing") { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoadingIndicator()
                
                if let errorMessage = self?.viewModel.errorMessage {
                    print("Error fetching movies: \(errorMessage)")
                    self?.showNoConnectionAlert()
                } else {
                    self?.NowTableView.reloadData()
                }
            }
        }
    }
    private func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicatorView.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicatorView.isHidden = true
            self?.activityIndicator.stopAnimating()
        }
    }


    private var isAlertPresented = false

    private func showNoConnectionAlert() {
        guard !isAlertPresented else { return }
        isAlertPresented = true

        DispatchQueue.main.async {
            guard self.isViewLoaded && self.view.window != nil else {
                print("View is not in the window hierarchy, cannot present alert.")
                self.isAlertPresented = false
                return
            }

            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.isAlertPresented = false // Reset the flag when alert is dismissed
            })
            self.present(alert, animated: true)
        }
    }
   
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120// Adjust this height based on your layout needs
    }
    


}

extension NowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.movies[indexPath.row]
        
        cell.movieName.text = movie.title
        cell.movieImageView.image = nil // Reset image view
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            viewModel.getMovieImage(posterPath: posterPath) { image in
                DispatchQueue.main.async {
                    if let visibleCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell {
                        visibleCell.movieImageView.image = image // Assign the image to the custom image view
                    }
                }
            }
        }
        
        return cell
        
    }
    
}
