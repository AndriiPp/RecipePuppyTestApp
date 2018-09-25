//
//  RecipePuppyTestAppUITests.swift
//  RecipePuppyTestAppUITests
//
//  Created by Pyvovarov Andrii on 30.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import XCTest

class RecipePuppyTestAppUITests: XCTestCase {
    var application: XCUIApplication!
    var searchBar: XCUIElement!
    
    override func setUp() {
        super.setUp()
        
        application = XCUIApplication()
        application.launch()
        
        searchBar = application.searchFields.element
    }
    
    func test() {
        XCTAssert(numberOfCells() == 0)
        
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Eggplant Omelet with Coriander and Caraway"].tap()
        
        let eggSubstituteMilkParsleyThymeSaltBlackPepperEggsFlourNonstickCookingSprayOnionsGarlicSaladGreensSaladGreensRedWineVinegarOliveOilGoatCheeseAlmondsStaticText = tablesQuery.staticTexts["egg substitute, milk, parsley, thyme, salt, black pepper, eggs, flour, nonstick cooking spray, onions, garlic, salad greens, salad greens, red wine vinegar, olive oil, goat cheese, almonds"]
        eggSubstituteMilkParsleyThymeSaltBlackPepperEggsFlourNonstickCookingSprayOnionsGarlicSaladGreensSaladGreensRedWineVinegarOliveOilGoatCheeseAlmondsStaticText.tap()
        app.buttons["Готово"].tap()
        eggSubstituteMilkParsleyThymeSaltBlackPepperEggsFlourNonstickCookingSprayOnionsGarlicSaladGreensSaladGreensRedWineVinegarOliveOilGoatCheeseAlmondsStaticText.tap()
        eggSubstituteMilkParsleyThymeSaltBlackPepperEggsFlourNonstickCookingSprayOnionsGarlicSaladGreensSaladGreensRedWineVinegarOliveOilGoatCheeseAlmondsStaticText.swipeDown()
        
        let enterIngredientSearchField = tablesQuery.searchFields["Enter ingredient"]
        enterIngredientSearchField.tap()
        enterIngredientSearchField.typeText("R")
        app.buttons["Search"].tap()
        app.typeText("\n")
        tablesQuery.staticTexts["flour, chicken, cayenne, vegetable oil, black pepper, rice, milk, paprika, salt, cornmeal"].tap()
        app.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        XCUIDevice.shared().orientation = .landscapeLeft
        XCUIDevice.shared().orientation = .portrait
        enterSearchCriteria("recipe")
        XCTAssert(numberOfCells() == 20)
        
        enterSearchCriteria("maggots")
        XCTAssert(numberOfCells() == 2)
    }
}

// MARK: - Helpers

extension RecipePuppyTestAppUITests {
    
    func enterSearchCriteria(_ searchCriteria: String) {
        searchBar.tap()
        
        let currentString = searchBar.value as! String // swiftlint:disable:this force_cast
        var deleteString: String = ""
        for _ in currentString.characters {
            deleteString += "\u{8}"
        }
        searchBar.typeText(deleteString)
        
        searchBar.typeText(searchCriteria)
    }
    
    func numberOfCells() -> UInt {
        return application.tables.cells.count
    }
}
