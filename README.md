# PlainAid 🎯

[![Elixir](https://img.shields.io/badge/Elixir-1.19-brightgreen)](https://elixir-lang.org/)
[![Phoenix](https://img.shields.io/badge/Phoenix-1.7-blue)](https://www.phoenixframework.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

**Transform complex text into clear, actionable information**

PlainAid is a real-time web application that simplifies formal documents and structures clear text into actionable insights. Built with Elixir and Phoenix LiveView, it provides instant analysis of complex legal, governmental, and formal communications—with complete privacy.

🔗 **Live Demo:** [https://yourapp.onrender.com](https://yourapp.onrender.com)

---

## ✨ Features

### 🔄 Two Processing Modes

**1. Simplify Mode**
- Designed for complex, formal, or legal text
- Converts technical jargon to 8th-grade reading level
- Extracts actionable information from dense documents

**2. Structure Mode**
- For clear text that needs better organization
- Preserves original detail and tone
- Creates actionable breakdown with proper categorization

### 📊 Smart Output Structure
Every analysis provides:
- ✅ **Simple Summary** - Clear overview in plain language
- ⚠️ **Required Actions** - What you must do
- ⏰ **Important Deadlines** - Time-sensitive items
- 🚨 **Risks** - Consequences of not acting
- ✓ **Optional Items** - Supplementary information

### 🔐 Privacy-First Design
- No user accounts or authentication required
- Zero data storage or persistence
- No tracking or analytics
- Text processed in real-time only
- Secure API communication

---

## 🚀 Use Cases
- **Legal Documents:** Understand contracts, agreements, and legal notices
- **Immigration:** Decode visa applications, asylum letters, and official correspondence
- **Banking & Finance:** Clarify bank notices, loan documents, and financial statements
- **Healthcare:** Simplify medical instructions and insurance policies
- **Government:** Break down bureaucratic communications and policy documents
- **Education:** Understand academic policies and institutional guidelines

---

## 🛠️ Tech Stack

| Component         | Technology                     |
|------------------|--------------------------------|
| Language          | Elixir 1.19                    |
| Framework         | Phoenix 1.7                    |
| Real-time UI      | Phoenix LiveView               |
| AI Processing     | Groq API (Llama 3.3 70B)      |
| HTTP Client       | HTTPoison                      |
| JSON              | Jason                          |
| Styling           | Tailwind CSS                   |
| Deployment        | Render.com                     |

---

## 🏗️ Architecture

User
│
▼
Phoenix LiveView (Real-time UI Layer)
│
▼
Simplifier Module (Business Logic)
│
▼
Groq API (AI Processing)
│
▼
Structured JSON (Output)

yaml
Copy code

**UI Screenshot Placeholder:**

![PlainAid UI](https://via.placeholder.com/800x400.png?text=PlainAid+UI+Screenshot)

---

## 🚀 Getting Started

### Prerequisites
- Elixir 1.19 or higher
- Erlang/OTP 28 or higher
- A Groq API key (free tier available)

### Installation

```bash
git clone https://github.com/aliabdm/plainaid.git
cd plainaid
mix deps.get
Environment Variables
bash
Copy code
# Unix/Linux/macOS
export GROQ_API_KEY="your_groq_api_key_here"

# Windows PowerShell
$env:GROQ_API_KEY="your_groq_api_key_here"
Start the Phoenix server
bash
Copy code
mix phx.server
Visit http://localhost:4000 in your browser.

🌍 Deployment
Deploy to Render.com:

Fork/Clone the repository

Sign up on Render

Create a new Web Service

Connect your GitHub repository

Configure the service:

Name: plainaid

Region: closest to your users

Branch: main

Runtime: Elixir

Build Command: mix deps.get --only prod && MIX_ENV=prod mix compile && MIX_ENV=prod mix assets.deploy

Start Command: mix phx.server

Add environment variables:

SECRET_KEY_BASE = [Click Generate]

GROQ_API_KEY = your Groq API key

PHX_HOST = yourapp.onrender.com

PORT = 4000

MIX_ENV = prod

Select Free tier and deploy

💻 Development
Project Structure
bash
Copy code
plainaid/
├── lib/
│   ├── plainaid/
│   │   └── simplifier.ex          # Core business logic
│   └── plainaid_web/
│       ├── live/
│       │   └── simplifier_live.ex # LiveView component
│       └── router.ex               # Route definitions
├── assets/                         # CSS and JS
├── config/                         # Configuration files
└── mix.exs                         # Dependencies
Running Tests
bash
Copy code
mix test
Code Quality
bash
Copy code
# Format code
mix format

# Check for code issues
mix credo
🤝 Contributing
Fork the repository

Create a feature branch: git checkout -b feature/amazing-feature

Commit your changes: git commit -m 'Add amazing feature'

Push the branch: git push origin feature/amazing-feature

Open a Pull Request

Ideas for Contributions
Multi-language support (Arabic, Spanish, French, etc.)

PDF file upload and processing

Export results to PDF/DOCX

Browser extension (Chrome/Firefox)

Batch processing for multiple documents

User preferences (without accounts)

Improved error handling

More comprehensive tests

📝 Changelog
v1.0.0 (2025-12-27)

Initial release

Two processing modes (Simplify & Structure)

Real-time processing with LiveView

Privacy-first design

Deployed on Render

📜 License
MIT License © 2025 Ali Abdulmajeed

👨‍💻 Author
Mohammad Ali Abdul-Wahed
GitHub: @aliabdm
LinkedIn: https://www.linkedin.com/in/mohammad-ali-abdul-wahed-1533b9171/