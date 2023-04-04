# **To do List**

## **About the project**
![profile](https://user-images.githubusercontent.com/88117244/229944650-b31e0f0c-d13d-47f9-851b-74851d66e618.png)


"To do List" is a mobile app for Android developed with the Flutter framework and the Dart programming language. The app allows the user to create a task list where they can add, edit, and delete tasks. The information is saved in a local database created with SQLite.

The app has an inclusion screen with a priority system where the user can add the priority of each task. The priorities are displayed in a card on the main screen. The user interface is designed with a TabBarView system to view ongoing and completed tasks. The AppBar is fully customized and created by the developer, based on the PlayStore design.

## **Project architecture**

The project was organized with the Clean Architecture, which divides the code into layers: data, domain, and presentation. The following is the folder and file structure of the project:

- lib
    - data
        - providers
            - database_provider.dart
            - task_provider.dart
        - task_repository.dart
    - domain
        - model
            - task_model.dart
        - useCases
            - add_use_case.dart
            - delete_use_case.dart
            - update_use_case.dart
    - presentation
        - screens
            - add_task_page.dart
            - home_page.dart
        - widgets
            - my_app_bar.dart
            - priority_button.dart
            - task_list_notifier.dart
            - task_list_widgets.dart
            - text_form_field_builder.dart
            - theme_app.dart
        - app.dart
    - main.dart

## **Prerequisites and how to run the project**

To run the project on your machine, you need to have Flutter and Dart installed in the version indicated below:

- Flutter 3.7.6
- Dart 2.19.3

After installing the dependencies, follow these steps:

1. Clone the repository on your machine.
2. Open the terminal in the project root folder.
3. Type the command **`flutter run`** to run the project.

## **Conclusion**

This is a simple app that can help the user manage their tasks in an organized and efficient way. I hope this project can be useful for you or help you learn more about mobile app development with Flutter and Dart.

Note: This project is still in development and can be improved and adjusted.
