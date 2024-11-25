import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class AIChatController extends GetxController {
  final RxList<types.Message> messages = <types.Message>[].obs;
  final _user = const types.User(id: 'user-id');
  final _bot = const types.User(id: 'bot-id');

  // Define keywords, context words, and their associated responses
  final List<Map<String, dynamic>> botKnowledgeBase = [
    {
      "keyword": "ambulance",
      "contexts": [
        {
          "words": ["request"],
          "response":
              "To request an ambulance, you should call the emergency services number and provide your location and the nature of the emergency."
        },
        {
          "words": ["availability"],
          "response":
              "Ambulances are available 24/7, but availability may depend on your location and current demand."
        },
        {
          "words": ["emergency"],
          "response":
              "In emergencies, an ambulance provides immediate medical care during transport to the hospital."
        },
        {
          "words": ["service"],
          "response":
              "Many ambulance services operate 24/7 and can be contacted through local emergency numbers."
        },
        {
          "words": ["cost"],
          "response":
              "The cost of ambulance services can vary depending on your location and the level of care required."
        },
        {
          "words": ["types", "different"],
          "response":
              "There are various types of ambulances, including basic life support, advanced life support, and specialty units."
        },
        {
          "words": ["waiting", "time"],
          "response":
              "Waiting times for an ambulance can depend on location, traffic, and the urgency of the call."
        },
        {
          "words": ["what"],
          "response":
              "An ambulance is a vehicle equipped for transporting patients in need of urgent medical care."
        },
        {
          "words": ["how"],
          "response":
              "You can call an ambulance by dialing the emergency services number in your area, like 911 or 112."
        },
        {
          "words": ["where"],
          "response":
              "You can find ambulance services by contacting local hospitals or using emergency contact apps."
        },
        {
          "words": ["when"],
          "response":
              "Call an ambulance when someone needs immediate medical assistance, such as during an accident or medical emergency."
        },
        {
          "words": ["why"],
          "response":
              "An ambulance is used to quickly transport patients to medical facilities when urgent care is required."
        },
        {
          "words": ["who"],
          "response":
              "Ambulances are typically operated by trained medical personnel, including paramedics and EMTs."
        },
        {
          "words": ["which"],
          "response":
              "Which ambulance to use depends on the patient's condition and the type of care required during transportation."
        },
        {
          "words": [],
          "response":
              "An ambulance is a specialized vehicle used for transporting patients. How can I assist you further?"
        },
      ]
    },
    {
      "keyword": "first aid",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "First aid refers to the immediate care given to a person suffering from a minor or serious illness or injury."
        },
        {
          "words": ["how"],
          "response":
              "First aid can involve CPR, wound care, and the treatment of shock and other medical emergencies."
        },
        {
          "words": [],
          "response":
              "It's essential to have basic first aid knowledge to respond effectively to emergencies."
        }
      ]
    },
    {
      "keyword": "CPR",
      "contexts": [
        {
          "words": ["how", "to"],
          "response":
              "CPR involves chest compressions and rescue breaths. It's important to follow the correct technique to be effective."
        },
        {
          "words": ["when", "to"],
          "response":
              "Perform CPR if someone is unresponsive and not breathing. Call emergency services immediately."
        },
        {
          "words": ["what", "is"],
          "response":
              "Cardiopulmonary resuscitation (CPR) is a lifesaving technique used in emergencies when someone's breathing or heartbeat has stopped."
        },
        {
          "words": [],
          "response":
              "CPR can double or triple a person's chance of survival after cardiac arrest."
        }
      ]
    },
    {
      "keyword": "injury",
      "contexts": [
        {
          "words": ["types"],
          "response":
              "Common types of injuries include fractures, sprains, strains, and lacerations."
        },
        {
          "words": ["how", "to", "treat"],
          "response":
              "Treatment depends on the type of injury, but basic first aid includes rest, ice, compression, and elevation."
        },
        {
          "words": ["what", "is"],
          "response":
              "An injury is damage to the body that can occur due to accidents, falls, hits, or collisions."
        },
        {
          "words": [],
          "response":
              "Seek medical attention for severe injuries or if you're unsure about the severity."
        }
      ]
    },
    {
      "keyword": "symptom",
      "contexts": [
        {
          "words": ["how", "to", "identify"],
          "response":
              "Identifying symptoms involves being aware of changes in your body and consulting a healthcare professional for evaluation."
        },
        {
          "words": ["what", "are"],
          "response":
              "Symptoms are signs that something may be wrong with your health, such as pain, fatigue, or nausea."
        },
        {
          "words": [],
          "response":
              "Common symptoms include fever, cough, headaches, and muscle pain."
        }
      ]
    },
    {
      "keyword": "disease",
      "contexts": [
        {
          "words": ["types"],
          "response":
              "Diseases can be infectious, genetic, chronic, or autoimmune."
        },
        {
          "words": ["how", "to", "prevent"],
          "response":
              "Preventive measures depend on the disease but may include vaccinations, healthy lifestyle choices, and regular check-ups."
        },
        {
          "words": ["what", "is"],
          "response":
              "A disease is a condition that impairs normal functioning of the body, often characterized by specific signs and symptoms."
        },
        {
          "words": [],
          "response":
              "Always consult a healthcare provider for accurate diagnosis and treatment."
        }
      ]
    },
    {
      "keyword": "allergy",
      "contexts": [
        {
          "words": ["common", "symptoms"],
          "response":
              "Common symptoms include sneezing, itching, rashes, and difficulty breathing."
        },
        {
          "words": ["how", "to", "treat"],
          "response":
              "Treatments may include antihistamines, avoiding allergens, and in severe cases, epinephrine injections."
        },
        {
          "words": ["what", "is"],
          "response":
              "An allergy is a hypersensitive reaction of the immune system to a substance, known as an allergen."
        },
        {
          "words": [],
          "response":
              "Consult an allergist for comprehensive evaluation and management."
        }
      ]
    },
    {
      "keyword": "vaccination",
      "contexts": [
        {
          "words": ["importance"],
          "response":
              "Vaccinations are essential for preventing outbreaks of infectious diseases."
        },
        {
          "words": ["types"],
          "response":
              "Common vaccines include those for measles, mumps, rubella, and influenza."
        },
        {
          "words": ["what", "is"],
          "response":
              "Vaccination is a process that helps your immune system develop protection against specific diseases."
        },
        {
          "words": [],
          "response":
              "Consult your healthcare provider for vaccine recommendations."
        }
      ]
    },
    {
      "keyword": "chronic",
      "contexts": [
        {
          "words": ["management"],
          "response":
              "Management often includes lifestyle changes, medication, and regular check-ups."
        },
        {
          "words": ["what", "is"],
          "response":
              "A chronic condition is a long-lasting health issue that can be controlled but not cured, such as diabetes or asthma."
        },
        {
          "words": [],
          "response":
              "Chronic conditions require ongoing medical care and monitoring."
        }
      ]
    },
    {
      "keyword": "nutrition",
      "contexts": [
        {
          "words": ["importance"],
          "response":
              "Proper nutrition is vital for overall health, growth, and disease prevention."
        },
        {
          "words": ["healthy", "diet"],
          "response":
              "A healthy diet includes a variety of fruits, vegetables, whole grains, and lean proteins."
        },
        {
          "words": ["what", "is"],
          "response":
              "Nutrition is the process of providing or obtaining the food necessary for health and growth."
        },
        {
          "words": [],
          "response": "Consult a nutritionist for personalized dietary advice."
        }
      ]
    },
    {
      "keyword": "mental health",
      "contexts": [
        {
          "words": ["importance"],
          "response":
              "Good mental health helps with stress management, decision-making, and relationships."
        },
        {
          "words": ["how", "to", "improve"],
          "response":
              "Improving mental health can involve therapy, medication, exercise, and social support."
        },
        {
          "words": ["what", "is"],
          "response":
              "Mental health refers to cognitive, emotional, and social well-being; it's important for overall health."
        },
        {
          "words": [],
          "response":
              "Always seek professional help if you're experiencing mental health issues."
        }
      ]
    },
    {
      "keyword": "pain",
      "contexts": [
        {
          "words": ["types"],
          "response":
              "Types of pain include acute, chronic, neuropathic, and nociceptive pain."
        },
        {
          "words": ["how", "to", "manage"],
          "response":
              "Pain management may involve medications, physical therapy, and alternative therapies."
        },
        {
          "words": ["what", "is"],
          "response":
              "Pain is an unpleasant sensory experience often associated with actual or potential tissue damage."
        },
        {
          "words": [],
          "response":
              "Consult a healthcare provider for personalized pain management strategies."
        }
      ]
    },
    {
      "keyword": "hypertension",
      "contexts": [
        {
          "words": ["causes"],
          "response":
              "Causes can include genetics, poor diet, lack of exercise, and stress."
        },
        {
          "words": ["treatment"],
          "response":
              "Treatment often involves lifestyle changes and medications to lower blood pressure."
        },
        {
          "words": ["what", "is"],
          "response":
              "Hypertension, or high blood pressure, is a condition where the force of the blood against the artery walls is too high."
        },
        {
          "words": [],
          "response":
              "Regular monitoring and consultation with a healthcare provider are essential."
        },
      ]
    },
    {
      "keyword": "flutter",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Flutter is an open-source UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase."
        },
        {
          "words": ["how", "to", "install"],
          "response":
              "You can install Flutter by downloading the Flutter SDK from the official website and setting up your development environment with Android Studio or Visual Studio Code."
        },
        {
          "words": ["why", "use"],
          "response":
              "Flutter provides a fast development process, beautiful UI, and supports multiple platforms from a single codebase, which saves time and effort."
        },
        {
          "words": ["where", "to", "learn"],
          "response":
              "You can learn Flutter from official documentation, YouTube tutorials, or platforms like Udemy and Coursera."
        },
        {
          "words": ["when", "to", "use"],
          "response":
              "Flutter is ideal when you want to build visually attractive apps with a single codebase for Android, iOS, and web."
        },
        {
          "words": [],
          "response":
              "Flutter is a powerful toolkit for building cross-platform apps. How can I assist you further?"
        }
      ]
    },
    {
      "keyword": "firebase",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Firebase is a platform developed by Google that provides cloud services like databases, authentication, analytics, and hosting for mobile and web applications."
        },
        {
          "words": ["how", "to", "integrate"],
          "response":
              "To integrate Firebase in Flutter, add Firebase packages in your pubspec.yaml file, set up Firebase Console, and configure your Android/iOS app with Firebase SDK."
        },
        {
          "words": ["why", "use"],
          "response":
              "Firebase simplifies backend development by offering tools like real-time databases, authentication, analytics, and cloud functions, which reduce time to market."
        },
        {
          "words": ["how", "to", "authenticate"],
          "response":
              "Firebase Authentication allows you to sign in users using email/password, Google, Facebook, and other providers with just a few lines of code."
        },
        {
          "words": ["where", "to", "store", "data"],
          "response":
              "Firebase offers Cloud Firestore and the Realtime Database for storing and syncing data between your app and the cloud."
        },
        {
          "words": [],
          "response":
              "Firebase offers a variety of tools to help manage your app's backend. Would you like assistance with Firebase?"
        }
      ]
    },
    {
      "keyword": "state management",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "State management refers to the way app data and UI are managed to ensure consistent behavior across the app. It is essential in Flutter to handle dynamic data."
        },
        {
          "words": ["how", "to", "implement"],
          "response":
              "You can implement state management in Flutter using solutions like Provider, Riverpod, Bloc, or GetX."
        },
        {
          "words": ["why", "use", "provider"],
          "response":
              "Provider is a simple and efficient way to manage state in Flutter, especially in smaller apps. It helps separate UI from business logic."
        },
        {
          "words": ["which", "state", "management"],
          "response":
              "Popular state management solutions in Flutter include Provider, Riverpod, Bloc, and GetX, each with its pros and cons depending on app complexity."
        },
        {
          "words": ["when", "to", "use"],
          "response":
              "Use state management when your app has dynamic content or when data needs to be shared across different widgets or screens."
        },
        {
          "words": [],
          "response":
              "Need help choosing the right state management solution for your app? Let me know your requirements."
        }
      ]
    },
    {
      "keyword": "flutter widget",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "In Flutter, a widget is a building block of the UI. Everything you see on the app screen is a widget, such as text, buttons, and layouts."
        },
        {
          "words": ["how", "to", "create"],
          "response":
              "To create a widget in Flutter, extend the StatelessWidget or StatefulWidget class and implement the build method to define the UI."
        },
        {
          "words": ["when", "to", "use", "stateful"],
          "response":
              "Use a StatefulWidget when your UI depends on some state or changes over time, like when handling user input or animations."
        },
        {
          "words": ["what", "is", "stateless"],
          "response":
              "A StatelessWidget is a widget that does not require any mutable state. The UI remains the same once built."
        },
        {
          "words": [],
          "response":
              "Widgets are the core of Flutter's UI framework. Want to know more about specific Flutter widgets?"
        }
      ]
    },
    {
      "keyword": "firebase firestore",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Cloud Firestore is a flexible, scalable database for mobile, web, and server development from Firebase and Google Cloud."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "You can use Firestore in Flutter by adding the Firestore package, then reading and writing data using collections and documents."
        },
        {
          "words": ["how", "to", "query"],
          "response":
              "You can query Firestore collections using methods like where, limit, orderBy, and others to retrieve data efficiently."
        },
        {
          "words": ["how", "to", "store", "data"],
          "response":
              "To store data in Firestore, you need to define collections and documents, then write the data using Firestore's set or add methods."
        },
        {
          "words": [],
          "response":
              "Firestore offers real-time data synchronization across clients. How can I help you with Firestore?"
        }
      ]
    },
    {
      "keyword": "flutter layout",
      "contexts": [
        {
          "words": ["how", "to", "align"],
          "response":
              "You can align widgets in Flutter using the Align widget or other layout widgets like Row, Column, and Stack to arrange your UI."
        },
        {
          "words": ["what", "is", "flex"],
          "response":
              "The Flex widget is a parent for Row and Column widgets. It controls the layout of its children by defining how they should be arranged."
        },
        {
          "words": ["how", "to", "center"],
          "response":
              "You can center a widget in Flutter by using the Center widget, which places the child widget in the middle of the parent widget."
        },
        {
          "words": [],
          "response":
              "Flutter offers flexible layout options like Row, Column, Stack, and GridView. Want more information about building layouts?"
        }
      ]
    },
    {
      "keyword": "firebase authentication",
      "contexts": [
        {
          "words": ["how", "to", "set up"],
          "response":
              "To set up Firebase Authentication in Flutter, add the Firebase Auth package, configure your project in Firebase Console, and implement the authentication flows."
        },
        {
          "words": ["what", "is"],
          "response":
              "Firebase Authentication provides backend services for authenticating users via email/password, phone numbers, and third-party providers like Google and Facebook."
        },
        {
          "words": ["how", "to", "reset", "password"],
          "response":
              "You can implement password reset functionality by calling Firebase Auth's sendPasswordResetEmail method."
        },
        {
          "words": [],
          "response":
              "Firebase Authentication simplifies user sign-ins for mobile and web apps. Need help setting up authentication?"
        }
      ]
    },
    {
      "keyword": "bloc",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Bloc (Business Logic Component) is a state management solution in Flutter that separates UI from business logic, making your app more scalable."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "To use Bloc in Flutter, install the bloc package, create events and states, and use the BlocBuilder to react to state changes."
        },
        {
          "words": ["why", "use"],
          "response":
              "Bloc is useful for large-scale applications with complex state logic, ensuring separation of concerns and testability."
        },
        {
          "words": [],
          "response":
              "Bloc is a powerful state management pattern for managing app state efficiently. Need help implementing Bloc?"
        }
      ]
    },
    {
      "keyword": "provider",
      "contexts": [
        {
          "words": ["what", "is"],
          "response":
              "Provider is a Flutter state management library that allows efficient sharing of data between widgets, helping to manage state reactively."
        },
        {
          "words": ["how", "to", "use"],
          "response":
              "To use Provider, wrap your app with ChangeNotifierProvider, and access the data using Provider.of or Consumer widgets."
        },
        {
          "words": ["why", "use"],
          "response":
              "Provider is an easy and scalable state management approach that works well for both small and large applications."
        },
        {
          "words": [],
          "response":
              "Provider is a popular choice for state management in Flutter. Need help with Provider setup?"
        }
      ]
    }
  ];
  // Add more keywords as needed

// Function to handle sending a message
void sendMessage(String userMessage) {
  final textMessage = types.TextMessage(
    author: _user,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: const Uuid().v4(),
    text: userMessage,
  );

  messages.insert(0, textMessage);
  _botReply(userMessage);
}

// Function to generate a response from the bot based on user input
void _botReply(String userMessage) {
  String response = "I'm not sure how to respond to that. Could you rephrase your question?";

  // First, check for exact phrase matches
  if (_checkForExactPhraseMatch(userMessage, response)) {
    // If a response was found in the exact phrase check, exit early
    return;
  }

  // Search through the knowledge base for a keyword match
  for (var entry in botKnowledgeBase) {
    if (userMessage.toLowerCase().contains(entry["keyword"])) {
      bool contextFound = false;

      // Check for word matches in contexts
      for (var context in entry["contexts"]) {
        if (context["words"].any((word) => userMessage.toLowerCase().contains(word))) {
          response = context["response"];
          contextFound = true;
          break; // Exit if a context match is found
        }
      }

      // If no specific context was found, provide the default response for that keyword
      if (!contextFound) {
        final defaultContext = entry["contexts"].firstWhere(
          (context) => (context["words"] as List).isEmpty,
          orElse: () => {
            "response": "I'm not sure how to respond to that."
          }, // Default fallback response
        );
        response = defaultContext["response"];
      }
      break; // Exit the loop once we've found a keyword match
    }
  }

  // Prepare the bot's message
  final botMessage = types.TextMessage(
    author: _bot,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: const Uuid().v4(),
    text: response,
  );

  // Add the bot's message after a short delay for a natural feel
  Future.delayed(const Duration(milliseconds: 500), () {
    messages.insert(0, botMessage);
  });
}

// Function to check for exact phrase matches
bool _checkForExactPhraseMatch(String userMessage, String response) {
  // Loop through the default contexts
  for (var context in defaultContexts) {
    for (var phrase in context["exact_phrases"] ?? []) {
      if (userMessage.toLowerCase().contains(phrase.toLowerCase())) {
        response = context["response"];
        // Insert the response into the messages list
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response,
        );

        // Add the bot's message after a short delay for a natural feel
        Future.delayed(const Duration(milliseconds: 500), () {
          messages.insert(0, botMessage);
        });
        return true; // Match found, so we return true
      }
    }
  }
  return false; // No match found
}

final List<Map<String, dynamic>> defaultContexts = [
  // Existing contexts
  {
    "exact_phrases": ["who are you", "what is your name"],
    "response": "I am an AI chatbot, designed to assist you with various queries, especially around Flutter, Firebase, and more. You can call me your virtual assistant!"
  },
  {
    "exact_phrases": ["who made you", "who created you", "who developed you"],
    "response": "I was created by AbdulRehman Arain, a skilled Flutter developer with a passion for building smart, helpful tools."
  },
  {
    "exact_phrases": ["why do you exist", "what is your purpose"],
    "response": "I exist to help answer your questions and assist you with tasks, especially related to software development and technical issues. Let me know how I can help!"
  },
  {
    "exact_phrases": ["are you human", "what are you"],
    "response": "I am not a human, but an AI assistant. I can help you with tasks like answering questions and providing information, much like a helpful human would!"
  },
  {
    "exact_phrases": ["what can you do", "how can you help me"],
    "response": "I can help with many things, from answering technical questions about Flutter and Firebase to providing general knowledge or guidance. Just ask me anything!"
  },
  {
    "exact_phrases": ["who created you", "who is your developer"],
    "response": "I was developed by AbdulRehman Arain, who has expertise in building useful applications and chatbots like me!"
  },
  
  // New contexts
  {
    "exact_phrases": ["what is Flutter", "can you explain Flutter"],
    "response": "Flutter is an open-source UI software development kit created by Google. It allows developers to create natively compiled applications for mobile, web, and desktop from a single codebase."
  },
  {
    "exact_phrases": ["what is Firebase", "how does Firebase work"],
    "response": "Firebase is a platform developed by Google for creating mobile and web applications. It offers a variety of tools and services, including real-time databases, authentication, and cloud storage."
  },
  {
    "exact_phrases": ["what is state management", "how to manage state in Flutter"],
    "response": "State management in Flutter refers to the management of the state of your app, ensuring that the user interface reflects the current data. Popular methods include Provider, Riverpod, and Bloc."
  },
  {
    "exact_phrases": ["how to install Flutter", "what are the steps to set up Flutter"],
    "response": "To install Flutter, download the Flutter SDK from the official site, add it to your PATH, and run the Flutter doctor command to check for dependencies. Follow the setup instructions for your specific OS."
  },
  {
    "exact_phrases": ["what is Dart", "why is Dart used"],
    "response": "Dart is an open-source programming language developed by Google, used primarily for building mobile, desktop, server, and web applications. It is the language behind Flutter."
  },
  {
    "exact_phrases": ["how do I create a Flutter project", "what is the command to start a Flutter project"],
    "response": "You can create a new Flutter project using the command `flutter create project_name` in your terminal, where 'project_name' is the desired name of your project."
  },
  {
    "exact_phrases": ["what are widgets in Flutter", "can you explain Flutter widgets"],
    "response": "Widgets are the building blocks of a Flutter app's user interface. Everything in Flutter is a widget, from layout elements to UI components."
  },
  {
    "exact_phrases": ["how to handle errors in Flutter", "what is error handling in Flutter"],
    "response": "Error handling in Flutter can be done using try-catch blocks for synchronous code or using Future.catchError for asynchronous code. It helps to manage exceptions and improve app stability."
  },
  {
    "exact_phrases": ["what's new", "what's happening"],
    "response": "Not much! I'm here to help you with any questions you have. What can I do for you?"
  },
  {
    "exact_phrases": ["how's your day", "how's your day going"],
    "response": "I don't experience days like you do, but I'm ready to assist you with whatever you need!"
  },
  {
    "exact_phrases": ["yo", "sup"],
    "response": "Hey there! How can I assist you today? Just let me know!"
  },
  {
    "exact_phrases": ["long time no see", "it's been a while"],
    "response": "Welcome back! I'm here to help, so what can I assist you with today?"
  },
  {
    "exact_phrases": ["thank you", "thanks"],
    "response": "You're welcome! If you have any more questions or need help, feel free to ask!"
  },
  {
    "exact_phrases": ["good to see you", "great to see you"],
    "response": "It's great to see you too! How can I help you today?"
  },
  {
    "exact_phrases": ["how's life", "how are things"],
    "response": "I’m just a program, but I'm here to help you with any inquiries you might have!"
  },
  {
    "exact_phrases": ["welcome", "thank you for having me"],
    "response": "You're always welcome here! How can I assist you today?"
  },
];
}
