import Vapor
import Fluent

final class Product{
    var id: Int
    var name: String
    var price: Double
    
    init(id: Int, name: String, price: Double) {
        self.name = name
        self.id = id
        self.price = price
    }    
}
