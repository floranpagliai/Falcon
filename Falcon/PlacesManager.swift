//
//  PlacesManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 18/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import GoogleMaps

class PlacesManager {
	
	// MARK: Properties
	let placesClient = GMSPlacesClient()
	let ref = FirebaseManager()
	
	func fetchNearPlaces() {
		self.placesClient.currentPlaceWithCallback { (likelihoodList, error) -> Void in
			if error != nil {
				print("[\(self.dynamicType)] Error: \(error!.localizedDescription)")
				return
			}
			
			for likelihood in likelihoodList!.likelihoods {
				if let likelihood = likelihood as? GMSPlaceLikelihood {
					let placeTypes = self.convertPlaceType(likelihood.place.types as! [String])
					let place = Place(
						id: likelihood.place.placeID,
						name: likelihood.place.name,
						address: likelihood.place.formattedAddress,
						types: placeTypes,
						coordinate: likelihood.place.coordinate
					)
					self.ref.append("places", key: place.id, data: place.toAnyObject())
				}
			}
		}
	}
	
	func convertPlaceType(types: [String]) -> [PlaceType] {
		var placeTypes: [PlaceType] = [PlaceType]()
		for type in types {
			switch type {
			case "bank":
				placeTypes.append(PlaceType.bank)
			case "restaurant":
				placeTypes.append(PlaceType.restaurant)
			case "school":
				placeTypes.append(PlaceType.school)
			case "store":
				placeTypes.append(PlaceType.store)
			default:
				print("ConvertPlaceType : No type found")
			}
		}
		return placeTypes
	}
}

//accounting
//airport
//amusement_park
//aquarium
//art_gallery
//atm
//bakery
//bank
//bar
//beauty_salon
//bicycle_store
//book_store
//bowling_alley
//bus_station
//cafe
//campground
//car_dealer
//car_rental
//car_repair
//car_wash
//casino
//cemetery
//church
//city_hall
//clothing_store
//convenience_store
//courthouse
//dentist
//department_store
//doctor
//electrician
//electronics_store
//embassy
//establishment (deprecated)
//finance (deprecated)
//fire_station
//florist
//food (deprecated)
//funeral_home
//furniture_store
//gas_station
//general_contractor (deprecated)
//grocery_or_supermarket
//gym
//hair_care
//hardware_store
//health (deprecated)
//hindu_temple
//home_goods_store
//hospital
//insurance_agency
//jewelry_store
//laundry
//lawyer
//library
//liquor_store
//local_government_office
//locksmith
//lodging
//meal_delivery
//meal_takeaway
//mosque
//movie_rental
//movie_theater
//moving_company
//museum
//night_club
//painter
//park
//parking
//pet_store
//pharmacy
//physiotherapist
//place_of_worship (deprecated)
//plumber
//police
//post_office
//real_estate_agency
//restaurant
//roofing_contractor
//rv_park
//school
//shoe_store
//shopping_mall
//spa
//stadium
//storage
//store
//subway_station
//synagogue
//taxi_stand
//train_station
//travel_agency
//university
//veterinary_care
//zoo

