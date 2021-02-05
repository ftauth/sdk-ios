//
//  TestKeystore.swift
//  FTAuth-Unit-Tests
//
//  Created by Dillon Nys on 2/5/21.
//

import XCTest
import FTAuth

class TestKeystore: XCTestCase {
    private let keystore = Keystore()
    private let key = "key".data(using: .utf8)!
    private let value = "value".data(using: .utf8)!
    
    override func setUpWithError() throws {
        try keystore.clear()
    }

    func testGet() throws {
        XCTAssertThrowsError(try keystore.get(key))
        try keystore.save(key, value: value)
        XCTAssertEqual(value, try keystore.get(key))
    }
    
    func testSave() throws {
        let anotherKey = "another_key".data(using: .utf8)!
        let anotherValue = "another_value".data(using: .utf8)!
        
        try keystore.save(key, value: value)
        try keystore.save(anotherKey, value: anotherValue)
        XCTAssertEqual(value, try keystore.get(key))
        XCTAssertEqual(anotherValue, try keystore.get(anotherKey))
    }
    
    func testUpdate() throws {
        let anotherValue = "another_value".data(using: .utf8)!
        
        try keystore.save(key, value: value)
        XCTAssertEqual(value, try keystore.get(key))
        
        try keystore.save(key, value: anotherValue)
        XCTAssertEqual(anotherValue, try keystore.get(key))
    }
    
    func testDelete() throws {
        try keystore.save(key, value: value)
        XCTAssertEqual(value, try keystore.get(key))
        
        try keystore.delete(key)
        XCTAssertThrowsError(try keystore.get(key))
    }
    
    func testClear() throws {
        let anotherKey = "another_key".data(using: .utf8)!
        let anotherValue = "another_value".data(using: .utf8)!
        let aThirdKey = "a_third_key".data(using: .utf8)!
        let aThirdValue = "a_third_value".data(using: .utf8)!
        
        try keystore.save(key, value: value)
        try keystore.save(anotherKey, value: anotherValue)
        try keystore.save(aThirdKey, value: aThirdValue)
        
        XCTAssertEqual(value, try keystore.get(key))
        XCTAssertEqual(anotherValue, try keystore.get(anotherKey))
        XCTAssertEqual(aThirdValue, try keystore.get(aThirdKey))
        
        try keystore.clear()
        
        XCTAssertThrowsError(try keystore.get(key))
        XCTAssertThrowsError(try keystore.get(anotherKey))
        XCTAssertThrowsError(try keystore.get(aThirdKey))
    }
}
