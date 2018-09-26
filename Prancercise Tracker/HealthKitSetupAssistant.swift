/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthkitSetupError.notAvailableOnDevice)
        return
    }
    guard
        let dob = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
        let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
        let bioSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
        let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
        let height = HKObjectType.quantityType(forIdentifier: .height),
        let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
        let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
    else {
        completion(false, HealthkitSetupError.dataTypeNotAvailable)
        return
    }
    let healthKitTypeToWrite: Set<HKSampleType> = [bodyMassIndex, activeEnergy, HKObjectType.workoutType()]
    let healthKitTypeToRead: Set<HKObjectType> = [dob, bloodType, bioSex, bodyMassIndex, height, bodyMass, HKObjectType.workoutType()]
    HKHealthStore().requestAuthorization(toShare: healthKitTypeToWrite, read: healthKitTypeToRead, completion: completion)
  }
}
