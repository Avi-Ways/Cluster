//
//  Toll.swift
//
//  Created by Vivan Raghuvanshi on 23/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Toll {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let tollId = "TollId"
        static let name = "Name"
        static let latitude = "Latitude"
        static let longitude = "Longitude"
    }
    
    // MARK: Properties
    public var tollId: Int?
    public var name: String?
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        name = json[SerializationKeys.name].string
        tollId = json[SerializationKeys.tollId].int
        latitude = Double("\(json[SerializationKeys.latitude])") ?? 0.0
        longitude = Double("\(json[SerializationKeys.longitude])") ?? 0.0
    }
    
}
