import Foundation

struct Serialiser {
    static func encode(_ container: UnkeyedEncodingContainer, properties: Set<Property>) {
        var container = container
        properties.forEach {
            try! container.encode(.init(describing: $0))
            try! container.encode($0)
        }
    }
    
    static func decode(_ container: UnkeyedDecodingContainer) -> Set<Property> {
        var set = Set<Property>()
        var container = container
        while !container.isAtEnd {
            try! set.insert(container.decode(map[container.decode(String.self)]!))
        }
        return set
    }
    
    private static let map = ["Balam.Property.String" : Property.String.self]
    
//    private enum Key: CodingKey {
//        case
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        enco
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//        
//        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
//        try additionalInfo.encode(elevation, forKey: .elevation)
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        latitude = try values.decode(Double.self, forKey: .latitude)
//        longitude = try values.decode(Double.self, forKey: .longitude)
//        
//        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
//        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case latitude
//        case longitude
//        case additionalInfo
//    }
//    
//    enum AdditionalInfoKeys: String, CodingKey {
//        case elevation
//    }
}
