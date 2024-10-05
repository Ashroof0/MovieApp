//
//  NetworkTesting.swift
//  banquemisr.challenge05Tests
//
//  Created by Enas Mohamed on 05/10/2024.
//


import XCTest
@testable import banquemisr_challenge05 // Replace with your app's module name

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService.shared
    }
    
    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    func testFetchDataReturnsMoviesList() {
        let expectation = self.expectation(description: "Fetch Movies List")
        
        networkService.fetchData(endpoint: "popular", model: MoviesList.self) { result in
            switch result {
            case .success(let moviesList):
                XCTAssertNotNil(moviesList)
                XCTAssertTrue(moviesList.results.count > 0, "Movies list should not be empty")
            case .failure(let error):
                XCTFail("Failed to fetch movies: \(error.rawValue)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }
    

    
}
