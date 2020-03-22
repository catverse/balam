# Balam
Native database written in Swift for iOS, macOS and watchOS.

## Features
- NoSQL
- Minimum maintenance
- Frictionless migration
- Bullet proof
- Codable
- Combine
- Functional queries
- Swift Package Manager

## Requirements
- iOS 13+
- macOS 10.15+
- watchOS 6+

## Get Started
### Install
Point Swift Package Manager to this repository

### Import
```
import Balam
```

### Usage
Load or create a new database
```
let balam = Balam("MyDb")
```


Add a Codable Struct to the database
```
let myStruct = MyStruct()
balam.add(myStruct)
```


Get all items of a type
```
var subscription: AnyCancellable?

func getItems() {
    subscription = balam.get(MyStruct.self).sink { items in
        /***
            items is an array with all items of type MyStruct.
            Balam guaranties to send this array once, if no item was
            found the array will be empty.

            From here you can apply any transformation or function
            to items: map, filter, sort, ...
        **/
    }
}
```
