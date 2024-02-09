//
//  Constant.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//


import Foundation
 
enum Constant {
    
    static let MAIN_URL = "https://jsonplaceholder.typicode.com/"
    static let STORY_BOARD_MAIN = "Main"
    static let VC_HOME = "HomeVC"
    static let TVC_HOME = "HomeTVC"
    static let VC_FAVOURITE = "FavouriteVC"
    static let VC_DETAILS = "HomeDetailsVC"
    
}

enum ApiError: String, Error {
    
    //case invalidUsername    = "This username created an invalid request. Please try again."
    case invalidUrl    = "There is something wrong with api url"
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case unableToFavorite   = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}
