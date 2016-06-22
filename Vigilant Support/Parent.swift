//
//  Parent.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/22/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit


/**
 Define the state of a cell
 
 - Collapsed: Cell collapsed
 - Expanded:  Cell expanded
 */
enum State {
    case Collapsed
    case Expanded
}

/**
 Enum to define the number of cell expanded at time
 
 - One:     One cell expanded at time.
 - Several: Several cells expanded at time.
 */
enum NumberOfCellExpanded {
    case One
    case Several
}

/**
 *  The Parent struct of the data source.
 */
struct Parent {
    
    /// State of the cell
    var state: State
    
    /// The childs of the cell
    var childs: [Person]
    
    /// The title for the cell.
    var title: String
}

/**
 Overload for the operator != for tuples
 
 - parameter lhs: The first tuple to compare
 - parameter rhs: The seconde tuple to compare
 
 - returns: true if there are different, otherwise false
 */
func != (lhs: (Int, Int), rhs: (Int, Int)) -> Bool {
    return lhs.0 != rhs.0 && rhs.1 != lhs.1
}