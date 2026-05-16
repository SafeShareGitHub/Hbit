/// A curated template for a tiny habit, before it is bound to a concrete map.
class BehaviorTemplate {
  const BehaviorTemplate({
    required this.domain,
    required this.behavior,
    required this.anchorPrompt,
    required this.tinyAction,
    required this.celebration,
    required this.impact,
    required this.ease,
  });

  final String domain;
  final String behavior;
  final String anchorPrompt;
  final String tinyAction;
  final String celebration;
  final int impact;
  final int ease;
}

/// The universal domain whose habits are added to every map regardless of
/// the user's aspiration — the foundations of any career growth.
const String kUniversalDomain = 'growth';

/// Human-readable names for each domain.
const Map<String, String> kDomainLabels = {
  'engineering': 'Engineering Craft',
  'leadership': 'Leadership',
  'entrepreneur': 'Entrepreneurship',
  'data_ml': 'Data & ML',
  'design': 'Design',
  'writing': 'Writing',
  'speaking': 'Public Speaking',
  'sales': 'Sales & Marketing',
  'growth': 'Growth Foundations',
};

/// Keywords matched (as substrings) against the user's aspiration text to
/// decide which domains are relevant. Order within a list does not matter.
const Map<String, List<String>> kDomainKeywords = {
  'engineering': [
    'engineer', 'developer', 'programmer', 'coding', 'software',
    'flutter', 'backend', 'frontend', 'full stack', 'full-stack',
    'architect', 'devops', 'sde',
  ],
  'leadership': [
    'lead', 'manager', 'management', 'director', 'head of', 'cto',
    'vp', 'vice president', 'principal', 'executive', 'chief', 'mentor',
  ],
  'entrepreneur': [
    'entrepreneur', 'founder', 'startup', 'start-up', 'start up',
    'own company', 'own business', 'my own', 'ceo', 'saas',
    'business owner', 'self-employed', 'freelance',
  ],
  'data_ml': [
    'data scien', 'machine learning', 'ml engineer', 'deep learning',
    'artificial intelligence', 'data analyst', 'data engineer',
    'analytics', 'researcher',
  ],
  'design': [
    'designer', 'design', 'ux', 'user experience', 'product design',
    'graphic', 'creative director',
  ],
  'writing': [
    'writer', 'writing', 'author', 'blogger', 'content creator',
    'technical writer', 'novelist', 'journalist',
  ],
  'speaking': [
    'speaker', 'public speaking', 'keynote', 'presenter', 'teacher',
    'educator', 'coach', 'evangelist', 'advocate',
  ],
  'sales': [
    'sales', 'salesperson', 'marketing', 'growth marketing',
    'account executive', 'business development', 'customer success',
  ],
};

/// The full behavior library. The engine selects from this pool.
const List<BehaviorTemplate> kBehaviorLibrary = [
  // --- Engineering ---
  BehaviorTemplate(
    domain: 'engineering',
    behavior: 'Learn from other people\'s code',
    anchorPrompt: 'After I pour my morning coffee',
    tinyAction: 'I will open one pull request and read a single function',
    celebration: 'Smile and think "I\'m leveling up."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'engineering',
    behavior: 'Write tested, reliable code',
    anchorPrompt: 'After I write a new function',
    tinyAction: 'I will write one test case for it',
    celebration: 'Do a small fist pump',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'engineering',
    behavior: 'Strengthen the fundamentals',
    anchorPrompt: 'After I sit down at my desk',
    tinyAction: 'I will read one paragraph of docs or a CS concept',
    celebration: 'Say "Sharp mind."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'engineering',
    behavior: 'Ship something every day',
    anchorPrompt: 'After I finish lunch',
    tinyAction: 'I will commit one small change to a project',
    celebration: 'Smile at the green checkmark',
    impact: 5,
    ease: 3,
  ),

  // --- Leadership ---
  BehaviorTemplate(
    domain: 'leadership',
    behavior: 'Recognize the people around you',
    anchorPrompt: 'After I open my team chat',
    tinyAction: 'I will send one specific thank-you message',
    celebration: 'Think "That\'s leadership."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'leadership',
    behavior: 'Listen more than you speak',
    anchorPrompt: 'After someone finishes a sentence in a meeting',
    tinyAction: 'I will count to two before responding',
    celebration: 'Give myself a small nod',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'leadership',
    behavior: 'Develop your teammates',
    anchorPrompt: 'After my daily standup',
    tinyAction: 'I will ask one teammate "what is blocking you?"',
    celebration: 'Say "I grow people."',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'leadership',
    behavior: 'Communicate the bigger picture',
    anchorPrompt: 'After I assign a task',
    tinyAction: 'I will add one sentence on why it matters',
    celebration: 'Do a small fist pump',
    impact: 4,
    ease: 4,
  ),

  // --- Entrepreneurship ---
  BehaviorTemplate(
    domain: 'entrepreneur',
    behavior: 'Talk to customers constantly',
    anchorPrompt: 'After I check my morning email',
    tinyAction: 'I will write one question I would ask a customer',
    celebration: 'Say "Founder mode."',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'entrepreneur',
    behavior: 'Validate before you build',
    anchorPrompt: 'After I have a new product idea',
    tinyAction: 'I will write it as a one-line hypothesis',
    celebration: 'Smile and nod',
    impact: 5,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'entrepreneur',
    behavior: 'Know your numbers',
    anchorPrompt: 'After I open my laptop',
    tinyAction: 'I will glance at one key business metric',
    celebration: 'Say "I run a business."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'entrepreneur',
    behavior: 'Run small experiments fast',
    anchorPrompt: 'After my afternoon coffee',
    tinyAction: 'I will note one tiny experiment to try',
    celebration: 'Do a fist pump',
    impact: 4,
    ease: 4,
  ),

  // --- Data & ML ---
  BehaviorTemplate(
    domain: 'data_ml',
    behavior: 'Sharpen statistics and math intuition',
    anchorPrompt: 'After I sit down at my desk',
    tinyAction: 'I will read one paragraph about a stats or ML concept',
    celebration: 'Say "Sharp."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'data_ml',
    behavior: 'Practice with real data',
    anchorPrompt: 'After lunch',
    tinyAction: 'I will load one dataset and print its shape',
    celebration: 'Smile',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'data_ml',
    behavior: 'Build a portfolio of projects',
    anchorPrompt: 'After I finish a learning session',
    tinyAction: 'I will write one line in my project log',
    celebration: 'Say "Building proof."',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'data_ml',
    behavior: 'Stay current with research',
    anchorPrompt: 'After my evening tea',
    tinyAction: 'I will read one abstract of a paper',
    celebration: 'Give myself a nod',
    impact: 3,
    ease: 5,
  ),

  // --- Design ---
  BehaviorTemplate(
    domain: 'design',
    behavior: 'Train your eye for great design',
    anchorPrompt: 'After I unlock my phone in the morning',
    tinyAction: 'I will study one well-designed screen',
    celebration: 'Think "Eye trained."',
    impact: 3,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'design',
    behavior: 'Practice the craft daily',
    anchorPrompt: 'After I open my design tool',
    tinyAction: 'I will draw one small component',
    celebration: 'Smile',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'design',
    behavior: 'Seek feedback early',
    anchorPrompt: 'After I finish a design draft',
    tinyAction: 'I will share it with one person',
    celebration: 'Do a fist pump',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'design',
    behavior: 'Stay close to the user',
    anchorPrompt: 'After my morning coffee',
    tinyAction: 'I will write one real user question',
    celebration: 'Say "User first."',
    impact: 4,
    ease: 5,
  ),

  // --- Writing ---
  BehaviorTemplate(
    domain: 'writing',
    behavior: 'Write every single day',
    anchorPrompt: 'After I make my morning coffee',
    tinyAction: 'I will write one sentence',
    celebration: 'Say "I\'m a writer."',
    impact: 5,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'writing',
    behavior: 'Read like a writer',
    anchorPrompt: 'After I get into bed',
    tinyAction: 'I will read one paragraph of strong writing',
    celebration: 'Smile',
    impact: 3,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'writing',
    behavior: 'Publish your work in public',
    anchorPrompt: 'After I finish a draft',
    tinyAction: 'I will post one idea online',
    celebration: 'Do a fist pump',
    impact: 5,
    ease: 3,
  ),
  BehaviorTemplate(
    domain: 'writing',
    behavior: 'Capture ideas before they escape',
    anchorPrompt: 'After I have an interesting thought',
    tinyAction: 'I will jot one note in my ideas list',
    celebration: 'Say "Caught it."',
    impact: 4,
    ease: 5,
  ),

  // --- Public Speaking ---
  BehaviorTemplate(
    domain: 'speaking',
    behavior: 'Practice speaking aloud',
    anchorPrompt: 'After I close my laptop for the day',
    tinyAction: 'I will say one sentence aloud as if presenting',
    celebration: 'Say "Strong voice."',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'speaking',
    behavior: 'Study great talks',
    anchorPrompt: 'After my evening meal',
    tinyAction: 'I will watch one minute of a great talk',
    celebration: 'Smile',
    impact: 3,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'speaking',
    behavior: 'Volunteer to present',
    anchorPrompt: 'After I see a meeting invite',
    tinyAction: 'I will note one chance to speak up',
    celebration: 'Do a fist pump',
    impact: 5,
    ease: 3,
  ),
  BehaviorTemplate(
    domain: 'speaking',
    behavior: 'Collect stories to tell',
    anchorPrompt: 'After something interesting happens at work',
    tinyAction: 'I will write it as a one-line story',
    celebration: 'Say "Story banked."',
    impact: 4,
    ease: 4,
  ),

  // --- Sales & Marketing ---
  BehaviorTemplate(
    domain: 'sales',
    behavior: 'Reach out to people daily',
    anchorPrompt: 'After my morning coffee',
    tinyAction: 'I will write one outreach message',
    celebration: 'Say "I create opportunities."',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'sales',
    behavior: 'Understand the customer\'s pain',
    anchorPrompt: 'After a customer conversation',
    tinyAction: 'I will write one sentence about their problem',
    celebration: 'Smile',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'sales',
    behavior: 'Tell a clear value story',
    anchorPrompt: 'After I describe my product to someone',
    tinyAction: 'I will rewrite it in one simpler sentence',
    celebration: 'Do a fist pump',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'sales',
    behavior: 'Follow up consistently',
    anchorPrompt: 'After lunch',
    tinyAction: 'I will check one pending follow-up',
    celebration: 'Say "Persistent."',
    impact: 4,
    ease: 5,
  ),

  // --- Growth Foundations (universal) ---
  BehaviorTemplate(
    domain: 'growth',
    behavior: 'Reflect on your progress',
    anchorPrompt: 'After I brush my teeth at night',
    tinyAction: 'I will name one thing I did toward my goal today',
    celebration: 'Say "Closer."',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'growth',
    behavior: 'Learn deliberately',
    anchorPrompt: 'After I sit down at my desk',
    tinyAction: 'I will read one paragraph about my craft',
    celebration: 'Smile',
    impact: 4,
    ease: 5,
  ),
  BehaviorTemplate(
    domain: 'growth',
    behavior: 'Build your network',
    anchorPrompt: 'After my lunch break',
    tinyAction: 'I will think of one person to reconnect with',
    celebration: 'Say "I\'m connected."',
    impact: 4,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'growth',
    behavior: 'Make your work visible',
    anchorPrompt: 'After I finish a task',
    tinyAction: 'I will note one accomplishment in a brag document',
    celebration: 'Do a fist pump',
    impact: 5,
    ease: 4,
  ),
  BehaviorTemplate(
    domain: 'growth',
    behavior: 'Protect your energy',
    anchorPrompt: 'After I notice I am tired',
    tinyAction: 'I will take three slow, deep breaths',
    celebration: 'Say "I\'m steady."',
    impact: 3,
    ease: 5,
  ),
];
