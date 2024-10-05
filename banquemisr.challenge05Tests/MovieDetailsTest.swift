//
//  MovieDetailsTest.swift
//  banquemisr.challenge05Tests
//
//  Created by Enas Mohamed on 05/10/2024.
//

import XCTest
@testable import banquemisr_challenge05 

class MovieDetailsViewModelTests: XCTestCase {
    var viewModel: MovieDetailsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = MovieDetailsViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchMovieDetailsSuccess() {
        let expectation = XCTestExpectation(description: "Fetch movie details successfully")

        viewModel.fetchMovieDetails(movieId: 550) { result in
            switch result {
            case .success(let details):
                XCTAssertNotNil(details, "Expected movie details to be populated")
                XCTAssertEqual(details.id, 550, "Expected movie ID to match")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.rawValue)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchMovieDetailsFailure() {
        let expectation = XCTestExpectation(description: "Fetch movie details should fail")

        viewModel.fetchMovieDetails(movieId: -1) { result in 
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected an error message")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
