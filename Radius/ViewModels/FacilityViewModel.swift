//
//  FacilityViewModel.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import Foundation



final class FacilityViewModel {
    private var facilityResponse: FacilityResponse?

    var numberOfFacilities: Int {
        return getAllFacility.count
    }
    
    func getFacilityOption(index: Int, section: Int) -> Options? {
        if numberOfFacilities > section, let options = getFacility(at: section)?.options, options.count > index {
            return options[index]
        } else {
            return nil
        }
    }
    
    func numberOfFacilityOptions(at section: Int) -> Int {
        guard numberOfFacilities > section else {
            return 0
        }
        return facilityResponse?.facilities?[section].options?.count ?? 0
    }

    func getFacility(at section: Int) -> Facility? {
        guard numberOfFacilities > section else {
            return nil
        }
        return facilityResponse?.facilities?[section]
    }
    
    func getFacilityId(at section: Int) -> String? {
        guard numberOfFacilities > section else {
            return nil
        }
        return facilityResponse?.facilities?[section].facility_id
    }
    
    private var getAllFacility: [Facility] {
        return facilityResponse?.facilities ?? []
    }
    
    func updateOption(at section: Int, at index: Int, optionToUpdate: Options) {
        if numberOfFacilities > section, numberOfFacilityOptions(at: section) > index {
            facilityResponse?.facilities?[section].options?[index] = optionToUpdate
        }
    }
    
    private func getExclusionIds(faciltyId: String, optionId: String) -> [(String?, String?)] {
        var exclusionsIds: [(String?,String?)] = []
        if let excl = facilityResponse?.exclusions {
            for item in excl {
                if item[1].facility_id == faciltyId && item[1].options_id == optionId {
                    exclusionsIds.append((item[0].facility_id, item[0].options_id))
                }
            }
        }
        return exclusionsIds
    }
    
    private func getFaciltyWithId(faciltyId: String) -> Facility? {
        for item in getAllFacility {
            if item.facility_id == faciltyId {
                return item
            }
        }
        return nil
    }
    
    func isNotAllowedToSelect(faciltyId: String, optionId: String) -> Bool {
        
        let exclusionIds: [(String?, String?)] = getExclusionIds(faciltyId: faciltyId, optionId: optionId)
        
        
        for exclusionId in exclusionIds {
            guard let facilty = getFaciltyWithId(faciltyId: exclusionId.0 ?? "") else {
                return false
            }
            for option in facilty.options ?? [] {
                if option.id == exclusionId.1 ?? "", (option.isSelected ?? false) == true {
                    return true
                }
            }
        }
        return false
    }

    func fetchFacilities(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FacilityResponse.self, from: data)
                self?.facilityResponse = response
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
