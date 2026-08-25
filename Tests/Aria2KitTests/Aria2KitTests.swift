import Alamofire
import XCTest

@testable import Aria2Kit

final class Aria2KitTests: XCTestCase {
    private let DEFAULT_TOKEN = "secret-token"
    private let DEFAULT_TIMEOUT: TimeInterval = 30 // seconds

    private func makeStubbedSession() -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return Session(configuration: configuration)
    }

    func testConstructor() {
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, path: "/custom-path", token: DEFAULT_TOKEN)
        XCTAssertEqual(aria2.ssl, false)
        XCTAssertEqual(aria2.host, "localhost")
        XCTAssertEqual(aria2.port, 6800)
        XCTAssertEqual(aria2.path, "/custom-path")
        XCTAssertEqual(aria2.token, DEFAULT_TOKEN)
        XCTAssertEqual(aria2.url(), URL(string: "http://localhost:6800/custom-path")!)
    }

    func testCallWithoutToken() {
        let e = expectation(description: "testCallWithoutToken")
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil)
        aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]).response { response in
            XCTAssertEqual(response.response?.statusCode, 200)
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)
    }

    func testCallWithToken() {
        let e = expectation(description: "testCallWithToken")
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: DEFAULT_TOKEN)
        aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]).response { response in
            XCTAssertEqual(response.response?.statusCode, 200)
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)
    }

    func testMulticallWithoutToken() {
        let e = expectation(description: "testMulticallWithoutToken")
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil)
        let multicallParams = [
            Aria2MulticallParams(methodName: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]),
            Aria2MulticallParams(methodName: .getVersion, params: []),
        ]
        aria2.multicall(params: multicallParams).response { response in
            XCTAssertEqual(response.response?.statusCode, 200)
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)
    }

    func testMulticallWithToken() {
        let e = expectation(description: "testMulticallWithToken")
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: DEFAULT_TOKEN)
        let multicallParams = [
            Aria2MulticallParams(methodName: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]),
            Aria2MulticallParams(methodName: .getVersion, params: []),
        ]
        aria2.multicall(params: multicallParams).response { response in
            XCTAssertEqual(response.response?.statusCode, 200)
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)
    }

    func testCallWithoutTokenAsync() async {
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil)
        let response = await aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]])
        XCTAssertEqual(response.response?.statusCode, 200)
    }

    func testCallWithTokenAsync() async {
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: DEFAULT_TOKEN)
        let response = await aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]])
        XCTAssertEqual(response.response?.statusCode, 200)
    }

    func testMulticallWithoutTokenAsync() async {
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil)
        let multicallParams = [
            Aria2MulticallParams(methodName: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]),
            Aria2MulticallParams(methodName: .getVersion, params: []),
        ]
        let response = await aria2.multicall(params: multicallParams)
        XCTAssertEqual(response.response?.statusCode, 200)
    }

    func testMulticallWithTokenAsync() async {
        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: DEFAULT_TOKEN)
        let multicallParams = [
            Aria2MulticallParams(methodName: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]),
            Aria2MulticallParams(methodName: .getVersion, params: []),
        ]
        let response = await aria2.multicall(params: multicallParams)
        XCTAssertEqual(response.response?.statusCode, 200)
    }

    func testCallWithoutNetworkUsesInjectedSession() {
        let e = expectation(description: "testCallWithoutNetworkUsesInjectedSession")
        var capturedRequest: URLRequest?
        StubURLProtocol.requestHandler = { request in
            capturedRequest = request
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("{}".utf8))
        }

        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil, session: makeStubbedSession())
        aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]).response { response in
            XCTAssertEqual(response.response?.statusCode, 200)
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)

        XCTAssertEqual(capturedRequest?.url?.absoluteString, "http://localhost:6800/jsonrpc")
        XCTAssertEqual(capturedRequest?.httpMethod, "POST")
    }

    func testCallWithTokenInjectsTokenIntoBodyWithoutNetwork() throws {
        let e = expectation(description: "testCallWithTokenInjectsTokenIntoBodyWithoutNetwork")
        var capturedRequest: URLRequest?
        StubURLProtocol.requestHandler = { request in
            capturedRequest = request
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("{}".utf8))
        }

        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: DEFAULT_TOKEN, session: makeStubbedSession())
        aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]]).response { _ in
            e.fulfill()
        }
        waitForExpectations(timeout: DEFAULT_TIMEOUT)

        let bodyData = try XCTUnwrap(StubURLProtocol.bodyData(from: try XCTUnwrap(capturedRequest)))
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: bodyData) as? [String: Any])
        let params = try XCTUnwrap(json["params"] as? [Any])
        XCTAssertEqual(params.first as? String, "token:\(DEFAULT_TOKEN)")
    }

    func testCallAsyncWithoutNetworkUsesInjectedSession() async {
        StubURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("{}".utf8))
        }

        let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: nil, session: makeStubbedSession())
        let response = await aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"]])
        XCTAssertEqual(response.response?.statusCode, 200)
    }
}
