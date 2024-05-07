import XCTest
import Mockingbird
import Combine
import Foundation

@testable import PathFinderDev

final class GetLocationDataUseCaseTestCase: XCTestCase {
    var cancellableSet: Set<AnyCancellable> = []
    var getLocationDataUseCase: GetLocationDataUseCase?
    
    let locationService = mock(LocationServiceDelegate.self)
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        getLocationDataUseCase = GetLocationDataUseCase(locationService: locationService)
    }
    
    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        getLocationDataUseCase = nil
    }
    
    func test_Get_Location_Data_When_Received_Coordinates_Should_Return_Location_Data() throws {
        let expectation = self.expectation(description: "getLocationData")
        let expectedResultValue = TestMocks.locationData
        
        // Given
        given(locationService.currentLocation).willReturn(TestMocks.locationCoordinatesPublisher1.eraseToAnyPublisher())
        given(locationService.currentHeading).willReturn(TestMocks.trueNorthHeadingPublisher1.eraseToAnyPublisher())
        given(locationService.getDistance(from: TestMocks.locationCoordinates1, to: TestMocks.locationCoordinates2)).willReturn(TestMocks.distanceInMeters1)
        
        // When
        let executionResult = getLocationDataUseCase?.execute(with: TestMocks.locationCoordinates2)
        
        // Then
        executionResult?
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { locationData in
                XCTAssertEqual(expectedResultValue, locationData)
                expectation.fulfill()
            }.store(in: &cancellableSet)
        
        wait(for: [expectation], timeout: 10)
    }
    
}
