# Aviation Images for SkyOpsHub Website

This directory should contain optimized aviation imagery for the website redesign.

## Required Images (WebP format, optimized for web)

### Hero Section Images
- **hero_dashboard.webp** (1200x800px, <200KB)
  - Dashboard preview showing flight operations interface
  - Should display real-time flight data, crew schedules, or optimization metrics
  - Can be anonymized/blurred to protect sensitive data
  - Fallback: Dashboard icon placeholder

- **hero_aircraft.webp** (1200x800px, <200KB)
  - Modern commercial aircraft (preferably on runway or in flight)
  - Professional aviation photography
  - Fallback: Flight icon placeholder

- **hero_control_center.webp** (1200x800px, <200KB)
  - Airline operations control center or dispatch room
  - Shows operational environment
  - Fallback: Control room icon placeholder

### Case Study Images
- **case_study_delay.webp** (800x500px, <150KB)
  - Regional carrier operations imagery
  - Related to delay reduction scenarios
  - Fallback: Flight icon placeholder

- **case_study_turnaround.webp** (800x500px, <150KB)
  - International airline ground operations
  - Aircraft turnaround activities
  - Fallback: Flight icon placeholder

- **case_study_recovery.webp** (800x500px, <150KB)
  - Low-cost carrier operations
  - Recovery operations or crew management
  - Fallback: Flight icon placeholder

- **case_study_crew.webp** (800x500px, <150KB)
  - Crew optimization or scheduling
  - Operations team or flight crew
  - Fallback: Flight icon placeholder

### Flight Operations Imagery
- **flight_operations.webp** (1000x600px, <180KB)
  - General flight operations imagery
  - Can be used across various sections
  - Fallback: Flight icon placeholder

- **aircraft_runway.webp** (1000x600px, <180KB)
  - Aircraft on runway or taxiway
  - Professional aviation photography
  - Fallback: Flight icon placeholder

- **control_room.webp** (1000x600px, <180KB)
  - Operations control room or dispatch center
  - Shows operational environment
  - Fallback: Control room icon placeholder

## Image Optimization Guidelines

### Format
- Use WebP format for best compression and quality
- Provide fallback PNG/JPG if WebP not supported (handled by Flutter)

### Size Optimization
- Hero images: Max 200KB per image
- Case study images: Max 150KB per image
- Use responsive images (different sizes for mobile/desktop if needed)

### Dimensions
- Hero section: 1200x800px (3:2 aspect ratio)
- Case studies: 800x500px (16:10 aspect ratio)
- General imagery: 1000x600px (5:3 aspect ratio)

### Quality
- Use 80-85% quality for WebP compression
- Ensure images remain sharp and professional
- Avoid over-compression that creates artifacts

## Image Sources

### Recommended Sources
1. **Stock Photography** (with proper licensing):
   - Unsplash (free, commercial use)
   - Pexels (free, commercial use)
   - Adobe Stock (paid, high quality)
   - Getty Images (paid, premium quality)

2. **Custom Photography**:
   - Commission aviation photographer
   - Use client-provided imagery (with permission)
   - Anonymize/blur sensitive operational data

3. **Dashboard Screenshots**:
   - Create mockups of SkyOpsHub dashboard
   - Use real interface with anonymized data
   - Ensure no sensitive information is visible

### Search Keywords
- "airline operations center"
- "flight dispatch room"
- "commercial aircraft runway"
- "aviation control center"
- "airline ground operations"
- "aircraft turnaround"
- "flight operations dashboard"

## Implementation Notes

### Lazy Loading
- Images are lazy-loaded using Flutter's Image.asset frameBuilder
- Fade-in animation on load (300ms)
- Improves initial page load performance

### Fallback Handling
- All images have icon-based fallback placeholders
- Fallbacks use aviation-themed icons (flight, dashboard, control room)
- Maintains layout stability when images fail to load

### Accessibility
- All images should have semantic meaning
- Fallback placeholders include descriptive labels
- Images complement content, not replace it

## Adding New Images

1. Optimize image to WebP format:
   ```bash
   # Using cwebp (WebP encoder)
   cwebp -q 85 input.jpg -o output.webp
   ```

2. Add image to `assets/images/` directory

3. Update `pubspec.yaml` if needed (Flutter auto-includes assets/images/)

4. Reference in code using `AviationImageAssets` constants

5. Test fallback behavior by temporarily removing image

## Current Status

⚠️ **Placeholder images not yet added**

The code is ready to display aviation imagery with proper fallback handling. Add the WebP images listed above to complete the implementation.

All image references use the `AviationImageAssets` utility class which provides:
- Centralized asset path management
- Automatic fallback to icon placeholders
- Lazy loading with fade-in animation
- Error handling for missing images
