import Alamofire
import Foundation

public class Aria2 {
    public let ssl: Bool
    public let host: String
    public let port: UInt16
    public let path: String
    public let token: String?
    private let session: Session

    public init(ssl: Bool, host: String, port: UInt16, path: String = "/jsonrpc", token: String?, session: Session = .default) {
        self.ssl = ssl
        self.host = host
        self.port = port
        self.path = path
        self.token = token
        self.session = session
    }

    private func removeLaggingSlash(of: String) -> String {
        if path.starts(with: "/") {
            return String(path.dropFirst())
        }
        return path
    }

    private func scheme() -> String {
        ssl ? "https" : "http"
    }

    public func url() -> URL {
        let pathWithoutLaggingSlash = removeLaggingSlash(of: path)
        return URL(string: "\(scheme())://\(host):\(port)/\(pathWithoutLaggingSlash)")!
    }

    public func call(method: Aria2Method, params: [AnyEncodable]) -> DataRequest {
        var callParams = params
        if let token = token {
            callParams.insert(AnyEncodable("token:\(token)"), at: 0)
        }
        let body = Aria2Body(method: method.rawValue, params: callParams)
        return session.request(
                url(),
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders([HTTPHeader.contentType("application/json-rpc")])
        )
    }

    public func multicall(params: [Aria2MulticallParams]) -> DataRequest {
        let callParams: [Aria2MulticallParams] = params.map { element in
            var params = element.params
            if let token = token {
                params.insert(AnyEncodable("token:\(token)"), at: 0)
            }
            return Aria2MulticallParams(methodName: element.methodName, params: params)
        }
        let body = Aria2Body(method: "system.multicall", params: [AnyEncodable(callParams)])
        return session.request(
                url(),
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders([HTTPHeader.contentType("application/json-rpc")])
        )
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func call(method: Aria2Method, params: [AnyEncodable]) async -> DataResponse<Data, AFError> {
        await call(method: method, params: params).serializingData().response
    }

    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func multicall(params: [Aria2MulticallParams]) async -> DataResponse<Data, AFError> {
        await multicall(params: params).serializingData().response
    }
}
