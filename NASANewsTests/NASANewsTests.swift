//
//  NASANewsTests.swift
//  NASANewsTests
//
//  Created by Haneen Medhat on 15/10/2024.
//

import XCTest
@testable import NASANews

class NASANewsTests: XCTestCase {

    private func makeSUT(networkServicePro:NetworkServiceProtocol = NetworkServiceLoader()) -> ViewController{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sut = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        sut.networkServicePro = networkServicePro
        sut.loadViewIfNeeded()
        return sut
    }
    
    func test_whenInstanciate_thenSUTIsInitialized() throws{
        var sut = makeSUT()
        sut = try  XCTUnwrap(sut,"System under test is nil")
    }
    
    func test_whenViewDidLoad_thenCollectionViewDataSourceIsSet(){
        let sut = makeSUT()
        XCTAssertNotNil(sut.collectionView.dataSource, "DataSource should not be nil")
    }
    
    func test_whenViewDidLoad_thenCollectionViewDelegateIsSet(){
        let sut = makeSUT()
        XCTAssertNotNil(sut.collectionView.delegate, "Delegate should not be nil")
    }
    
    func test_whenViewDidLoad_thenNewsIsEmpty(){
        let sut = makeSUT()
        XCTAssertEqual(sut.news, [],"News array should be empty")
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), sut.news.count)
    }

    func test_whenViewLoaded_thenFetchDataCalledOnlyOnce(){
        let spy = NetworkServiceSpy()
        let _ = makeSUT(networkServicePro: spy)
        XCTAssertEqual(spy.state, [.fetchData] )
    }
    
    func test_whenViewLoadedWithEmptyNews_thenShowEmptyTable(){
        let spy = NetworkServiceSpy(result: .success([]))
        let sut = makeSUT(networkServicePro: spy)
        
        XCTAssertEqual(sut.news, [])
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    func test_whenviewLoadedWithNews_thenRenderCells(){
        let news = getNews()
        let spy = NetworkServiceSpy(result: .success(news))
        let sut = makeSUT(networkServicePro: spy)
        
        XCTAssertEqual(sut.news, news)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), news.count)
    }
    
    func test_whenViewLoadedWithError_thenShowEmptyTable(){
        let spy = NetworkServiceSpy(result: .failure(NSError(domain: "AnyError", code: 0)))
        let sut = makeSUT(networkServicePro: spy)
        
        XCTAssertEqual(sut.news, [])
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    func test_whenViewLoadedWithNews_thenRenderCells(){
        let news = getNews()
        let spy = NetworkServiceSpy(result: .success(news))
        let sut = makeSUT(networkServicePro: spy)

        sut.collectionView.layoutIfNeeded()
        
        for (index,_) in news.enumerated(){
            
            let cell = sut.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? NewsCell
            XCTAssertEqual(cell?.newsLabel.text, news[index].title)
            XCTAssertEqual(cell?.newsImage.sd_imageURL?.absoluteString, news[index].image ?? "empty")
        }
     
    }
    
    func test_whenImageURLIsNil_thenShowPlaceHolder(){
        let news = [NewsInfo(author: "Haneen", title: "Book", description: "This is my book", image: nil, date: "3 pf dec")]
        let spy = NetworkServiceSpy(result: .success(news))
        let sut = makeSUT(networkServicePro: spy)
        sut.collectionView.layoutIfNeeded()

        let cell = sut.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NewsCell
        XCTAssertEqual(cell?.newsImage.image, UIImage(named: "loading"))
    }
    
    func test_whenDidSelectItem_thenPushDetailsViewController(){
        let news = getNews()
        let spy = NetworkServiceSpy(result: .success(news))
        let sut = makeSUT(networkServicePro: spy)

        let navigationController = UINavigationController(rootViewController: sut)

          sut.collectionView.layoutIfNeeded()

          sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        //Wait seconds until the vc is pushed to the navCont
        RunLoop.current.run(until: Date() + 0.1)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2, "Expected NewsDetailsController to be pushed, but it wasn't")
            
        let detailsVC = navigationController.topViewController as? NewsDetailsController
        XCTAssertNotNil(detailsVC)
        
        XCTAssertEqual(detailsVC?.news, news[0])
        
    }
    
    func getNews() -> [NewsInfo]{
        return [NewsInfo(author: "Haneen", title: "My book", description: "This is my book", image: "url", date: "3 of june"), NewsInfo(author: "Medhat", title: "Swift documentation", description: "Swift", image: "swiftUrl", date: "4 of june")]
    }
    
}
    
    class NetworkServiceSpy : NetworkServiceProtocol{
        enum State {
            case fetchData
            case storeData
        }
        private (set) var state : [State] = []
        private let result : Result<[NewsInfo],Error>
        
        init(result:Result<[NewsInfo],Error> = .success([])){
            self.result = result
        }
        
        func fetchData(completion: @escaping (Result<[NewsInfo], Error>) -> ()) {
            state.append(.fetchData)
            completion(result)
        }
    }


