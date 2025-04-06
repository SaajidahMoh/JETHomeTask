# Just Eat Takeaway.com iOS Early Careers Take - Home Assignment

## MVVM Architecture Pattern
### The break-down of the main components of the MVVM design pattern 

| Layer            | Responsibility                     | Tools Used                          |
|------------------|------------------------------------|-------------------------------------|
| Model Layer      | Data Structures                    | Decodable                           |
| View Layer       | Display + Interaction User View    | SwiftUI, Kingfisher, MapKit         |
| ViewModel Layer  | Business Logic + State Management  | ObservableObject, @StateObject      |
| Service Layer    | Networking + Location Services     | URLSession, CLGeocoder, CoreLocation|

### Folder Structure
* **Service:**
    * Network.swift
    * LocationManager.swift
* **Model:**
    * Model.swift
* **View:**
    * CategoryItemsView.swift
    * FilteringItemsView.swift
    * JETView.swift (my main view)
    * LocationMapAnnotationView.swift
    * NoPostcodeView.swift
    * NoRestaurantView.swift
    * RestaurantDetailView.swift
    * RestaurantListView.swift
* **ViewModel:**
    * JETViewModel.swift

## Setup Instructions

1. You will need to download this [zip folder](https://github.com/SaajidahMoh/JETHomeTask.git) and unzip it
2. Download [XCode](https://apps.apple.com/gb/app/xcode/id497799835?mt=12 ) from the App Store. I am currently using version 16.2
3. Click on the ```JETHome.xcodeproj``` file and it should open in Xcode.
4. Check the package dependencies to ensure the ```Kingfisher``` is imported. To check this, click on the ```JetHome.xcodeproj``` file. When it take you to Xcode, click on ```JETHome``` [With the blue App Store Icon]. There is another JETHome underneath ‘Project’. Navigate to “Package Dependencies” and ensure that the ```Kingfisher``` is there. If not, you will need to add it by following the image below and selecting the + icon. 
	
  Kingfisher: ```https://github.com/onevcat/Kingfisher``` 
 
<img src="https://github.com/user-attachments/assets/684cbd05-ed7d-421a-ac79-9aabf73ed00c" alt="Kingfisher" style="width: 90%; height: auto;">

5. 	You will need to try to run the code. You should get the following errors: ```Development Team``` in which you will need to add an ```Account```. Sign in with your Apple ID, and add yourself as the development team. Ghis should fix the error.
7. 	Run the code. You will need to connect your iPhone to the MacBook with a wire and select your phone at the top.
8. 	You will be prompted to enter your keychain password - Please enter your MacBook password and select **Always allow**. If you select deny or allow once it may not let you continue.
9. 	You will need to go to your **iPhone settings** -> **General** -> **VPN & Device Management** to verify the Developer app.
10. Next, you will need to go to **iPhone settings** -> **Privacy & Security**, scroll down to **Developer Mode** under **Security** and turn it on.
11. Restart your iPhone, and run the code again. 


### Device Compatibility

To ensure you are able to test the locaiton and map aspect of the application, it is recommended to run the application on an iOS device (preferable an iphone) instead of the Stimulator. Ensure the Minimum Deployment is set to 17.6 by following the image below:
 <img src="https://github.com/user-attachments/assets/708a0a78-b19c-4f07-a0b3-2e2de0b4a3df" alt="DeploymentInstructions" style="width: 90%; height: auto;">

## Assumptions
I found the assignment clear and was able to reach out to Maria if I had any questions. In order to complete the take home task, I made the following assumptions:
- **No User Authentication**: There is no user authentication needed or being able to store/save the users information.
- **UK Postcodes**: The application will work only using UK postcodes due to the API. 
- **API Consistency**: The assumption that the API endpoints would be consistent, reliable and would provide real-time updates based on whether a store is open now for collection/delivery.
- **Categorising "Restaurants"**: The API returned a variety of categories including restaurants, groceries, convenience stores, alcohol shops and electronic stores which doesn't quite fit the "restaurant" theme. An assumption was made to seperate them if one of the categories were contained in their "UniqueNames".
- **Display Restaurants**: Must Display the first 10 restaurants.
- **Separated Filters**: Separating things like “deals”, ```free delivery```, ```halal```, ```freebies``` from the actual cuisine types like ```Pizza```, ```American```, ```Chicken``` etc. given that they are not actual cuisines.
- **Brand Box Usage**: Able to use JET’s Brand Box and images from their application, given that this application is not to be published and is between you and JET.
- **Device Compatibility**: Application must able to be used on any iOS device (and in portrait mode).
- **Restaurant Data Points**: Must display the restaurant data points with the restaurant names, cuisines, rating as a number (including the number of ratings) and the address (first line and postcode).

## Features Implemented
- **Restaurant Data Points**: All restaurant data points with the restaurant names, cuisines, rating as a number (including the number of ratings) and the address (first line and postcode) were effectively displayed, with card details respective to their informaiton. I chose to use RESTful API over GraphQL due to its simplicity and efficency in handling large datasets, ensuring quick and easy intergration with minimal complexity. 
- **Location Search**: Can search for place by seleting on the location button on the top left corner which populates the ```Enter Postcode``` text field with the users current postcode. This would then display the output from the API and sort based on the nearest restaurants. Filters also work.
- **Decorative Images**: Application pictures were decorative and identified by nearby text, making alt text descriptions not needed for ease for screen readers.
- **Separated Filters**: Separating things like ```deals```, ```free delivery```, ```halal```, ```freebies``` from actual cuisine types like ```Pizza```, ```American```, ```Chicken``` etc. given that they are not actual cuisines and for effective filtering capabiltiies to enahnce user experience.
- **Sorting Restaurants** : Sorting the restuarants, grocieries and other categories in order of nearest. 
- **Open Restaurants**: Only displaying what is open and near the user in the given API.
- **Functions of Rating and Distances**: Functions were created to ensure restaurant ratings were displayed for a clean interface. Ratings that had no ratings did not display the number of people as there were no ratings, with ratings over 200 simplified to 200+. Converting distances were also implemented to allow users to see how far they were from the place for collections. 

  
## The Application 

### Light Mode
<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/user-attachments/assets/eae79557-b0b4-4433-b80e-7058cb74fe9a" alt="LightPostcode" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/28197ba2-7e5f-4636-a7ff-33bb6104759a" alt="LightMode2" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/e17e3b70-1a4e-47e4-84f1-b306a535cc64" alt="LightMode1" style="width: 30%; height: auto;">
</div>

### Night Mode
<div style="display: flex; justify-content: space-around;">
    <img src="https://github.com/user-attachments/assets/1e49a1f9-ac47-4bff-b887-3935ccc40932" alt="NightPostcode" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/0acaaadf-30c2-434b-a19f-2fec93798ca5" alt="NightMode1" style="width: 30%; height: auto;">
  <img src="https://github.com/user-attachments/assets/5ad6af80-c4fb-4e2f-8e5f-19f2d1f355da" alt="NightMode2" style="width: 30%; height: auto;">
</div>


## Future Improvements
- **Postcode Validation:** Implement validation for postcode and embedding my NoRestaurantView to show if it was not a valid postcode or no restaurants were found. Whilst I did try to implement this with the ```AsyncDispatch``` to perform the tasks asynchronously, there was a problem with showing the NoRestaurantView when it was making the call.
- **Image Storage:** For my categories and filtering flavours capabiltiies, my images are stored in the application's assets to replicate the JET application. It would be more effective to continue using Kingfisher to retrieve the images from a secure, online database which would take up less storage and improve the applications performance.
- **Map Integration:** Although I have implemented a map for when users select a restaurant, it would be more beneficial to implement a separate, interactive map that can be on a full screen for users to view all nearby locations with filtering capabilities. My current map also displays the current user's location, it may be effective if it could plot the address entered as opposed to the user's location. 
- **Geocoding and Unit Testing:** I implemented reverse geocoding to retrieve the users postcode based on their location(coordinates). However, my application started to glitch when you enter a postcode and select a restaurant. When returning back to the main view, it will automatically update the postcode to your current postcode. If the user turns off their location, it will not update automatically. Despite this feature working perfectly before, it would have been more robust if I had more time to learn and effectively apply unit tests. This gap of knowledge had led to me manually running the application each time to test the user journey and input which was time-consuming. Following on from this, I have began a course for unit testing which would allow me to continue refining my skills, preparing me to accelerate my career in iOS development at JET.com  
- **Deprecated Code:** A small minority of my code is deprecated but the functionality still appears to work. It may not be up to date with the latest iOS updates, such as ```authorizationStatus()```, ```mapAnnotation```, and ```onChange()```. If I had more time, I would like to update and follow the latest trends to stay ahead in the evolving field of iOS development.
- **Interface Improvement:** Although I used JET’s Brand Box to ensure my application was accessible, I could improve the interface by reducing the amount of information displayed and replacing cuisine types with icons.
- **Caching:** My code makes an API call after each letter/number in the postcode is entered, it would be beneficial to implement caching to improve the performance. Previously, I implemented a button for the user to get the results based on their input, but found issues with too many manual inputs and a cluttered interface.
- **Clear Icons:** Use clear icons to indicate ```stamp-cards```, ```deals```, etc., without requiring users to read into each restaurant.
- **Launch Page:** Implement a seamless launch page for better user experience.
- **Search Optimisation:** When I used DispatchQueue.main.asyncAfter, there was a delay in showing the current interface. It would always show that the postcode entered was incorrect, but then show the correct interface a few seconds later. I removed this for better user experience, but it can be improved.
- **Closed Restaurants:** Allow users to search for closed restaurants with a grey overlay and clearly written ```closed``` so they are aware the place exists. Following on from this, I would also like to implement additional details regarding the operating hours specifcally. 
- **Enhanced Filtering:** Add more filtering capabilities so users don’t have to scroll back and forth and also seeing the number of places that are open or the filter they select. I could implement a separate ```lazyVGrid``` with a search at the top to make it accessible and easy for users. I would also implement other sorting capabilities including sorting by ```customer ratings```, ```delivery fee```, ```closing time``` and ```minimum order``` for orders that have a minimum requirement.
- **Display Food Hygiene Rating:** All additional filtering have been implemented and gathered from ```uniqueNames```, except for ```open```, ```new``` and ```4+ star```. It would have been more effective if I was able to effectively get the restaurant's ID and perform filtering based on the ID. This could further simplify my code as opposed to the large criteria-based filtering. 

## Acknowledgements
- **Maria Harris** - Senior TA Specialist - Early Careers Lead (Tech & Product), for the speedy response to my query.
- **[Just Eat Takeaway.com](https://www.just-eat.co.uk/)** for the API and the images taken to make my application user-friendly.
- **[Just Eat's Brand Box](https://brand-box.marketing.just-eat.com)** for the accessible colours that informed my application design.
