DEVELOPMENT AND IMPLEMENTATION OF FLUTTER BASED EAR-TRAINER APP FOR MUSICAL PITCH RECOGNITION

By:
Gastiadirijal Naufaldy Kestiyanto NIM. 2241720001

INFORMATICS ENGINEERING STUDY PROGRAM
DEPARTMENT OF INFORMATION TECHNOLOGY
STATE POLYTECHNIC OF MALANG
2025

APPROVAL PAGE
DEVELOPMENT AND IMPLEMENTATION OF FLUTTER BASED EAR-TRAINER APP FOR MUSICAL PITCH RECOGNITION

Prepared by:
GASTIADIRIJAL NAUFALDY KESTIYANTO NIM. 2241720001

This thesis proposal was tested on the of January 2026

Approved by:

1.  Primary Supervisor : Prof. Dr. Eng. Cahya Rahmad, S.T., M.Kom.
    NIP. 197202022005011002
    ...........................

2.  Discussant I :
    ...........................

3.  Discussant II :
    ...........................

4.       :
    ...........................

Acknowledge,

Head of the Department of Information Technology Head of D4 Informatics Engineering Program

Mungki Astiningrum, S.T., M.Kom.

Dr. Ely Setyo Astuti, ST., MT.
NIP. 19771030 200501 2 001 NIP. 19760515 200912 2 001

TABLE OF CONTENTS
Page
FRONT COVER i
APPROVAL PAGE ii
TABLE OF CONTENTS iii
LIST OF FIGURES iv
LIST OF TABLES v
LIST OF APPENDICES vi
CHAPTER I. INTRODUCTION 1
1.1 Background 1
1.2 Problem Formulation 2
1.3 Research Objectives 3
1.4 Scope and Limitations 3
1.5 Research Benefits 4
CHAPTER II.THEORETICAL FOUNDATION & LITERATURE REVIEW 5
2.1 Literature Review 5
2.2 Theoretical Foundation 5
2.2.1 Educational Technology ( EdTech ) 5
2.2.2 Gamification 5
2.2.3 Mobile Application 5
2.2.4 Flutter Framework 5
2.2.5 Basic Music Theory
2.2.5.1 Pitch 5
2.2.5.2 Note 5
2.2.5.3 Octave 5
2.2.5.4 Scale 5
CHAPTER III. RESEARCH AND DEVELOPMENT METHODOLOGY 6
3.1 Research Type and Approach. 8
3.2 Time and Place of Research. 10
3.3 Development Methodology 10
3.4 System Requirement Analysis. 10
3.5 System Workflow. 10
3.6 Data Processing. 10
3.7 Tools and Technology Used. 10
3.8 System Testing and Evaluation 10
CHAPTER IV. DEVELOPMENT SCHEDULE 13
4.1 Development Schedule 20
REFERENCES 63

LIST OF FIGURES
Page
Figure 2.1 Application Flowchart 16

LIST OF TABLES
Page
Table 2.1 Literature Reviews 24

CHAPTER I. INTRODUCTION

1.1 Background
Ear training is a fundamental component of music education that enables learners to accurately recognize musical elements such as pitch, intervals, and melodic patterns. This skill plays an essential role in improving musical intonation, sight-reading ability, improvisation, and overall musical comprehension. For beginner learners, the development of pitch recognition is a critical foundation before progressing to more advanced musical concepts.

Despite its importance, ear training is often perceived as challenging and monotonous, particularly by novice learners. In Indonesia, music education commonly relies on conventional face-to-face instruction, which may be constrained by limited instructional time, accessibility issues, financial considerations, and the availability of qualified instructors. As a result, many learners lack opportunities for consistent and structured ear-training practice outside formal learning environments.

The rapid development of mobile technology offers new opportunities to address these challenges through educational technology (EdTech). Mobile learning applications allow users to access learning materials flexibly, practice independently, and receive immediate feedback. However, many existing music-learning applications primarily emphasize music theory or performance skills, while structured pitch recognition training for beginners remains limited. Additionally, some applications lack effective motivational strategies, leading to low user engagement and learning continuity.

Therefore, this research proposes the development and implementation of a Flutter-based ear-training mobile application focused on beginner-level musical pitch recognition. By integrating structured pitch exercises with gamification elements such as levels, badges, and score tracking, the application aims to provide an accessible, engaging, and effective learning tool. This study focuses on providing a practical tool for basic ear-training practice while exploring the use of mobile learning and gamification in music education
1.2 Problem Formulation
Based on the description of the background, the problem formulation in this study are as follows:
• How can a mobile application be designed and developed to support beginner-level pitch and interval recognition training?
• How can gamification elements be integrated into the application to increase user engagement and learning motivation?
1.3 Scope and Limitations
This study focuses on developing the ear-training mobile application for Android, with beginner-level features for pitch recognition ( notes, interval and scales ) as such :
• The learning activities are done in the form of quizzes and do not include real-time audio input.
• The ear training exercises are only limited basic musical pitch recognition, including single notes, basic interval, and major scales.
• Gamification features are limited to badges, level progression, and score tracking, without any multiplayer elements such as online leaderboard system.
• The development of the application only focuses on the Android platform and does not include iOS or desktop platforms.
• The audio output uses synthesized instrument samples within the application.
1.4 Research Objectives
The primary objectives for this research are:

1. To design and implement a Flutter-based mobile application that provides structured exercises for musical pitch recognition.
2. To integrate ga mification features such as badges, levels, and progression metrics to enhance user engagement.
3. To evaluate the functional performance and user experience of the developed application.
   1.5 Research Benefits
   • Theoretical Benefit
   This study contributes to the literature related to music education technology, specifically in the area of digital ear training and gamified mobile learning.
   • Practical Benefit
   To make an application in which users from any musical backgound can benefit from.
   • Technological Benefit
   To demonstrate the implementation of Flutter-based mobile applications supporting audio playback and gamified learning features interactions.
   CHAPTER II. THEORETICAL FOUNDATION

2.1 Literature Review
This section provides a summary of previous studies that serves as a foundation for the research and development of the application :
Table 2.1 Literature Reviews
No Authors Research Title Research Findings

1.       Rangsiman Khamtue, Yootthapong Tongpaeng, Kemachart Kemavuthanon (2023) .		Learning 2D Mobile Casual Musical Pitch Training Game Application (Pitchero)	The study demonstrates that casual mobile games can effectively support basic pitch recognition through repetitive audio-based exercises.
2.       Jie Liang, Fen Zhang, Wenshu Liu, Zilong Li, Keke Yu
    (2024) Musical Pitch Perception and Categorization in Listeners with No Musical Training Experience: Insights from Mandarin-Speaking Non-Musicians Research investigating musical pitch perception in individuals without formal music training suggests that non-musicians’ ability to distinguish and categorize musical pitch is influenced by the distance between notes and cognitive categorization processes. This supports the need for beginner-focused pitch training systems that scaffold learning gradually from larger interval differences to more subtle ones.
3.       León-Garrido, A., Barroso-Osuna, J. M., & Llorente-Cejudo, C. (2022).	Conceptual Cartography for the Systematic Study of Music Education Based on ICT or EdTech	Research indicates that educational technologies integrated into music learning can increase motivation, encourage creativity, and support the acquisition of musical competencies, making them suitable tools for fundamental skills such as pitch and note recognition.
4.
5.  2.2 Theoretical Foundation
    2.2.1 Educational Technology (EdTech)
    Educational technology (EdTech) refers to the systematic application of technological tools and strategies to support, enhance, and transform learning processes. EdTech encompasses software, multimedia content, mobile learning, and interactive platforms that provide learners with flexible access to educational resources, independent of traditional instructor-led environments. Research has shown that mobile applications and interactive systems can enrich learning experiences by offering self-paced exercises, real-time feedback, and adaptive learning paths, helping learners stay engaged outside the classroom context.

Mobile devices have become an essential medium for integrating EdTech into daily learning routines due to their widespread adoption and portability. Integrating EdTech into music education has the potential to reduce barriers related to access and logistical constraints often associated with formal music instruction, particularly for foundational skills such as pitch recognition.
2.2.2 Gamification
Gamification refers to the use of game design elements in non-game contexts to increase user engagement, motivation, and learning effectiveness. Sailer and Homner (2020) state that gamification has a positive and significant effect on cognitive, motivational, and behavioral learning outcomes, particularly when learners receive clear goals and immediate feedback. Further research by Toda et al. (2020) emphasizes that gamification supports sustained user participation by transforming repetitive learning activities into structured challenges, making it suitable for skill-based training that requires frequent practice.
In mobile learning environments, Koivisto and Hamari (2021) explain that gamification elements such as points, progress indicators, and levels can increase user retention and perceived enjoyment, which are crucial factors for long-term learning applications. Additionally, their findings suggest that gamified systems are especially effective when designed for self-paced learning, as they allow users to practice without external pressure.
Therefore, the integration of gamification in an ear training application is appropriate to support repeated pitch recognition exercises, maintain user motivation, and enhance learning persistence among beginner to intermediate learners.
2.2.3 Mobile Application
A mobile application is a software system designed to operate on mobile devices such as smartphones and tablets, providing users with interactive features and real-time system responses. According to Al-Emran et al. (2020), mobile applications offer advantages in terms of accessibility, portability, and continuous user interaction, which make them suitable for applications that require frequent user engagement and short usage sessions.
Research by Zhou (2021) highlights that mobile applications are effective platforms for delivering interactive systems due to their support for touch-based interfaces, multimedia presentation, and responsive feedback mechanisms. These characteristics enable users to interact with application features efficiently and intuitively, enhancing usability and user satisfaction.
Furthermore, Kim and Park (2021) state that mobile applications are increasingly adopted for systems that require user-centered design and personalization, allowing applications to adapt content presentation and interaction flow based on user behavior. This flexibility supports applications that rely on repeated user interaction and progressive performance improvement, such as quiz-based and feedback-driven systems.
Based on these characteristics, the use of a mobile application platform is appropriate for developing an interactive system that prioritizes accessibility, usability, and consistent user engagement.

2.2.4 Flutter Framework
Flutter is an open-source UI software development framework developed by Google for building natively compiled applications for mobile platforms using a single codebase. According to Google (2021), Flutter enables developers to create high-performance applications through its use of the Dart programming language and a widget-based architecture that supports consistent user interfaces across platforms.
Research by Immaneni et al. (2020) explains that Flutter provides near-native performance by compiling directly to native machine code and rendering its own UI components through the Skia graphics engine. This approach reduces dependency on platform-specific UI components, resulting in smoother animations and more consistent application behavior across different devices.
Furthermore, a study by Soni and Bhatt (2021) highlights that Flutter is suitable for rapid application development due to features such as hot reload, reusable widgets, and strong community support. These characteristics improve development efficiency while maintaining application stability and scalability, making Flutter an appropriate framework for developing interactive and user-centered mobile applications.
Based on these advantages, Flutter is considered a reliable framework for mobile application development that emphasizes performance, cross-platform consistency, and efficient development workflows.

2.2.5 User Experience Questionnaire ( UEQ )
User Experience (UX) refers to the perceptions and responses of users that result from the use of a system, product, or service. UX does not only focus on functional aspects such as usability, but also includes emotional responses, comfort, and overall satisfaction during interaction with the system.

The User Experience Questionnaire (UEQ) is a standardized evaluation instrument used to measure user experience in interactive products, particularly software and mobile applications. UEQ is designed to capture users’ subjective impressions quickly and efficiently through a set of bipolar adjective pairs presented on a semantic differential scale. Due to its simplicity and effectiveness, UEQ is widely used in usability and user experience evaluations.

UEQ measures user experience across six distinct scales, which are grouped into two main quality dimensions: pragmatic quality and hedonic quality. Pragmatic quality focuses on task-related aspects such as usability and efficiency, while hedonic quality relates to emotional aspects such as enjoyment, motivation, and innovation.

The six UEQ scales are defined as follows:

1. Attractiveness, which represents the overall impression of the product and reflects whether users like or dislike the application.
2. Perspicuity, which measures how easy the application is to understand and learn, especially for first-time users.
3. Efficiency, which evaluates how quickly and efficiently users can complete tasks using the application.
4. Dependability, which describes the level of control, predictability, and reliability perceived by users during interaction.
5. Stimulation, which indicates how motivating and engaging the application is for users.
6. Novelty, which assesses the creativity and innovativeness of the application design.

Each scale in UEQ is evaluated using a numerical range that represents negative to positive user perceptions. The results provide a comprehensive overview of the user experience, covering both functional performance and emotional impact.

In this research, UEQ is used as an evaluation framework to assess the user experience of the Flutter-based ear-training application. The use of UEQ is relevant to the objectives of this study because it allows the measurement of ease of use, efficiency of training activities, and user motivation during pitch recognition exercises. Therefore, UEQ is considered an appropriate instrument to evaluate the quality of user experience in the developed mobile learning application.

2.2.6 Black Box Testing
Black Box Testing is a software testing technique that focuses on verifying the functional behavior of a system based on its inputs and outputs, without considering the internal structure or implementation of the software. In this approach, the tester evaluates whether the system performs according to specified requirements by interacting with the application through its user interface.

According to Pressman and Maxim (2020), Black Box Testing examines “the functional correctness of the software by deriving test cases from the specified requirements and observing the resulting outputs.” This means that testing is performed from the perspective of the end user, making the method suitable for validating application features that involve direct user interaction.

Similarly, the International Software Testing Qualifications Board (ISTQB, 2018) defines Black Box Testing as a method where “test cases are designed based on the system’s functional specifications, without knowledge of the internal code structure.” This characteristic allows the tester to focus on what the system does rather than how it is implemented.

Black Box Testing is commonly used in application-level testing to validate core functionalities such as input handling, process execution, output generation, and system responses to user actions. Because it does not require access to source code, this testing technique is widely applied in mobile and web application development, where the primary concern is whether features operate correctly from a user’s perspective.

In the context of interactive systems, Sommerville (2016) explains that Black Box Testing is effective for ensuring that software meets user expectations and functional requirements, especially when the system behavior can be clearly defined through use cases and functional scenarios. Therefore, this testing method is appropriate for evaluating educational mobile applications that rely on predefined workflows and user-driven interactions.

Based on these characteristics, Black Box Testing is suitable for this research because the evaluation focuses on validating the correctness of application features such as audio playback, quiz execution, answer validation, and user feedback, without examining internal program logic.

2.2.7 Basic Music Theory
2.2.8 Pitch
In music, pitch refers to the perceived highness or lowness of a sound. Physically, pitch corresponds to the frequency of a vibrating sound wave, measured in Hertz (Hz). Higher frequencies produce higher perceived pitches, while lower frequencies produce lower perceived pitches. Human perception of pitch is not linear, but logarithmic, meaning equal perceptual distances correspond to frequency ratios rather than absolute differences.
2.2.9 Note
A note represents a specific musical pitch within the Western musical system. Western music divides the octave into twelve equal intervals called semitones, forming the basis of the chromatic scale. Notes are commonly named using the musical alphabet:
A, B, C, D, E, F, G
Alongside these natural notes, accidental signs (sharp # or flat ♭) are used to represent pitches between natural notes, creating a total of twelve pitch classes per octave (e.g., C, C♯/D♭, D, D♯/E♭, etc.). In modern equal temperament tuning, each note is spaced evenly by a factor of the twelfth root of two (≈ 1.05946) in frequency.
2.2.10 Octave
An octave is the interval between one pitch and another with double (or half) its frequency. For example, the note A4 is standardized at 440 Hz, while A5 (one octave higher) vibrates at 880 Hz. Although the frequencies differ, the pitches are perceived as musically equivalent due to the periodic and harmonic relationship between them. The octave is a fundamental organizing principle in music, as notes separated by octaves share the same pitch class and occupy analogous positions on musical instruments and notation systems.
2.2.11 Scale
A scale in music theory is an ordered sequence of notes arranged by ascending or descending pitch, serving as a fundamental framework for understanding melody and tonal relationships. Scales are defined by specific interval patterns, with the major and minor scales being the most commonly used in Western music, each producing distinct tonal characteristics. In ear training, scale recognition helps learners perceive pitch relationships within a tonal context rather than as isolated notes, making it suitable for beginner-level training. In this research, scale recognition is limited to basic major scales and is implemented through audio-based quiz exercises to support fundamental pitch recognition skills.

 
CHAPTER III.
RESEARCH AND DEVELOPMENT METHODOLOGY

3.1 Research Type and Approach
This research adopts a Research and Development (R&D) methodology with a system development approach. The purpose of this research is to design, implement, and evaluate a mobile-based ear-training application that supports musical pitch recognition for beginner-level learners.

The R&D approach is suitable for this study because the primary output is a functional software product rather than producing theoretical findings. The research emphasizes the development process, system functionality, and user experience evaluation ( questionnaire ), particularly in the context of educational technology and gamified learning applications.

3.2 Time and Place of Research
This research will be conducted in collaboration with UKM Seni Politeknik Negeri Malang more widely known as Theatrisic as the research partner. The partner served as the user testing environment for evaluating the Flutter-based ear-training application. The research will be carried out from January 2026 to June 2026, covering stages of application development, implementation, and user evaluation. User testing activities involved beginner-level learners from the partner community using Android-based devices.

3.3 Development Methodology
The development of the application follows the Waterfall model, which consists of sequential and clearly defined stages. This model is selected due to its structured workflow and suitability for application development projects with well-defined requirements.
The stages of the Waterfall model applied in this research include:

1. Requirement Analysis
2. System Design
3. Implementation
4. Testing
5. Evaluation
   Each stage must be completed before proceeding to the next, ensuring systematic development and documentation.

3.4 System Requirement Analysis
The developed application consists of several core features that support the ear-training process. The primary feature is pitch recognition training, where users listen to musical notes and determine relative pitch differences through guided quizzes. Interval recognition is implemented by presenting two consecutive notes and requiring users to identify whether the pitch movement is ascending or descending. Scale recognition training is designed to introduce users to tonal context through major scales. In this feature, one note is removed from a scale sequence, and users are required to identify the missing note based on the remaining pitches. This approach encourages contextual listening rather than isolated pitch identification.

To maintain engagement, the application incorporates gamification elements such as scoring, levels, and badges. These features provide visual indicators of progress and achievement, motivating users to continue practicing. All features are implemented to function offline, ensuring that the application can be used without an internet connection.

3.5 System Workflow
The system workflow begins when the user opens the ear-training application and is presented with the main menu. From this menu, the user selects one of the available training modules: pitch recognition, interval recognition, or scale recognition.

After a module is selected, the system loads the corresponding audio resources and quiz configuration, then plays a synthesized musical sample based on the chosen module. The user listens to the audio and submits an answer by selecting one of the provided options.

The system evaluates the user’s input by comparing it with the correct answer stored in the application logic. Feedback is displayed immediately to indicate whether the answer is correct or incorrect, and the user’s score is updated accordingly. This process repeats until the session ends or the user exits the module.

At the end of the session, the system displays a summary of the user’s performance before returning the user to the main menu.

Figure 2.1 Application Flowchart

3.6 Data Processing
Although this research does not involve complex data mining or machine learning techniques, data processing is still required to support the ear-training functionality. The data used in this application consists of pre-recorded synthesized audio samples representing musical notes and major scales.

Audio samples are prepared in advance and organized based on pitch class and octave. During quiz execution, the system randomly selects audio files from the predefined dataset according to the selected training module. For scale-based exercises, one note is omitted from the major scale sequence, and the user is required to identify the missing note based on tonal context.

User interaction data, such as quiz results, scores, and progression levels, are processed locally and stored on the device to track learning progress and unlock gamification elements.

3.7 Tools and Technology Used
These are the tools and technology used to help the development of the ear-trainer mobile application:
No Category Software Name Function

1.       Operating System	Microsoft Windows 10  / 11	The environment where all
    development applications run.
2.       Text Editor 	Visual Studio Code	Source code editor used for developing the Flutter application with Dart support.
3.       Mobile Framework	Flutter	Framework used to develop cross-platform mobile applications.
4.       Programming Language	Dart	Programming language used to build the application logic and UI in Flutter.
5.  Modelling Tools Draw.io Tools for designing UML diagrams
    (Use Case, Activity, Sequence
6.  Design Tools Figma Tool used to design and prototype the user interface of the application.
7.  Mobile SDK Android Studio SDK Software Development Kit used to build, run, and test the application on Android devices.

3.8 System Testing and Evaluation
System testing is conducted to ensure that the developed application functions correctly and meets user expectations. Functional testing is performed to verify that each training module operates according to its defined requirements, including audio playback, answer validation, scoring, and progression logic.

User evaluation is conducted through usability testing involving members of UKM Seni Politeknik Negeri Malang. Participants are asked to use the application and provide feedback through questionnaires focusing on ease of use, clarity of audio, and perceived usefulness of gamification features.

The evaluation results are analyzed descriptively to determine whether the application meets its intended objectives and supports beginner-level pitch recognition training. The user evaluation focuses on the ease of use, clarity of audio and quiz comprehension.

3.8.1 Black Box Testing
In this study, Black Box Testing is applied to verify the correctness of the core functionalities of the application. Each feature is tested by providing user input through the application interface and observing whether the resulting output matches the expected behavior defined during the system requirement analysis stage.

The tested components include:

 Playback of synthesized audio for pitch, interval, and scale training
 Quiz execution flow, including question generation and answer selection
 Validation of user answers and feedback display
 Score calculation and level progression logic
 Navigation between menus and training modules

Test cases are designed based on functional scenarios that reflect real user interactions. A test case is considered successful if the system produces the expected output without errors or unexpected behavior. The results of Black Box Testing are documented in test case tables to demonstrate that all system functions meet their specified requirements.

3.8.2 User Experience Evaluation using UEQ
User Experience (UX) evaluation is conducted to measure users’ perceptions and experiences while interacting with the developed ear-training application. In this research, the User Experience Questionnaire (UEQ) is used as the evaluation instrument because it is designed to assess both pragmatic and hedonic aspects of user experience in interactive systems.

The UEQ consists of a standardized set of bipolar adjective pairs (e.g., easy–difficult, clear–confusing, exciting–boring) measured using a 7-point semantic differential scale. According to Schrepp, Hinderks, and Thomaschewski (2017), the UEQ enables quick and reliable measurement of user experience across multiple dimensions without requiring long or complex questionnaires.

The UEQ evaluates six UX dimensions: Attractiveness, Perspicuity, Efficiency, Dependability, Stimulation, and Novelty. These dimensions allow the evaluation to capture both usability-related aspects (such as ease of use and clarity) and experiential aspects (such as enjoyment and motivation), which are relevant for a gamified learning application.

In this study, the UEQ is administered after users complete several training sessions within the application, including pitch recognition, interval recognition, and scale recognition modules. Respondents rate their experience based on their interaction with the application interface, audio clarity, quiz flow, and gamification features.

The collected UEQ data are processed according to the standard UEQ evaluation method, where scores for each dimension are calculated by averaging the responses of corresponding questionnaire items. The results are then analyzed descriptively to identify overall user experience quality and to determine whether the application provides a positive and acceptable user experience for beginner-level learners.

The use of UEQ in this research supports the evaluation of whether the developed application aligns with its objective of providing an accessible, engaging, and user-friendly ear-training tool.
CHAPTER IV. DEVELOPMENT SCHEDULE

3.9 Development Schedule
The development was carried out based on the development stages discussed earlier.
The development schedule is shown in the following table.

Figure 4.1 Development Schedule

 

REFERENCES

Pressman, R. S., & Maxim, B. R. (2020).
Software engineering: A practitioner’s approach (9th ed.). New York, NY: McGraw-Hill Education.

International Software Testing Qualifications Board (ISTQB). (2018).
ISTQB glossary of testing terms. Retrieved from https://www.istqb.org

Sommerville, I. (2016).
Software engineering (10th ed.). Boston, MA: Pearson Education.
