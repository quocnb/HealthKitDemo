# HealthKitDemo
HealthKit demo of [Raywenderlich tutorial](https://www.raywenderlich.com/459-healthkit-tutorial-with-swift-getting-started
)


## Step by Step

### Authorizing HealthKit
1. Enable `HealthKit` in `Capabilities`
2. Add `Usage Descriptions` in `Info.plist`
```
Privacy – Health Share Usage Description
Privacy – Health Update Usage Description
```
3. Authorizing HealthKit

 you need to be nice and ask for permission to access each type of data first.
 
 ### Query HealthKit data
 
With main info (setting by click to user icon in Health app), you can direct to get it
```
let healthKitStore = HKHealthStore()
let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
let biologicalSex =       try healthKitStore.biologicalSex()
let bloodType =           try healthKitStore.bloodType()
```
 
 With other info, as like as `CoreData`, to query the HealthKit data, you need to specify the predicate, sort descriptors (optional) and then ask the `HealthKitStore` excute it
 
 **Predicate**
 ```
let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
 ```
 
 **Sort Descriptor**
 ```
 let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
 ```
 
 **Query**
 ```
 let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors:  [sortDescriptor]) { (query, samples, error) in    
    // Always dispatch to the main thread when complete.
    DispatchQueue.main.async {
    }
  }
 ```
 
 And don't forget to **excute it**
 ```
 HKHealthStore().execute(sampleQuery)
 ```
 
 ### Testing
 Set the testing device in `Health` app (Simulator or device)
