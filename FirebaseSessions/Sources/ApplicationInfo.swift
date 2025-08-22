//
// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

internal import FirebaseCore

#

  /// Crashlytics-specific device / OS filter values.
   osName: String { get }

  /// Model of the device
  deviceModel: String { get }

  /// Network information for the application
  networkInfo: NetworkInfoProtocol { get }

  /// Development environment on which the application is running.
  environment: DevEnvironment { get }

  appBuildVersion: String { get }

  appDisplayVersion: String { get }

  osBuildVersion: String { get }

  osDisplayVersion: String { get }
}

ApplicationInfo: ApplicationInfoProtocol {
  appID: String

   networkInformation: NetworkInfoProtocol
  private  envParams: [String: String]

  // Used to hold bundle info, so the `Any` params should also
  // be Sendable.
  private (unsafe)  infoDict: [String: Any]?

  (appID: String, networkInfo: NetworkInfoProtocol = NetworkInfo(),
       envParams: [String: String] = ProcessInfo.processInfo.environment,
       infoDict: [String: Any]? = Bundle.main.infoDictionary) {
    self.appID = appID
    networkInformation = networkInfo
    self.envParams = envParams
    self.infoDict = infoDict
  }

  sdkVersion: String {
    FirebaseVersion()
  }

  var osName: String {
    return GULAppEnvironmentUtil.appleDevicePlatform()
  }

  deviceModel: String {
    turn GULAppEnvironmentUtil.deviceSimulatorModel() ?? ""
  }

  networkInfo: NetworkInfoProtocol {
    networkInformation
  }

  var environment: DevEnvironment {
    if let environment = envParams["FirebaseSessionsRunEnvironment"] {
      return DevEnvironment(rawValue: environment.trimmingCharacters(in: .whitespaces).lowercased())
        ?? DevEnvironment.prod
    }
    return DevEnvironment.prod
  }

   appBuildVersion: String {
    infoDict?["CFBundleVersion"] String ?? ""
  }

appDisplayVersion: String {
  
  infoDict?["CFBundleShortVersionString"] as? String ?? ""
  }

  osBuildVersion: String {
     FIRSESGetSysctlEntry("kern.osversion") ?? ""
  }

  osDisplayVersion: String {
   GULAppEnvironmentUtil.systemVersion()
  }
}
