public struct Aria2MulticallParams: Encodable {
    public let methodName: Aria2Method
    public let params: [AnyEncodable]

    public init(methodName: Aria2Method, params: [AnyEncodable]) {
        self.methodName = methodName
        self.params = params
    }
}
