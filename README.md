<div align="center">

# Tactile 🎙️ (The Semantic Audio Engine)

## Project Description 🧠

"Tactile is a proof of concept that accessibility is not an overlay; it is an architecture. By decoupling the user interface from the visual layer, this project demonstrates how `UIAccessibility` can function as the primary interaction model, creating a truly 'eyes-free' experience that is robust for VoiceOver users and intuitive for everyone else."

---
</div>

## Features

- **Semantic Navigation:** Browse audio timelines using semantic headers rather than visual scrolling.
- **Spatial Audio Cues:** 3D audio placement assigns "Work" notes to the right ear and "Personal" notes to the left.
- **Haptic Choreography:** Custom Core Haptics patterns distinguish between "Success," "Delete," and "End of List" interactions.
- **Privacy by Design:** All speech processing and logic occur on-device.

---

## Technologies Used 💻

This project leverages deep integration with the iOS Accessibility stack and Audio frameworks.

- [x] Swift
- [x] UIAccessibility
- [x] AVFoundation
- [x] Core Haptics
- [x] Speech (SFSpeechRecognizer)
- [x] Natural Language (NLP)
- [x] SwiftUI
- [x] Combine
- [x] UIKit (App Delegate/Lifecycle)

## Skills Demonstrated 🥋

This project demonstrates the technical competencies required for professional Accessibility Engineering:

- [x] **Universal Design Architecture:** Building a single codebase where the Accessibility Tree is the primary source of truth for navigation.
- [x] **Advanced VoiceOver APIs:** Implementation of `UIAccessibilityCustomRotor`, `.allowsDirectInteraction`, and Custom Actions.
- [x] **Focus Management:** Programmatic control of the accessibility cursor using Layout Changed and Screen Changed notifications.
- [x] **Haptic Design:** Creating accessible tactile feedback loops to reinforce audio cues for the hearing impaired.
- [x] **State Synchronization:** Managing complex state between the visual layer, the audio engine, and the accessibility engine.

## Contributing ⚙️

We welcome contributions from engineers interested in **Assistive Technologies**. If you have ideas for improving the semantic tagging or haptic patterns, please fork the repo and submit a PR.

## License 🪪

This project is licensed under the MIT License.

</div>
