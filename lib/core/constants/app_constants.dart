/// Classe que define as constantes do aplicativo Focora
class AppConstants {
  // Versão do aplicativo
  static const String appVersion = '0.1.0';
  
  // Configurações do Pomodoro
  static const int defaultPomodoroMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int defaultPomodorosUntilLongBreak = 4;
  
  // Configurações do Ócio Criativo
  static const int defaultOcioMinutes = 15;
  
  // Limites
  static const int maxTaskNameLength = 100;
  static const int maxProjectNameLength = 50;
  static const int maxThoughtLength = 500;
  static const int maxIdeaLength = 1000;
  
  // Configurações de sincronização
  static const int syncIntervalMinutes = 15;
  
  // Configurações de notificações
  static const int reminderBeforeTaskMinutes = 15;
  
  // Configurações de diagnóstico
  static const int diagnosisQuestionCount = 5;
  
  // Tipos de procrastinador
  static const List<String> procrastinatorTypes = [
    'Perfeccionista',
    'Sonhador',
    'Preocupado',
    'Desafiador',
    'Sobrecarga',
    'Entediado',
  ];
  
  // Níveis de energia
  static const List<String> energyLevels = [
    'Muito baixa',
    'Baixa',
    'Média',
    'Alta',
    'Muito alta',
  ];
  
  // Categorias de tarefas
  static const List<String> taskCategories = [
    'Trabalho',
    'Pessoal',
    'Saúde',
    'Educação',
    'Finanças',
    'Social',
    'Lazer',
  ];
  
  // Contextos de tarefas
  static const List<String> taskContexts = [
    '@casa',
    '@trabalho',
    '@computador',
    '@telefone',
    '@espera',
    '@reunião',
    '@deslocamento',
  ];
  
  // Frases motivacionais
  static const List<String> motivationalQuotes = [
    'A procrastinação é o ladrão do tempo.',
    'Comece onde você está. Use o que você tem. Faça o que você pode.',
    'O segredo para seguir em frente é começar.',
    'Não espere. O momento nunca será perfeito.',
    'Ação é a chave fundamental para todo sucesso.',
    'Pequenos progressos são ainda progressos.',
    'Foco no processo, não no resultado.',
    'Hoje é o primeiro dia do resto da sua vida.',
    'Você não precisa ser ótimo para começar, mas precisa começar para ser ótimo.',
    'A motivação vem da ação, não o contrário.',
  ];
}
