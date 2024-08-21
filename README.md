# JPMorgan Challenge: APOD App

Welcome to the JPMorgan Challenge APOD app! This project fetches and displays data from NASA's Astronomy Picture of the Day (APOD) API, showcasing the daily image, video, and associated information on the home screen.

## Features

### 1. Daily APOD Display
- **Automatic Data Fetching**: On launch, the app automatically loads the current day's APOD, displaying the date, title, image (or embedded video), and explanation.
- **Dynamic Media Handling**: Some APODs feature embedded videos instead of images (e.g., October 11, 2021). The app seamlessly handles both scenarios.
- **Future-Proof Navigation**: A Tab Bar is implemented to allow for future expansions of the app's features and navigation.

### 2. Date Selection
- **User Control**: Users can choose and load the APOD for any date they want by selecting a specific date from the app's interface.

### 3. Offline Support
- **Caching**: The last successful service call, including the image, is cached. If any subsequent API requests fail, the app will load the cached data to ensure continued functionality.

## Caching Mechanism

- The app uses `URLCache` for caching both APOD API requests and image URL requests.
- A custom `CacheAsyncImage` view is implemented to extend the functionality of `AsyncImage`, allowing for efficient image caching based on URL.

## Project Setup

### Debug Scheme Setup

To set up the app in debug mode with a local version of the APOD API:


1. Clone the repo
```bash
git clone https://github.com/nasa/apod-api
```
2. `cd` into the new directory
```bash
cd apod-api
```
3. Install dependencies into the project's `lib`
```bash
pip install -r requirements.txt -t lib
```
4. Add `lib` to your PYTHONPATH and run the server
```bash
PYTHONPATH=./lib python application.py
```


### Release Scheme Setup

For the release scheme, no additional setup is required. The app will use the production NASA APOD API (https://api.nasa.gov) with the API key set to "DEMO_KEY".

## Further Enhancements

### Dynamic API Key Management:
The API key is managed via an .xcconfig file. The remote repository will contain an empty API-Key parameter, while the local repository can store the actual API key for secure requests.

### UI Tests:
Implement UI tests to validate the app's core functionality, including smooth navigation, accurate data rendering
