import MapboxGeocoder


let geocoder = Geocoder.shared

// main.swift
#if !os(tvOS)
    import Contacts
#endif

let options = ForwardGeocodeOptions(query: "200 queen street")

// To refine the search, you can set various properties on the options object.
options.allowedISOCountryCodes = ["CA"]
options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
options.allowedScopes = [.address, .pointOfInterest]

let task = geocoder.geocode(options) { (placemarks, attribution, error) in
    guard let placemark = placemarks?.first else {
        return
    }
    
    print(placemark.name)
    // 200 Queen St
    print(placemark.qualifiedName)
    // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada
    
    let coordinate = placemark.location.coordinate
    print("\(coordinate.latitude), \(coordinate.longitude)")
    // 45.270093, -66.050985
    
    #if !os(tvOS)
        let formatter = CNPostalAddressFormatter()
        print(formatter.string(from: placemark.postalAddress!))
        // 200 Queen St
        // Saint John New Brunswick E2L 2X1
        // Canada
    #endif
}
