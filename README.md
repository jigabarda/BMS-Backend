Broadcast System — Rails API Backend

The Broadcast System Backend is a Ruby on Rails API that powers a complete broadcast communication system. It handles secure user authentication, device registration for push notifications, broadcast creation and management, and FCM push delivery. The backend exposes clean RESTful JSON endpoints and serves both the Next.js web frontend and the React Native mobile app.

🚀 Features

🔐 User Authentication (Devise, custom JSON controllers)
📱 Device Registration (store mobile device push tokens)
📢 Broadcast Management (create, view, update, delete)
📤 Send Broadcast to all registered devices
🔄 FCM Push Notification Integration
🧩 ActionCable Ready for future real-time features
📁 REST API under /api/v1/*
🛡️ JSON-only with strict auth rules
🧱 Clean, modular MVC structure

🛠 Tech Stack
Ruby 3.x
Rails 7.x (API Mode)
PostgreSQL
Devise Authentication
Axios-friendly JSON responses
ActionCable WebSockets
FCM Push Notifications
Background Job Structure (ActiveJob)

🔧 Installation & Setup

Install dependencies
bundle install

Setup database
rails db:create
rails db:migrate

Start the Rails server
rails s -p 3001

The API runs at:

http://localhost:3000

👨‍💻 Author

James Ivan Gabarda
Full-Stack Developer • Mobile • Web • API Architect
GitHub: (https://github.com/jigabarda)
Portfolio: (https://jigstack.vercel.app/)
