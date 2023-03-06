## AI Assisted Groceries Cart

This project is a starting point for a Flutter application enhanced with help of GitHub Copilot to create a AI assisted groceries cart.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Pre-request

- An Azure Subscription with Azure OpenAI service deployed

## Launch the app

To run the app pass along the URL to an Azure OpenAI instance as well as the key as environment variables.

`flutter run --dart-define=AZ_OPENAI_URL="https://<MyAzOpenAI>.openai.azure.com/openai/deployments/<myModelDeployment>/completions?api-version=2022-12-01" --dart-define=AZ_OPENAI_KEY="MyKey"`
