import XCTest

class ChatFirebase_TypeAUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testExample() {
//        
//        
//    let app = XCUIApplIcation()
//        
//    XCTAssertEqual(app.tables.count, 1)
//    XCTAssertEqual(app.buttons.count, 1)
//        
//    let table = app.tables.elementBoundayIndex(0) XCTAssertEqual(table.cells.count, 0)
//        
//    app.buttons("How many button taps"].tap()
//        app.tables.staticTexts["How many rows"].swipeUp()
//        
//    XCTAssertEqual(table.cells.count, 3)
//    }
}
