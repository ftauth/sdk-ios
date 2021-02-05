//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Dillon Nys on 2/5/21.
//

import XCTest
@testable import FTAuth

class ExampleUITests: XCTestCase {
    
    private let client = FTAuthClient.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        let webView = app.webViews.firstMatch
        
        let submitButton = webView.buttons["Login"]
        XCTAssert(submitButton.waitForExistence(timeout: 20))
        
        let usernameInput = webView.textFields.firstMatch
        let passwordInput = webView.secureTextFields.firstMatch
        XCTAssert(usernameInput.waitForExistence(timeout: 1))
        XCTAssert(passwordInput.waitForExistence(timeout: 1))
        
        // In the Simulator, make sure 'Hardware -> Keyboard -> Connect hardware keyboard' is off.
        // defaults write com.apple.iphonesimulator ConnectHardwareKeyboard 0
        usernameInput.tap()
        usernameInput.typeText("admin")
        
        passwordInput.tap()
        passwordInput.typeText("password")
        submitButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
