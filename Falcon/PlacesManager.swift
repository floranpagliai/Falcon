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
	
	func fetchNearPlaces(withCompletionBlock: (places: [Place]) -> Void) {
		self.placesClient.currentPlaceWithCallback { (likelihoodList, error) -> Void in
			if error != nil {
				print("[\(self.dynamicType)] Error: \(error!.localizedDescription)")
				return
			}
			
			var places: [Place] = [Place]()
			for likelihood in likelihoodList!.likelihoods {
				if let likelihood = likelihood as? GMSPlaceLikelihood {
					let placeTypes = self.convertPlaceType(likelihood.place.types as! [String])
					let place = Place(
						id: likelihood.place.placeID,
						name: likelihood.place.name,
						address: likelihood.place.formattedAddress,
						type: placeTypes,
						coordinate: likelihood.place.coordinate
					)
					if place.type != PlaceType.unknow {
						places.append(place)
					}
				}
			}
			self.savePlaces(places)
			withCompletionBlock(places: places)
		}
	}
	
	func savePlaces(places: [Place]) {
		let placesRef = ref.getPathRef("places")
		for place in places {
			ref.update(placesRef, key: place.id, data: place.toAnyObject())
		}
	}
	
	func convertPlaceType(types: [String]) -> PlaceType {
		var placeType: PlaceType = PlaceType.unknow
		for type in types {
			switch type {
			case "bank":
				placeType = PlaceType.bank
				break
			case "restaurant":
				placeType = PlaceType.restaurant
				break
			case "school":
				placeType = PlaceType.school
				break
			case "store":
				placeType = PlaceType.store
				break
			default: break
				
			}
		}
		return placeType
	}
}

