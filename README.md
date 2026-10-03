# Spendly — Mini Expense Tracker

Spendly is a simple Flutter-based expense tracking application developed as part of my Flutter internship. The app allows users to record, manage, search, filter, and delete expenses through a clean and simple interface.

## Features

* Dashboard with total expense overview
* Add new expenses
* Edit existing expenses
* Delete expenses
* View all recorded expenses
* Search expenses by title
* Filter expenses by category
* Select expense date using a date picker
* Expense categories:

  * Food
  * Transport
  * Shopping
  * Bills
  * Education
  * Entertainment
  * Other
* Total expense calculation
* Form validation for title and amount
* Local data persistence using SharedPreferences
* Material 3 user interface
* Responsive Flutter Web interface
* Production deployment through Vercel

## Expense Information

Each expense contains:

* Title
* Amount
* Category
* Date
* Unique ID

## Technologies Used

* Flutter
* Dart
* Material 3
* SharedPreferences
* Flutter Web
* Vercel
* GitHub

## Project Structure

```text
mini_expense_tracker/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   └── expense.dart
│   │
│   ├── screens/
│   │   ├── add_expense_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── expense_list_screen.dart
│   │
│   ├── widgets/
│   │   └── expense_card.dart
│   │
│   └── theme/
│       └── app_theme.dart
│
├── build/
│   └── web/
│
├── pubspec.yaml
└── README.md
```

## How the Application Works

### Dashboard

The dashboard provides an overview of the user's expenses and gives access to the main expense-management features.

### Add Expense

Users can enter:

1. Expense amount
2. Expense title
3. Category
4. Date

The form validates the entered information before saving the expense.

### Expense List

The expense list displays all saved expenses. Users can:

* Search for an expense
* Filter expenses by category
* Edit an expense
* Delete an expense

### Local Storage

Expense data is stored locally using SharedPreferences. This allows the saved expenses to remain available after closing and reopening the application.

## Validation

The application validates user input before saving an expense.

Examples include:

* Amount cannot be empty.
* Amount must be a valid number.
* Amount must be greater than zero.
* Expense title cannot be empty.
* Expense title must contain at least two characters.

## Running the Project

Make sure Flutter is installed and configured correctly.

Clone the repository:

```bash
git clone https://github.com/mehmoodul024-art/mini_expense_tracker.git
```

Open the project:

```bash
cd mini_expense_tracker
```

Get the dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

To run the project as a web application:

```bash
flutter run -d chrome
```

## Building for Web

To generate the Flutter Web production build:

```bash
flutter build web
```

The generated files are placed inside:

```text
build/web
```

## Deployment

The project is connected to GitHub and deployed on Vercel.

GitHub Repository:

[https://github.com/mehmoodul024-art/mini_expense_tracker](https://github.com/mehmoodul024-art/mini_expense_tracker?utm_source=chatgpt.com)

Live Demo:

[https://miniexpensetracker-five.vercel.app/](https://miniexpensetracker-five.vercel.app/?utm_source=chatgpt.com)

The `main` branch is connected to Vercel, so new commits pushed to GitHub can trigger a new production deployment.

## What I Learned

During the development of this project, I worked with:

* Flutter application structure
* StatefulWidget and state management
* Navigation between screens
* Form validation
* Date selection
* Expense filtering and searching
* CRUD operations for expenses
* Local data persistence using SharedPreferences
* Flutter Web builds
* Git and GitHub
* Vercel deployment
* Debugging Flutter and Gradle-related issues

## Day 2 Work

The Day 2 task focused on improving the basic expense tracker by implementing proper expense management functionality.

Completed work included:

* Add expense
* View expense list
* Edit expense
* Delete expense
* Category selection
* Date selection
* Total expense calculation
* Input validation
* Search and filtering functionality

## Day 3 Work

The Day 3 work focused on improving the application and making it more practical for continued use.

Completed improvements included:

* Local expense persistence using SharedPreferences
* Improved expense management
* Search and category filtering
* Edit and delete functionality
* Improved user interface
* Flutter Web production build
* GitHub repository update
* Vercel production deployment

## Future Improvements

Possible future improvements include:

* Cloud database integration
* User authentication
* Expense charts and analytics
* Monthly spending reports
* Budget management
* Exporting expenses
* Cloud synchronization

## Author

**Syed Mehmood ul Hassan Kazmi**

BS Software Engineering
COMSATS University Islamabad, Wah Campus
