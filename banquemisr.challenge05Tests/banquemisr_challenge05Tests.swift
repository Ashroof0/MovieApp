//
//  banquemisr_challenge05Tests.swift
//  banquemisr.challenge05Tests
//
//  Created by Enas Mohamed on 05/10/2024.
//

import XCTest
@testable import banquemisr_challenge05

class MovieViewModelIntegrationTests: XCTestCase {
    var viewModel: MovieViewModel!

    override func setUp() {
        super.setUp()
        viewModel = MovieViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchMovies() {
        let expectation = self.expectation(description: "Fetch movies from network")
        
   
        viewModel.fetchMovies(category: .nowPlaying)
        viewModel.movieloading = {
            expectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Expectation failed: \(error!)")
            }
         
            XCTAssertTrue(self.viewModel.movies.count > 0, "No movies were fetched.")
        }
    }

}
