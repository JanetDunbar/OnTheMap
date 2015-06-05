//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/3/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.


import Foundation

//  TODO: init
struct StudentInformation{
    //var createdAt:  String
    var uniqueKey : String = ""
    var firstName : String = ""
    var lastName  : String = ""
    var mapString : String = ""
    var mediaURL  : String = ""
    var latitude  : Double  = 0
    var longitude : Double  = 0
    var objectId  : String = ""
    //var coord: (Double, Double)
    var updatedAt:  String?


    // TODO:  !!!!Create a StudentInformation struct from a dictionary
    init(dictionary: [String : AnyObject]) {
        //Iterate through the keys in dictionary to initialize each property in StudentInformation

        for (key, value) in dictionary{
            
            switch (key) {
                case "uniqueKey":
                    self.uniqueKey = value as! String
                    break;
                case "firstName":
                    self.firstName = value as! String
                    break;
                case "lastName":
                    self.lastName =  value as! String
                    break;
                case "mapString":
                    self.mapString = value as! String
                    break;
                case "mediaURL":
                    self.mediaURL =  value as! String
                    break;
                case "latitude":
                    self.latitude =  value as! Double
                    break;
                case "longitude":
                    self.longitude = value as! Double
                    break;
                case "objectId":
                    self.objectId = value as! String
                    break;
                case "updatedAt":
                    self.updatedAt =  value as! String
                    break;
                
                default:
                break;
            }
        }
    }
    
    static func studentInformationFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {   
        var students = [StudentInformation]()
        
        for result in results {
            students.append( StudentInformation(dictionary: result) )
        }
        
        return students
        
    }
}