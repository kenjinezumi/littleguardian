**LittleGuardian - Babysitting & Childcare App**
================================================

**Description:**\
LittleGuardian is a **Flutter-based** mobile app designed to connect **parents** and **babysitters** in a secure and user-friendly environment. It features **role-based navigation** (Parent vs. Babysitter), **advanced booking management**, a refined **Material 3 UI**, **Lottie splash animations**, and **Firebase authentication**.

### **Key Features**

✅ **Role-based navigation** -- Parents and Babysitters have distinct home screens.\
✅ **Booking system** -- Parents can create/view bookings; Babysitters can accept/manage job requests.\
✅ **Firebase authentication** -- Sign in with Email/Password, Google, or Phone OTP verification.\
✅ **Lottie animated splash screen** -- Beautiful intro animation.\
✅ **Material 3 UI** -- Smooth, modern, and accessible user experience.

* * * * *

**1\. Install Flutter & Set Up Environment**
--------------------------------------------

1.  **Install Flutter SDK** from Flutter.dev.
2.  Add the `flutter/bin` folder to your **system PATH** to run Flutter commands from the terminal.
3.  **Verify installation** by running:

    nginx

    CopyEdit

    `flutter doctor`

    Ensure there are **no errors**, especially for **Android SDK, emulator, or device support**.

* * * * *

**2\. Clone the Project**
-------------------------

-   Using **Git** (recommended), open a terminal and run:

    bash

    CopyEdit

    `git clone <REPOSITORY_URL>
    cd littleguardian`

-   Or **download the ZIP**, extract it, and navigate to the **project root folder**.

* * * * *

**3\. Configure Firebase for the App**
--------------------------------------

1.  **Set up Firebase** on Firebase Console.
2.  Enable **Authentication** (Email/Password, Google, and Phone Sign-In).
3.  **Download** the required configuration files:
    -   `google-services.json` → Place in **`android/app/`**
    -   `GoogleService-Info.plist` → Place in **`ios/Runner/`**
4.  If using FlutterFire CLI:

    arduino

    CopyEdit

    `dart run flutterfire configure`

    This generates `firebase_options.dart`.

* * * * *

**4\. Install Dependencies**
----------------------------

Run the following command inside the project directory:

arduino

CopyEdit

`flutter pub get`

This fetches all required packages such as `provider`, `firebase_auth`, `lottie`, etc.

* * * * *

**5\. Running the App in an Emulator or Physical Device**
---------------------------------------------------------

### **Run an Android Emulator**

1.  **List available emulators**:

    nginx

    CopyEdit

    `flutter emulators`

    You should see something like:

    arduino

    CopyEdit

    `3 available emulators:
    Pixel_6_API_33 - Google - android`

2.  **Start an emulator**:

    css

    CopyEdit

    `flutter emulators --launch Pixel_6_API_33`

    Or, open **Android Studio** → **Device Manager** → Select an emulator → Click **Start**.

3.  **Run the app on the emulator**:

    arduino

    CopyEdit

    `flutter run`

### **Run on a Physical Android Device**

1.  Enable **USB Debugging** on your phone (Settings > Developer Options).
2.  Connect the device via USB.
3.  Check if Flutter detects it:

    nginx

    CopyEdit

    `flutter devices`

4.  Run the app on the phone:

    arduino

    CopyEdit

    `flutter run -d <device_id>`

* * * * *

**6\. Running on iOS (Mac Only)**
---------------------------------

### **Run on an iOS Simulator**

1.  **List available iOS devices**:

    arduino

    CopyEdit

    `open -a Simulator`

    Or check:

    nginx

    CopyEdit

    `flutter devices`

2.  **Start an iOS Simulator** (e.g., iPhone 14 Pro):

    arduino

    CopyEdit

    `open -a Simulator`

3.  **Run the app on the simulator**:

    arduino

    CopyEdit

    `flutter run -d iOS`

### **Run on a Physical iPhone**

1.  **Enable Developer Mode** on the iPhone (Settings > Privacy & Security > Developer Mode).
2.  **Connect the iPhone via USB.**
3.  **Run the app on the iPhone**:

    arduino

    CopyEdit

    `flutter run -d <device_id>`

4.  **Xcode Configuration (Only Required for the First Time)**
    -   Open `ios/Runner.xcworkspace` in Xcode.
    -   Set the **Development Team** in `Signing & Capabilities`.
    -   Run:

        nginx

        CopyEdit

        `flutter build ios`

* * * * *

**7\. Running the App**
-----------------------

Run the app with:

arduino

CopyEdit

`flutter run`

Flutter will detect the connected **device/emulator** and start the app.

* * * * *

**8\. Exploring the App**
-------------------------

-   **Splash Screen**: Animated Lottie screen that smoothly transitions based on auth status.
-   **Login Page**: Sign in with Email/Password, Google, or Phone OTP (or bypass in debug mode).
-   **Home Screen**: Bottom navigation with **Dashboard, Bookings, Profile**.
-   **Booking Flow**: Parents **create/manage bookings**; Babysitters **accept/reject** requests.
-   **Profile Page**: User profile and settings.

* * * * *

**9\. Additional Commands**
---------------------------

-   **Clear Flutter cache**:

    nginx

    CopyEdit

    `flutter clean`

-   **Reinstall dependencies**:

    arduino

    CopyEdit

    `flutter pub get`

-   **Run in profile mode (faster, optimized)**:

    arduino

    CopyEdit

    `flutter run --profile`

-   **Run in release mode (production build)**:

    arduino

    CopyEdit

    `flutter run --release`

-   **Build APK (Android release build)**:

    nginx

    CopyEdit

    `flutter build apk`

-   **Build iOS app**:

    nginx

    CopyEdit

    `flutter build ios`

* * * * *

**10\. Common Issues & Fixes**
------------------------------

### **1\. Firebase AuthProvider Conflict**

**Error:**

pgsql

CopyEdit

`AuthProvider is imported from both 'firebase_auth_platform_interface' and 'providers/auth_provider.dart'`

**Solution:**\
Hide Firebase's AuthProvider:

dart

CopyEdit

`import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:littleguardian/providers/auth_provider.dart';`

### **2\. Unable to Load Lottie JSON**

**Error:**

pgsql

CopyEdit

`Unable to load asset: assets/splash_anim.json`

**Solution:**\
Make sure `assets/splash_anim.json` is listed in `pubspec.yaml`:

yaml

CopyEdit

`flutter:
  assets:
    - assets/splash_anim.json`

Then run:

arduino

CopyEdit

`flutter pub get`

### **3\. "The getter 'userBookings' isn't defined"**

**Solution:**\
Make sure `BookingProvider` has:

dart

CopyEdit

`List<Booking> get userBookings => _myBookings;`

And reference it correctly in the UI:

dart

CopyEdit

`final bookingProv = Provider.of<BookingProvider>(context);
final bookings = bookingProv.userBookings;`

* * * * *

**11\. Customization & Future Enhancements**
--------------------------------------------

1.  **UI Theming**: Customize `theme.dart` with new colors, fonts, and styles.
2.  **Performance**: Implement lazy loading, Firestore indexes, and caching for faster response times.
3.  **Real-Time Chat**: Add **Firebase Firestore chat** for parent-babysitter communication.
4.  **Payments**: Integrate **Stripe or PayPal** for secure transactions.
5.  **Background Checks**: Use **Checkr or Onfido** for verifying babysitters.
6.  **AI Matching**: Implement ML-based babysitter recommendations.
7.  **PWA/Web Support**: Consider adding Flutter Web support for **desktop usage**.

* * * * *

**12\. Conclusion**
-------------------

With these steps and command-line instructions, you can **install**, **run**, and **debug** the **LittleGuardian** babysitting/childcare app easily. It's designed to be scalable, with **Firebase authentication**, **role-based navigation**, and a **refined UI**.

Start the app, explore, and expand it with additional features. Happy coding! 🚀