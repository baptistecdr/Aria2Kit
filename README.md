<h3 align="center">Aria2Kit</h3>
<p align="center">
    Aria2Kit is a Swift library to interact with an Aria2 server.
    <br />
    <a href="https://github.com/baptistecdr/Aria2Kit/issues/new">Report bug</a>
    ·
    <a href="https://github.com/baptistecdr/Aria2Kit/issues/new">Request feature</a>
</p>

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code
and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Aria2Kit as a dependency is as easy as adding it to the `dependencies`
value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/baptistecdr/Aria2Kit", exact: "1.0.4")
]
```

You can also add Aria2Kit through Xcode > File > Add packages... > https://github.com/baptistecdr/Aria2Kit

## Examples

```swift
import Aria2Kit

let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: "secret-token")
aria2.call(method: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"], ["split": "1"]]).responseData { response in
    debugPrint(response)
}
```

```swift
import Aria2Kit

let aria2 = Aria2(ssl: false, host: "localhost", port: 6800, token: "secret-token")
let multicallParams = [
    Aria2MulticallParams(methodName: .addUri, params: [["https://proof.ovh.net/files/1Mb.dat"], ["split": "1"]]),
    Aria2MulticallParams(methodName: .getVersion, params: []),
]
aria2.multicall(params: multicallParams).responseData { response in
    debugPrint(response)
}
```

## Build & Test

* Open project in Xcode
* Run `docker compose up -d` before running the tests

## Bugs and feature requests

Have a bug or a feature request? Please first search for existing and closed issues. If your problem or idea is not
addressed yet, [please open a new issue](https://github.com/baptistecdr/Aria2Kit/issues).

## Contributing

Contributions are welcome!
