/// Модель отзыва.
struct Review: Decodable {

    /// Имя пользователя
    let userFirstName: String
    /// Фамилия пользователя
    let userLastName: String
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String
    /// Оценка отзыва
    let rating: Int
    /// Ссылки на приложенные изображения
    let stringURLs: [String] 
    
    enum CodingKeys: String, CodingKey {

        case userFirstName = "first_name"
        
        case userLastName = "last_name"
        
        case text
        
        case created
        
        case rating
        
        case stringURLs = "photo_urls"
    }
    
     init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userFirstName = try container.decode(String.self, forKey: .userFirstName)
        self.userLastName = try container.decode(String.self, forKey: .userLastName)
        self.text = try container.decode(String.self, forKey: .text)
        self.created = try container.decode(String.self, forKey: .created)
        self.rating = try container.decode(Int.self, forKey: .rating)
         if let urls = try container.decodeIfPresent([String].self, forKey: .stringURLs) {
             self.stringURLs = urls
         } else {
             stringURLs = []
         }
    }
}
