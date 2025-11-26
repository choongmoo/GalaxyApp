import Foundation

struct Galaxy: Identifiable, Codable {
    let id: Int
    let name: String
    let size: String?
    let mass: String?
    let type: String
    let distance: String
    let description: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, size, mass, type, distance, description
        case imageUrl = "image_url"
    }
}
