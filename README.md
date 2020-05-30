# Mindvalley

Mind valley coding challenge app.

### Prerequisites

-  Xcode 11.3
-  iOS 13

### Overview
This project is developed based on **MVVM** design pattern. All logic put into **ViewModel**. Data and Views are completely decoupled from each other. 

- **Data Layer:** DataProrider is responsible to feed the application. First check the cache if not found then fetch remote data.

- **View Layer:** UITableView is used to populate channel data. For the horizontal list, UICollectionView is used inside table view cell.

### Maintainability & Scalability
**SectionProtocol** mange each section individually. Each section manages it's own responsibility and dependency. So that we can easily plug a new section into table view.

    ```
    public func getSection() -> [SectionProtocol] {
        let episodeSection = NewEpisodesSection()
        let channelSection = ChannelSection()
        let categorySection = CategorySection()
        return [episodeSection, channelSection, categorySection]
    }
    ```

**Cacheable** protocol is responsible for caching data. User default cache is used for this project. But in future we can easily replace it with another caching mechanism as like Core Data or SQLite.  

    ```
    protocol Cacheable {
    func getData<T>(for key: String) -> T?
    func saveData<T>(_ data: T, for key: String) throws -> Void
    }
    ```

### Test Coverage
Current code coverage is 64.6%. 
Challenging part is to mock the testing object. Solve it by using Dependency Injection.

### Future Improvement
- Currently NSCache(memory) caching is used for Image. Need to implement disk cache for better UX.
- The shimmering animation layer needs to implement for loading UI.
