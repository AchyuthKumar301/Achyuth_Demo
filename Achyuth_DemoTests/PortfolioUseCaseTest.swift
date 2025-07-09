//
//  PortfolioUseCaseTest.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//


import XCTest
@testable import Achyuth_Demo

@MainActor
final class PortfolioUseCaseTest: XCTestCase {
    var sut: PortfolioUseCase!
    var mockRepository: MockPortfolioRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPortfolioRepository()
        sut = PortfolioUseCase(repository: mockRepository)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testGetPortfolioDataSuccess() async throws {
        // Given
        let mockHoldings = [
            Holding(symbol: "AAPL", quantity: 10, ltp: 150.0, avgPrice: 140.0, close: 149.0),
            Holding(symbol: "GOOGL", quantity: 5, ltp: 2500.0, avgPrice: 2400.0, close: 2480.0)
        ]
        mockRepository.holdingsToReturn = mockHoldings
        
        // When
        let (holdings, summary) = try await sut.getPortfolioData()
        
        // Then
        XCTAssertEqual(holdings.count, 2)
        XCTAssertEqual(holdings[0].symbol, "AAPL")
        XCTAssertEqual(summary.currentValue, 14000.0) // (150*10) + (2500*5)
        XCTAssertEqual(summary.totalInvestment, 13400.0) // (140*10) + (2400*5)
        XCTAssertEqual(summary.totalPNL, 600.0) // 14000 - 13400
    }
    
    func testGetPortfolioDataFailure() async {
        // Given
        mockRepository.shouldThrowError = true
        
        // When/Then
        do {
            _ = try await sut.getPortfolioData()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
