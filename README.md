# Backend Broadcast Management System
🖥️ Full-Stack Broadcast Backend API

✨ Description

The Backend API powers the Full-Stack Broadcast System. Built using Ruby on Rails 7, it handles authentication, device registration, and broadcast delivery. The API uses Devise + JWT for secure user authentication, and integrates with Expo/Firebase to send push notifications to mobile devices. It also supports real-time updates using ActionCable, allowing immediate synchronization between web and mobile clients. PostgreSQL ensures reliable and scalable data storage, making the backend robust and performant.

# 🛠 Tech Stack & Tools Used

💎 Ruby on Rails 7 – Backend framework

🗄 PostgreSQL – Database

🔑 Devise + JWT – Authentication & token management

🔔 Expo / Firebase – Push notifications

⚡ ActionCable – Real-time WebSocket support

🌐 RESTful API – /api/v1 endpoints

🔥 Firebase

🔔 Token management for push notifications

⚡ Instant delivery to mobile devices

✅ Ensures device uniqueness

⚛️ React Native Integration

📱 Optimized API endpoints for mobile clients

⚡ Real-time updates for seamless mobile UX

# ⚙️ Installation & Run

Clone the repository:

git clone <repo-url>
cd broadcast_api


Install dependencies:

bundle install


Set up the database:

rails db:create db:migrate db:seed


Start the server:

rails s -p 3001


API available at: http://localhost:3001/api/v1

# 👤 Author

James Ivan Gabarda

Full Stack Developer | Software Developer
