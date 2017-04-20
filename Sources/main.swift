//import Kitura
//import HeliumLogger
//
//HeliumLogger.use()
//
//let router = Router()
//router.get("/") { request, response, next in
//    response.send("Hello!")
//    next()
//}
//
//router.get("/admin") { request, response, next in
//    response.send("Hello admin..")
//    next()
//}
//
//let port = portFromEnv() ?? 8080
//Kitura.addHTTPServer(onPort: port, with: router)
//Kitura.run()

print("--- Yeah ----")

let poApi = POAPI()

do {
    let userResponse = try poApi.get(.users)
    let users = Array(userResponse.dictionaryValue.values)
    let xxx = users.map(User.init(json:))
    print(xxx)

//    let user = User(name: "Ikhsan", phone: "071234567", email: "ikhsan@test.com")
//    let xxx = try poApi.post(.users, body: user.json)
//    print(xxx["name"].stringValue)

} catch {
    print("🤕")
}

