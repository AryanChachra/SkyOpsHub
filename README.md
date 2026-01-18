# SkyOpsHub Marketing Website

A modern, responsive marketing website for SkyOpsHub - an AI-driven airline operations management platform. Built with Flutter Web for optimal performance and cross-platform compatibility.

## 🚀 Features

- **Responsive Design**: Seamlessly adapts to desktop, tablet, and mobile devices
- **Dual Theme System**: Light and dark themes with automatic system detection
- **Interactive Animations**: Smooth hover effects, transitions, and engaging animations
- **Modern UI Components**: Professional design with compelling call-to-actions
- **SEO Optimized**: Proper meta tags, structured data, and social media integration
- **Performance Focused**: Optimized assets and efficient Flutter Web implementation

## 🎨 Sections

- **Hero Section**: Eye-catching introduction with primary CTAs
- **About Section**: Company overview and mission statement
- **Features Section**: Key platform capabilities and benefits
- **Value Proposition**: Why choose SkyOpsHub over competitors
- **Product Links**: Live platform demo and GitHub repository access
- **Open Source**: Community contributions and development transparency
- **Technology Stack**: Detailed technical architecture overview
- **Contact Section**: Multiple ways to connect and schedule demos
- **Footer**: Additional navigation and company information

## 🛠️ Technology Stack

- **Frontend**: Flutter Web 3.x
- **State Management**: Provider pattern
- **Responsive Framework**: Custom responsive breakpoints
- **Animations**: Flutter's built-in animation controllers
- **URL Launcher**: External link handling
- **Theme System**: Material Design 3 with custom SkyOps branding

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Web browser for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/skyopshub/skyopshub-website.git
cd skyopshub-website
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the development server:
```bash
flutter run -d chrome
```

4. Build for production:
```bash
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
├── providers/                # State management
├── theme/                    # Theme configuration
├── utils/                    # Utility functions and responsive breakpoints
└── widgets/
    ├── cards/               # Reusable card components
    ├── footer/              # Footer widget
    ├── navigation/          # Navigation components
    ├── sections/            # Main page sections
    └── main_layout.dart     # Main layout wrapper
```

## 🎯 Key Features Implemented

### Responsive Design
- Mobile-first approach with breakpoint-based layouts
- Adaptive navigation (hamburger menu on mobile)
- Flexible grid systems and responsive containers

### Theme System
- Light and dark theme variants
- System theme detection on startup
- Smooth theme transitions
- Theme-aware color schemes throughout

### Interactive Elements
- Hover effects with proper cursor feedback
- Smooth animations and transitions
- Interactive cards with scaling effects
- Engaging call-to-action buttons

### Performance Optimizations
- Optimized asset loading
- Efficient widget rebuilding
- Proper animation disposal
- Responsive image sizing

## 🌐 Deployment

The website is optimized for deployment on:
- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting
- Any static web hosting service

### Build Commands

```bash
# Development build
flutter build web

# Production build with optimizations
flutter build web --release --web-renderer html

# Build with specific base href (for subdirectory deployment)
flutter build web --release --base-href /your-subdirectory/
```

## 📱 Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge
- Mobile browsers (iOS Safari, Chrome Mobile)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Live Website**: [https://skyopshub.in](https://skyopshub.in)
- **Platform Demo**: [https://app.skyopshub.in](https://app.skyopshub.in)
- **GitHub Repository**: [https://github.com/skyopshub](https://github.com/skyopshub)
- **Contact**: [contact@skyopshub.in](mailto:contact@skyopshub.in)

## 📞 Support

For support, email contact@skyopshub.in or join our community discussions.

---

Built with ❤️ by the SkyOpsHub team using Flutter Web
