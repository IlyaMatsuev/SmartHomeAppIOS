import Foundation
import Testing
@testable import SmartHomeAppIOS

struct HubRequestTests {
    private struct SampleBody: Codable, Equatable {
        let name: String
        let count: Int
    }

    // MARK: - get()

    @Test
    func getProducesGetMethodWithNoBody() {
        let request = HubRequest.get("/devices")

        #expect(request.method == .get)
        #expect(request.uri == "/devices")
        #expect(request.body == nil)
        #expect(request.protected == true)
    }

    @Test
    func getRespectsExplicitProtectedFlag() {
        let request = HubRequest.get("/public", protected: false)

        #expect(request.protected == false)
    }

    // MARK: - delete()

    @Test
    func deleteProducesDeleteMethodWithNoBody() {
        let request = HubRequest.delete("/devices/42")

        #expect(request.method == .delete)
        #expect(request.uri == "/devices/42")
        #expect(request.body == nil)
        #expect(request.protected == true)
    }

    // MARK: - post()

    @Test
    func postEncodesBodyAsJSON() throws {
        let payload = SampleBody(name: "lamp", count: 3)
        let request = try HubRequest.post("/devices", payload)

        #expect(request.method == .post)
        #expect(request.uri == "/devices")
        #expect(request.protected == true)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode(SampleBody.self, from: body)
        #expect(decoded == payload)
    }

    @Test
    func postRespectsExplicitProtectedFlag() throws {
        let request = try HubRequest.post("/auth/login", SampleBody(name: "x", count: 1), protected: false)

        #expect(request.protected == false)
    }

    // MARK: - put()

    @Test
    func putEncodesBodyAsJSON() throws {
        let payload = SampleBody(name: "kitchen", count: 7)
        let request = try HubRequest.put("/rooms/kitchen", payload)

        #expect(request.method == .put)
        #expect(request.uri == "/rooms/kitchen")
        #expect(request.protected == true)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode(SampleBody.self, from: body)
        #expect(decoded == payload)
    }
}
