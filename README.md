# 📦 MokeSell Database System

**MokeSell** is a relational database project designed to support a peer-to-peer online marketplace platform. The system models real-world marketplace interactions such as users buying and selling items, listing promotions, offers, messaging, feedback handling, and staff operations.

This project was developed as part of a **Database Systems academic assignment**, with a focus on **data modeling, normalization, SQL schema design, and relational integrity**.

---

## 🔧 Key Features

- **Comprehensive Relational Schema**
  - Supports members acting as **buyers and sellers**
  - Product listings organized by **categories and subcategories**
  - Promotions via a **bump system**
  - Social interactions such as **likes and followers**

- **Transaction & Interaction Tracking**
  - Offers and reviews linked to listings
  - Real-time messaging using chat and chat messages
  - Feedback system managed by support staff and teams

- **Administrative & Analytics Support**
  - Staff and team management
  - Awards and performance tracking
  - Query-ready structure for reporting and analytics

---

## 🗄️ Database Design

- **Entities include:**
  - `Member`, `Buyer`, `Seller`, `Listing`, `Offer`, `Review`
  - `Category`, `SubCategory`, `Bump`, `BumpOrder`
  - `Chat`, `ChatMsg`, `Feedback`, `Likes`, `Follower`
  - `Staff`, `Team`, `Award`, `Wins`

- **Design principles applied:**
  - Normalized schema (up to **Third Normal Form – 3NF**)
  - Primary and foreign key constraints
  - Data validation using `CHECK` constraints
  - Referential integrity across all relationships

---

## 🧪 Technologies Used

- **SQL Server (T-SQL)**
- SQL DDL & DML
- Entity–Relationship (ER) Modeling
- Relational Database Normalization

---
