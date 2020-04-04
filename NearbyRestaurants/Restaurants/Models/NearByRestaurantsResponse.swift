//
//  NearByRestaurantsResponse.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

// MARK: - NearByRestaurantsResponse
struct NearByRestaurantsResponse: Codable {
    let resultsFound, resultsStart, resultsShown: Int?
    let restaurants: [RestaurantElement]?
    
    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants
    }
}

// MARK: - RestaurantElement
struct RestaurantElement: Codable {
    let restaurant: RestaurantRestaurant?
}

extension RestaurantElement: ViewBindableProtocol {
    func getTitle() -> String {
        return self.restaurant?.name ?? ""
    }
    
    func getSubtitle() -> String {
        return self.restaurant?.location?.address ?? ""
    }
    
    func getSubText() -> String? {
        var txt = ""
        if let cu = self.restaurant?.cuisines {
            txt = "Cuisines: \(cu)"
        }
        if let tm = self.restaurant?.timings {
            txt += "\nTimings: \(tm)"
        }
        return txt
    }
    
    func getRating() -> String? {
        if let rate = self.restaurant?.userRating?.aggregateRating?.stringValue, let double = Double(rate), double > 0 {
            return rate
        }
        return nil
    }
    
    func getImageUrl() -> String? {
        if let link = self.restaurant?.thumb {
            return link
        }
        return nil
    }
}

// MARK: - RestaurantRestaurant
struct RestaurantRestaurant: Codable {
    let r: R?
    let apikey, id, name: String?
    let url: String?
    let location: Location?
    let switchToOrderMenu: Int?
    let cuisines, timings: String?
    let averageCostForTwo, priceRange: Int?
    let currency: String?
    let highlights: [String]?
    let opentableSupport, isZomatoBookRes: Int?
    let mezzoProvider: String?
    let isBookFormWebView: Int?
    let bookFormWebViewURL, bookAgainURL, thumb: String?
    let userRating: UserRating?
    let allReviewsCount: Int?
    let photosURL: String?
    let photoCount: Int?
    let menuURL: String?
    let featuredImage: String?
    let hasOnlineDelivery, isDeliveringNow: Int?
    let storeType: String?
    let includeBogoOffers: Bool?
    let deeplink: String?
    let isTableReservationSupported, hasTableBooking: Int?
    let eventsURL: String?
    let phoneNumbers: String?
    let allReviews: AllReviews?
    let establishment: [String]?
    
    enum CodingKeys: String, CodingKey {
        case r = "R"
        case apikey, id, name, url, location
        case switchToOrderMenu = "switch_to_order_menu"
        case cuisines, timings
        case averageCostForTwo = "average_cost_for_two"
        case priceRange = "price_range"
        case currency, highlights
        case opentableSupport = "opentable_support"
        case isZomatoBookRes = "is_zomato_book_res"
        case mezzoProvider = "mezzo_provider"
        case isBookFormWebView = "is_book_form_web_view"
        case bookFormWebViewURL = "book_form_web_view_url"
        case bookAgainURL = "book_again_url"
        case thumb
        case userRating = "user_rating"
        case allReviewsCount = "all_reviews_count"
        case photosURL = "photos_url"
        case photoCount = "photo_count"
        case menuURL = "menu_url"
        case featuredImage = "featured_image"
        case hasOnlineDelivery = "has_online_delivery"
        case isDeliveringNow = "is_delivering_now"
        case storeType = "store_type"
        case includeBogoOffers = "include_bogo_offers"
        case deeplink
        case isTableReservationSupported = "is_table_reservation_supported"
        case hasTableBooking = "has_table_booking"
        case eventsURL = "events_url"
        case phoneNumbers = "phone_numbers"
        case allReviews = "all_reviews"
        case establishment
    }
}

// MARK: - AllReviews
struct AllReviews: Codable {
    let reviews: [Review]?
}

// MARK: - Review
struct Review: Codable {
    //let review: [Any]?
}

// MARK: - Location
struct Location: Codable {
    let address, locality, city: String
    let cityID: Int
    let latitude, longitude, zipcode: String
    let countryID: Int
    let localityVerbose: String
    
    enum CodingKeys: String, CodingKey {
        case address, locality, city
        case cityID = "city_id"
        case latitude, longitude, zipcode
        case countryID = "country_id"
        case localityVerbose = "locality_verbose"
    }
}

// MARK: - R
struct R: Codable {
    let hasMenuStatus: HasMenuStatus
    let resID: Int
    
    enum CodingKeys: String, CodingKey {
        case hasMenuStatus = "has_menu_status"
        case resID = "res_id"
    }
}

// MARK: - HasMenuStatus
struct HasMenuStatus: Codable {
    let delivery, takeaway: Int
}

// MARK: - UserRating
struct UserRating: Codable {
    let ratingText, ratingColor: String?
    let aggregateRating: QuantumValue?
    let ratingObj: RatingObj?
    //let votes: String?
    
    enum CodingKeys: String, CodingKey {
        case aggregateRating = "aggregate_rating"
        case ratingText = "rating_text"
        case ratingColor = "rating_color"
        case ratingObj = "rating_obj"
        //case votes
    }
}

// MARK: - RatingObj
struct RatingObj: Codable {
    let title: Title?
    let bgColor: BgColor?
    
    enum CodingKeys: String, CodingKey {
        case title
        case bgColor = "bg_color"
    }
}

// MARK: - BgColor
struct BgColor: Codable {
    let type, tint: String?
}

// MARK: - Title
struct Title: Codable {
    let text: String?
}


enum QuantumValue: Codable {
    func encode(to encoder: Encoder) throws {
    }
    
    case int(Int), string(String), double(Double)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        throw QuantumError.missingValue
    }
    
    enum QuantumError:Error {
        case missingValue
    }
}

extension QuantumValue {
    
    var stringValue: String? {
        switch self {
        case .int(let value): return String(value)
        case .string(let value): return value
        case .double(let value): return String(value)
        }
    }
}
