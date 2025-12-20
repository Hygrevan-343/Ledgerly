Here’s your complete README in markdown format with the architecture image embedded at the top:

```markdown
# Raseed - Smart Receipt Management

![System Architecture](attachments/jfs5BjhuUSdQNWUnp3hp9.png)

A comprehensive Flutter-based expense tracking application with AI-powered insights, family expense sharing, and automated receipt processing through vision recognition.

---

## About the Project

Ledgerly is a modern financial management solution that helps users track expenses, manage receipts, and split bills within family groups or teams. The app leverages AI and vision recognition to automatically extract data from receipts, provides intelligent spending insights, and facilitates seamless expense sharing through automated voice calls and email notifications.

---

## Built With

- **Flutter** – Cross-platform UI framework  
- **Firebase** – Backend services (Firestore, Authentication)  
- **Provider** – State management  
- **Home Widget** – Native Android/iOS widget support  
- **FL Chart** – Data visualization  
- **Image Picker** – Camera and gallery access  
- **Geolocator** – Location-based receipt tagging  

---

## Data Flow

### Receipt Processing Flow
```
Camera/Gallery → Vision API (10.95.243.157:5001) → Receipt Data Extraction  
                                                   ↓  
                                    Firebase Firestore Storage  
                                                   ↓  
                                    UI Update (Provider)
```

### Expense Pass Flow
```
User Creates Pass → Family Provider → Email Service → Group Members  
                                  ↓  
                            Call Service (REST API at 10.95.243.157:3004)  
                                  ↓  
                            Voice Call to Members  
                                  ↓  
                        Member Accepts/Rejects via Email/App
```

### Widget Interaction Flow
```
Home Widget (Android) → MainActivity → Flutter Channel → Widget Service  
                                                         ↓  
                                              Camera/Gallery/Assist Screen
```

---

## Key Features

### 📸 Smart Receipt Scanning
- Camera Integration: Capture receipts directly from the app  
- Vision Recognition: Automatic data extraction (merchant, amount, date, items)  
- Location Tagging: GPS coordinates attached to receipts  
- Firebase Storage: Cloud-based receipt management  

### 👨‍👩‍👧‍👦 Family Hub & Expense Sharing
- Group Management: Create and manage family/team groups  
- Expense Pass System: Split bills automatically among members  
- Voice Call Integration: REST API-based automated calls to notify members  
- Email Notifications: SMTP-based expense pass notifications with Accept/Reject links  
- Real-time Status: Track who has accepted or rejected expense passes  

### 📊 Analytics Dashboard
- Spending Trends: Visualize expenses over time with interactive charts  
- Category Breakdown: Detailed analysis by spending categories  
- AI Insights: ML-powered spending recommendations and anomaly detection  
- Budget Tracking: Monitor daily, weekly, and monthly spending velocity  
- Period Comparison: Compare spending across different time periods  

### 🤖 AI Assistant
- Natural Language Queries: Ask about spending in plain language  
- Personalized Responses: Context-aware answers based on user data  
- Spending Suggestions: Smart recommendations for budget optimization  
- Mock Responses: Pre-configured responses for Kavinesh's spending patterns  

### 📱 Home Widget (Android)
- Quick Actions: Camera, Gallery, and Assist shortcuts  
- Recent Bills: Display latest transactions  
- Total Active Bills: Overview of pending payments  
- Native Integration: Seamless Flutter-Android communication  

### 🎨 Modern UI/UX
- Dark Theme: Eye-friendly dark mode design  
- Material 3: Latest Material Design components  
- Responsive Layout: Adapts to different screen sizes  
- Smooth Animations: Polished transitions and interactions  

---

## Quick Start

### Prerequisites
- Flutter SDK (>=3.4.4 <4.0.0)  
- Dart SDK  
- Android Studio / Xcode (for mobile development)  
- Firebase account  
- Vision API server running at `10.95.243.157:5001`  
- Call API server running at `10.95.243.157:3004`  

### Installation
1. Clone the repository  
2. Install dependencies  
3. Configure Firebase  
   - Update `firebase_service.dart` with your Firebase credentials  
   - Place your `google-services.json` in `app`  
   - Place your `GoogleService-Info.plist` in `Runner`  

4. Set up Vision & Call APIs  
   - Ensure backend servers are running:  
     - Vision API: `http://10.95.243.157:5001`  
     - Call API: `http://10.95.243.157:3004`  
   - Update endpoints in `vision_receipt_service.dart` if needed  

5. Configure Email Service  
   - Update SMTP credentials in `smtp_email_service.dart`  
   - Or use webhook service in `webhook_email_service.dart`  

6. Run the app  

---

## Usage

### Scanning Receipts
- Tap the floating action button (+) on the Receipts screen  
- Select Camera or Gallery  
- Capture or pick an image  
- Vision API extracts receipt data  
- Receipt appears in your list with all details  

```dart
Receipt(
  merchantName: "Cafe Coffee Day",
  amount: 250.0,
  date: DateTime.now(),
  category: "Food & Dining",
  items: ["Cappuccino", "Sandwich"],
)
```

### Creating Expense Passes
- Navigate to Family Hub  
- Select Group  
- Pick Receipt  
- Initiate Call  
- Track Responses  

### Using the AI Assistant
- Tap on Assist tab  
- Ask questions like:  
  - "Show my monthly spending summary"  
  - "How much did I spend on education?"  
  - "What was my peak spending day?"  

### Adding Home Widget (Android)
- Long Press on home screen  
- Add "Raseed Widget"  
- Quick Actions:  
  - Camera icon → Opens camera  
  - Gallery icon → Opens gallery  
  - Assist icon → Opens AI assistant  

### Managing Family Groups
- Create Group → '+' button → Enter group name  
- Add Members → 'Add Member' → Enter email  

### Viewing Analytics
- Dashboard: Overview of total spending and trends  
- Expense Analytics: Detailed charts and insights  
  - Category breakdown pie chart  
  - Spending trend line chart  
  - Velocity metrics cards  
  - ML-powered recommendations  
- Filter Options: Time period, categories, date ranges  

---

## Understanding Spending Data

**Kavinesh's Sample Data (Demo):**
- Monthly Total: ₹28,750  
- Daily Average: ₹959  
- Biggest Category: Education (₹25,000)  
- Peak Day: Saturday (₹1,860)  

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── receipt.dart
│   ├── family_group.dart
│   ├── expense_pass.dart
│   └── chart_data.dart
├── screens/                     # UI screens
│   ├── dashboard_screen.dart
│   ├── receipts_screen.dart
│   ├── family_hub_screen.dart
│   ├── assist_screen.dart
│   └── expense_analytics_screen.dart
├── providers/                   # State management
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   └── family_provider.dart
├── services/                    # Business logic
│   ├── firebase_service.dart
│   ├── vision_receipt_service.dart
│   ├── call_service.dart
│   ├── email_service.dart
│   └── widget_service.dart
├── widgets/                     # Reusable components
│   ├── spending_chart.dart
│   ├── progress_bar.dart
│   └── expense_pass_popup.dart
└── utils/                       # Utilities
    ├── constants.dart
    └── helpers.dart

android/
├── app/src/main/kotlin/com/example/ui/
│   ├── MainActivity.kt
│   ├── FloatingWidgetService.kt
│   └── RaseedWidgetProvider.kt
└── app/src/main/res/
    ├── layout/raseed_widget.xml
    └── xml/raseed_widget_info.xml
```
```

Let me know if you'd like this exported to a file or styled for a specific platform like GitHub or GitLab.
