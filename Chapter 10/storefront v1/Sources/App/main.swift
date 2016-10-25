import Vapor
import HTTP


let drop = Droplet()
var tv1 = Product(id: 1, name: "Classic TV", price: 100.00)
var speakers = Product(id: 2, name: "Massive Sound", price: 199.00)
var turntable = Product(id: 3, name: "Turntable", price: 249.00)

var products = [Product]()
products.append(tv1)
products.append(speakers)
products.append(turntable)



drop.get("/") { request in
    return try drop.view.make("shop.html")
}

drop.post("purchase") { request in
    drop.log.info("purchase request made")
    guard let product_id = request.data["product_id"]?.int else {
        throw Abort.badRequest
    }
    
    guard let product = products.filter({ (prod) -> Bool in
        return prod.id == product_id
    }).first else{
        throw Abort.badRequest
    }
    
    let json = try JSON(node: [
        "Product" : "\(product.name)",
        "price" : "\(product.price)",
        ])
    
    let slack_payload = try JSON(node: [ "attachments":
        try JSON(node: [
            try JSON(node: [
                "fallback": "New purchase Request",
                "pretext": "New purchase Request",
                "color": "#D00000",
                "fields": try JSON(node: [
                    try JSON(node: [
                        "title" : "Product: \(product.name)",
                        "value" : "Price: \(product.price)",
                        "short" : "false"
                        ])
                    ])
                ])
            ])
        ])
    
    let _ = try drop.client.post("https://hooks.slack.com/services/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", headers: [:], query: [:], body: slack_payload)

    var response = try Response(status: .ok, json: json)
    
    return response
}


let port = drop.config["app", "port"]?.int ?? 80

drop.serve()
