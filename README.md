# JusEat iOS Early Careers Take Home Assignment

## MVVM Architecture Pattern
### The break-down of the main components of the MVVM design pattern 

| Layer            | Responsibility                     | Tools Used                          |
|------------------|------------------------------------|-------------------------------------|
| Model Layer      | Data Structures                    | Decodable                           |
| View Layer       | Display + Interaction              | SwiftUI, Kingfisher, MapKit         |
| ViewModel Layer  | Business Logic + State Management  | ObservableObject, @StateObject      |
| Service Layer    | Networking + Location Services     | URLSession, CLGeocoder, CoreLocation|


## Setup Instructions

### Device Compatibility

 <img src="https://github.com/user-attachments/assets/708a0a78-b19c-4f07-a0b3-2e2de0b4a3df" alt="DeploymentInstructions" style="width: 90%; height: auto;">

## Assumptions

- **No User Authentication**: There is no user authentication needed or being able to store/save the users information.
- **UK Postcodes**: The application will work only using UK postcodes due to the API. 
- **API Consistency**: The assumption that the API endpoints would be consistent, reliable and would provide real-time updates based on whether a store is open now for collection/delivery.
- **Display Restaurants**: Must Display the first 10 restaurants.
- **Separated Filters**: Separating things like “deals”, “free delivery”, “halal”, “freebies” from the actual cuisine types like "Pizza", "American", "Chicken" etc given that it is not actual cuisines.
- **Brand Box Usage**: Able to use JET’s Brand Box and images from their application, given that this application is not to be published and is between you and JET.
- **Device Compatibility**: Application must able to be used on any iOS device (and in portrait mode).
- **Restaurant Data Points**: Must display the restaurant data points with the restaurant names, cuisines, rating as a number (including the number of ratings) and the address (first line + postcode).

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

## Features Implemented
- **Location Search**: Can search for place by seleting on the location button on the top left corner which populates the "Enter Postcode" field with the users current postcode. This would then display the output from the API and sort based on the nearest restaurants. Filters also work.
- **Decorative Images**: Application pictures were decorative and identified by nearby text, making alt text descriptions not needed for ease for screen readers.
- **Separated Filters**: Separating things like “deals”, “free delivery”, “halal”, “freebies” from actual cuisine types like "Pizza", "American", "Chicken" etc..
- **Open Restaurants**: Only displaying what is open and near the user in the given API.
- **Restaurant Data Points**: Displayed the restaurant data points with names, cuisines, rating as a number (including the number of ratings) and the address (first line + postcode).


## Future Improvements

## Acknowledgements
