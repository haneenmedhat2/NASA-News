//
//  NASANewsTests.swift
//  NASANewsTests
//
//  Created by Haneen Medhat on 15/10/2024.
//

import XCTest
@testable import NASANews

class NASANewsTests: XCTestCase {
    var sut : ViewController?
 
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        sut?.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_whenInstanciate_thenSUTIsInitialized() throws{
        sut = try  XCTUnwrap(sut,"System under test is nil")
    }
    
    func test_whenViewDidLoad_thenCollectionViewDataSourceIsSet(){
        XCTAssertNotNil(sut?.collectionView.dataSource, "DataSource should not be nil")
    }
    
    func test_whenViewDidLoad_thenCollectionViewDelegateIsSet(){
        XCTAssertNotNil(sut?.collectionView.delegate, "Delegate should not be nil")
    }
    
    func test_whenViewDidLoad_thenNewsIsEmpty(){
        XCTAssertEqual(sut?.news, [],"News array should be empty")
    }

    func test_whenViewLoaded_thenCollectionViewNumOfRowsEqualsToNewsCount(){
        XCTAssertEqual(sut?.collectionView.numberOfItems(inSection: 0), sut?.news.count)
    }
    
    func test_whenNewsIsSet_thenCollectionViewRowsAreUpdated(){
        let expectation = expectation(description: " wait for network request to get news")
        
        sut?.loadedApiData = {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(sut?.news.count, 20)
        XCTAssertEqual(sut?.collectionView.numberOfItems(inSection: 0), 20)
    }
    
    func test_whenNewsIsSet_thenCellIsAffected() throws{
        let expectation = expectation(description: "wait for network request to get news")
        
        sut?.loadedApiData = {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        sut?.collectionView.layoutIfNeeded()
        
        let cell = try XCTUnwrap(sut?.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? NewsCell, "News Cell should not be nil")
        let item = sut?.news[0]
        XCTAssertEqual(cell.newsLabel.text, item?.title)
        
        
    }
 
}
