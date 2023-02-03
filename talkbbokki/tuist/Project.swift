import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains Tuist App target and Tuist unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone])

let baseSettings: [String: SettingValue] = [
    "MARKETING_VERSION": "1.0",
    "CURRENT_PROJECT_VERSION": "1.0"
]

let option: Project.Options = .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
)

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.6.1")),
        .remote(url: "5.6.1", requirement: .upToNextMinor(from: "0.9.0"))
    ],
    platforms: [.iOS]
)

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "talkbbokki",
                          platform: .iOS,
                          additionalTargets: ["talkbbokkiKit", "talkbbokkiUI"])
