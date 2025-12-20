# LEDGERLY — Smart Receipt & Expense Management

<img width="2816" height="1536" alt="Gemini_Generated_Image_55nbn955nbn955nb" src="https://github.com/user-attachments/assets/e358cce4-bf17-4d90-9f8f-7354046017fb" />

A Flutter-based smart expense management app that turns physical receipts into structured financial data, enables seamless family expense sharing, and delivers AI-powered spending insights — all in one place.

---

## ✨ Overview

Ledgerly helps individuals and families manage receipts, track expenses, and split bills without manual effort. Using vision-based receipt scanning, automated calls, email workflows, and analytics, the app converts scattered financial records into clear, actionable insights.

Whether it’s day-to-day spending or shared family expenses, Raseed keeps everything organized, transparent, and easy to act on.

![WhatsApp Image 2025-12-20 at 2 06 45 PM](https://github.com/user-attachments/assets/c56d5e28-26ab-4aad-a81f-234d4b666ca3)


---

## 🧱 Tech Stack

<img width="879" height="521" alt="image" src="https://github.com/user-attachments/assets/6b84226b-cf37-4e60-bb5f-9e5cdf5c257d" />


- **Flutter** – Cross-platform mobile development  
- **Firebase** – Authentication & Firestore database  
- **Provider** – State management  
- **Home Widget** – Native Android/iOS widgets  
- **FL Chart** – Interactive analytics & charts  
- **Image Picker** – Camera & gallery access  
- **Geolocator** – Location-based receipt tagging  

---

## 🔄 System Data Flow

### Receipt Processing

Camera / Gallery
↓
Vision API (10.95.243.157:5001)
↓
Receipt Data Extraction
↓
Firebase Firestore
↓
UI Update (Provider)

### Expense Pass Workflow

User Creates Pass
↓
Family Provider
↓
Email Service
↓
Group Members
↓
Call Service (10.95.243.157:3004)
↓
Automated Voice Calls
↓
Accept / Reject via Email or App

### Home Widget Interaction

Android Home Widget
↓
MainActivity
↓
Flutter Method Channel
↓
Widget Service
↓
Camera / Gallery / Assist Screen


---

## 🚀 Key Features

### 📸 Smart Receipt Scanning
- Capture receipts via camera or gallery  
- AI-based vision extraction (merchant, amount, date, items)  
- Automatic GPS location tagging  
- Secure cloud storage using Firebase  

### 👨‍👩‍👧‍👦 Family Hub & Expense Sharing
- Create and manage family or team groups  
- Split expenses automatically using Expense Passes  
- Automated voice calls via REST API  
- Email notifications with Accept / Reject actions  
- Real-time tracking of member responses  

### 📊 Analytics & Insights
- Spending trends over time  
- Category-wise expense breakdown  
- Budget velocity tracking (daily / weekly / monthly)  
- Period-to-period comparison  
- ML-driven insights and anomaly detection  

### 🤖 AI Assistant
- Natural language spending queries  
- Context-aware responses based on user data  
- Smart budget optimization suggestions  
- Demo-ready mock responses for sample users  

### 📱 Android Home Widget
- One-tap access to Camera, Gallery, and Assist  
- View recent bills instantly  
- Track active / pending expenses  
- Smooth Flutter ↔ Android integration  

### 🎨 UI & Experience
- Clean dark mode interface  
- Material 3 design system  
- Responsive layouts  
- Smooth animations and transitions  

---

## ⚡ Getting Started

### Prerequisites
- Flutter SDK `>=3.4.4 <4.0.0`  
- Dart SDK  
- Android Studio / Xcode  
- Firebase project  
- Vision API running at `10.95.243.157:5001`  
- Call API running at `10.95.243.157:3004`  

---

### Installation Steps

1. Clone the repository  
2. Install dependencies  
3. Configure Firebase  
   - Update `firebase_service.dart`  
   - Add `google-services.json` to `android/app`  
   - Add `GoogleService-Info.plist` to `ios/Runner`  

4. Set up backend services  
   - Vision API → `http://10.95.243.157:5001`  
   - Call API → `http://10.95.243.157:3004`  
   - Update endpoints in `vision_receipt_service.dart` if required  

5. Configure email service  
   - Update SMTP credentials in `smtp_email_service.dart`  
   - Or switch to `webhook_email_service.dart`  

6. Run the app  
```bash
flutter run
```

## 🧪 Usage Guide

### Scanning a Receipt
- Tap the **+** button on the Receipts screen  
- Choose **Camera** or **Gallery**  
- Capture or select an image  
- Receipt data is extracted automatically  
- Receipt appears with complete details  

```dart
Receipt(
  merchantName: "Cafe Coffee Day",
  amount: 250.0,
  date: DateTime.now(),
  category: "Food & Dining",
  items: ["Cappuccino", "Sandwich"],
)
```

## 🗂️ Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── receipt.dart
│   ├── family_group.dart
│   ├── expense_pass.dart
│   └── chart_data.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── receipts_screen.dart
│   ├── family_hub_screen.dart
│   ├── assist_screen.dart
│   └── expense_analytics_screen.dart
├── providers/
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   └── family_provider.dart
├── services/
│   ├── firebase_service.dart
│   ├── vision_receipt_service.dart
│   ├── call_service.dart
│   ├── email_service.dart
│   └── widget_service.dart
├── widgets/
│   ├── spending_chart.dart
│   ├── progress_bar.dart
│   └── expense_pass_popup.dart
└── utils/
    ├── constants.dart
    └── helpers.dart

android/
├── MainActivity.kt
├── FloatingWidgetService.kt
└── RaseedWidgetProvider.kt
