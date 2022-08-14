import XCTest
import ComposableArchitecture

@testable import MoviesListFeature

final class MoviesListFeatureTests: XCTestCase {
    
    func testShouldChangeState_whenNewPageSelected() throws {
        let store = TestStore(
            initialState: .init(),
            reducer: moviesListFeatureReducer,
            environment: .mock
        )
        
        store.send(.set(\.$currentTab, .favoriteMovies)) {
            $0.currentTab = .favoriteMovies
        }
        
        store.send(.set(\.$currentTab, .moviesList)) {
            $0.currentTab = .moviesList
        }
    }
}
