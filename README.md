# parkr

UNB Parking Management System

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Developing

> Work in progress - just tentative now

1. Install the amplify cli:
   
    ```bash
    npm install -g @aws-amplify/cli
    ```

2. Pull all of the backend configuration through the Amplify service:
   
    ```bash
    amplify pull --appId d2hizxojn9njyk --envName dev
    ```

    - Select 'Yes' when it asks if you will work on the backend. This will pull all of the cloudformation and lambda scripts.
    - You will need AWS creds, too. Ask Justen for them, they are tied to his account & credit card.

3. Get dependencies specified in *pubspec.yaml*: `flutter pub get`