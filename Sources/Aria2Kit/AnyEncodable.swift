import Foundation

/// A type-erased `Encodable` value, used to build heterogeneous JSON-RPC parameter arrays.
public struct AnyEncodable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }
}

extension AnyEncodable: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case Optional<Any>.none:
            try container.encodeNil()
        case let value as Bool:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as String:
            try container.encode(value)
        case let value as [AnyEncodable]:
            try container.encode(value)
        case let value as [String: AnyEncodable]:
            try container.encode(value)
        case let value as Encodable:
            try value.encode(to: encoder)
        default:
            throw EncodingError.invalidValue(
                    value,
                    EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyEncodable value cannot be encoded")
            )
        }
    }
}

extension AnyEncodable: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(Optional<Any>.none as Any)
    }
}

extension AnyEncodable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

extension AnyEncodable: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension AnyEncodable: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension AnyEncodable: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension AnyEncodable: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: AnyEncodable...) {
        self.init(elements)
    }
}

extension AnyEncodable: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, AnyEncodable)...) {
        self.init(Dictionary(uniqueKeysWithValues: elements))
    }
}
