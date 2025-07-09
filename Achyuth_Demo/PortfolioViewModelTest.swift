//
//  PortfolioViewModelTestsOne.swift
//  Achyuth_DemoTests
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

//import XCTest
//@testable import Achyuth_Demo
//
//@MainActor
//final class PortfolioViewModelTest: XCTestCase {
//    var sut: PortfolioViewModel!
//    var mockUseCase: MockPortfolioUseCase!
//    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
//    func testLoadPortfolioDataSuccess() async {
//        // Given
//        let mockHoldings = [
//            HoldingViewModel(symbol: "AAPL", quantity: 10, ltp: 150.0, pnl: 100.0)
//        ]
//        let mockSummary = PortfolioSummary(
//            currentValue: 1500.0,
//            totalInvestment: 1400.0,
//            totalPNL: 100.0,
//            todaysPNL: 50.0
//        )
//        mockUseCase.dataToReturn = (mockHoldings, mockSummary)
//        
//        // When
//        await sut.loadPortfolioData()
//        
//        // Then
//        XCTAssertEqual(sut.holdings.count, 1)
//        XCTAssertEqual(sut.holdings[0].symbol, "AAPL")
//        XCTAssertNotNil(sut.portfolioSummary)
//        XCTAssertFalse(sut.isLoading)
//        XCTAssertNil(sut.errorMessage)
//    }
//    
//    func testLoadPortfolioDataFailure() async {
//        // Given
//        mockUseCase.shouldThrowError = true
//        
//        // When
//        await sut.loadPortfolioData()
//        
//        // Then
//        XCTAssertTrue(sut.holdings.isEmpty)
//        XCTAssertNil(sut.portfolioSummary)
//        XCTAssertFalse(sut.isLoading)
//        XCTAssertNotNil(sut.errorMessage)
//    }
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
