# Kurlyk
Modular and composable application

## Description

Kurlyk is a SwiftUI project built with the help of [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) and [SwiftPM](https://www.swift.org/package-manager/).

It also uses Clean Architecture as a core for it's design. And it helps me to practice new technologies.

## How to run

In order to run the project you need to have Xcode installed on your machine and that's it. Nothing else will be needed.

## Project structure

Project consists of different modules which has different dependencies, both external and internal. Here's a quick look on project modules:

* *Domain*. The upper level of abstraction, it consists of domain-specific models, use cases and domain-wide utils.
* *DesignSystem*. Contains application-specific colors, fonts, spaces, button styles, etc.
* *ComponentsKit*. Contains application-specific UI components like buttons, fields, etc.
* *...Feature*. Feature frameworks which contain the actual implementation of app features with abstract use cases.
* *Kurlyk*. Main component which combines all feature frameworks together and pass live use cases to them.

## Notes

There're XcodeGen and Mint configuration files in the project, but .xcodeproj file is in the repo and it's not recommended to generate a project for now.
XcodeGen is not supporting Test Plans for now, so I turned it off. I'll update the repo when it starts working.
