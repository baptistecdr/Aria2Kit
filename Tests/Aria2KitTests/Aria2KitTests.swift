import XCTest
import AnyCodable

@testable import Aria2Kit

final class Aria2KitTests: XCTestCase {
    private let DEFAULT_TOKEN = "secret-token"
    private let DEFAULT_TIMEOUT: TimeInterval = 30 // seconds

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

    func testCallWithToken() throws {
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

    func testMulticallWithToken() throws {
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
}
