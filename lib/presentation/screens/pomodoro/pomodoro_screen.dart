import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';

/// Enum que representa o tipo de sessão Pomodoro
enum PomodoroSessionType {
  /// Sessão de trabalho
  work,
  
  /// Pausa curta
  shortBreak,
  
  /// Pausa longa
  longBreak,
}

/// Tela do timer Pomodoro
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with SingleTickerProviderStateMixin {
  // Configurações do Pomodoro
  int _workDuration = 25 * 60; // 25 minutos em segundos
  int _shortBreakDuration = 5 * 60; // 5 minutos em segundos
  int _longBreakDuration = 15 * 60; // 15 minutos em segundos
  int _longBreakInterval = 4; // A cada 4 sessões de trabalho
  
  // Estado do timer
  late int _timeRemaining;
  PomodoroSessionType _currentSessionType = PomodoroSessionType.work;
  bool _isRunning = false;
  int _completedSessions = 0;
  Timer? _timer;
  
  // Tarefa atual
  TaskEntity? _currentTask;
  
  // Animação do círculo
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _timeRemaining = _workDuration;
    
    // Configurar animação
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _workDuration),
    );
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer
          Expanded(
            flex: 3,
            child: _buildTimer(),
          ),
          
          // Controles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildControls(),
          ),
          
          // Tarefa atual
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCurrentTask(),
          ),
          
          // Lista de tarefas
          Expanded(
            flex: 2,
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }
  
  /// Constrói o timer
  Widget _buildTimer() {
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    
    // Determinar a cor com base no tipo de sessão
    Color color;
    switch (_currentSessionType) {
      case PomodoroSessionType.work:
        color = FocoraTheme.secondaryColor;
        break;
      case PomodoroSessionType.shortBreak:
        color = FocoraTheme.accentColor;
        break;
      case PomodoroSessionType.longBreak:
        color = FocoraTheme.tertiaryColor;
        break;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tipo de sessão
          Text(
            _getSessionTypeText(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          
          // Timer circular
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 250,
                height: 250,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _isRunning
                          ? _animationController.value
                          : 1 - (_timeRemaining / _getSessionDuration()),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    );
                  },
                ),
              ),
              
              // Tempo restante
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Sessões completadas
          Text(
            'Sessões completadas: $_completedSessions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói os controles do timer
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão de reiniciar
        IconButton(
          icon: const Icon(Icons.refresh),
          iconSize: 32,
          onPressed: _resetTimer,
        ),
        const SizedBox(width: 16),
        
        // Botão de iniciar/pausar
        FloatingActionButton.large(
          onPressed: _toggleTimer,
          backgroundColor: _isRunning ? Colors.red : FocoraTheme.secondaryColor,
          child: Icon(
            _isRunning ? Icons.pause : Icons.play_arrow,
            size: 36,
          ),
        ),
        const SizedBox(width: 16),
        
        // Botão de pular
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 32,
          onPressed: _skipSession,
        ),
      ],
    );
  }
  
  /// Constrói a tarefa atual
  Widget _buildCurrentTask() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tarefa atual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            if (_currentTask != null)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentTask!.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_currentTask!.description != null)
                          Text(
                            _currentTask!.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (_currentTask != null) {
                        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                        taskProvider.markTaskAsCompleted(_currentTask!.id);
                        setState(() {
                          _currentTask = null;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _currentTask = null;
                      });
                    },
                  ),
                ],
              )
            else
              InkWell(
                onTap: () {
                  _showTaskSelectionDialog();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_task,
                        color: FocoraTheme.secondaryColor,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Selecionar uma tarefa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// Constrói a lista de tarefas
  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inProgressTasks = taskProvider.inProgressTasks;
        
        if (inProgressTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma tarefa em andamento',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Tarefas em andamento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: inProgressTasks.length,
                itemBuilder: (context, index) {
                  final task = inProgressTasks[index];
                  return TaskCard(
                    task: task,
                    onComplete: (id) {
                      taskProvider.markTaskAsCompleted(id);
                    },
                    onTap: (task) {
                      setState(() {
                        _currentTask = task;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Inicia ou pausa o timer
  void _toggleTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }
  
  /// Inicia o timer
  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    
    _animationController.duration = Duration(seconds: _timeRemaining);
    _animationController.reverse(from: 1.0);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _completeSession();
        }
      });
    });
  }
  
  /// Pausa o timer
  void _pauseTimer() {
    _timer?.cancel();
    _animationController.stop();
    setState(() {
      _isRunning = false;
    });
  }
  
  /// Reinicia o timer
  void _resetTimer() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _isRunning = false;
      _timeRemaining = _getSessionDuration();
    });
  }
  
  /// Pula a sessão atual
  void _skipSession() {
    _timer?.cancel();
    _animationController.reset();
    
    if (_currentSessionType == PomodoroSessionType.work) {
      _completedSessions++;
    }
    
    _moveToNextSession();
  }
  
  /// Completa a sessão atual
  void _completeSession() {
    _animationController.reset();
    
    // Reproduzir som de notificação
    
    // Mostrar notificação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getCompletionMessage()),
        duration: const Duration(seconds: 3),
      ),
    );
    
    if (_currentSessionType == PomodoroSessionType.work) {
      _completedSessions++;
    }
    
    _moveToNextSession();
  }
  
  /// Move para a próxima sessão
  void _moveToNextSession() {
    setState(() {
      switch (_currentSessionType) {
        case PomodoroSessionType.work:
          // Após uma sessão de trabalho, verificar se é hora de uma pausa longa
          if (_completedSessions % _longBreakInterval == 0) {
            _currentSessionType = PomodoroSessionType.longBreak;
          } else {
            _currentSessionType = PomodoroSessionType.shortBreak;
          }
          break;
        case PomodoroSessionType.shortBreak:
        case PomodoroSessionType.longBreak:
          _currentSessionType = PomodoroSessionType.work;
          break;
      }
      
      _timeRemaining = _getSessionDuration();
    });
  }
  
  /// Retorna a duração da sessão atual em segundos
  int _getSessionDuration() {
    switch (_currentSessionType) {
      case PomodoroSessionType.work:
        return _workDuration;
      case PomodoroSessionType.shortBreak:
        return _shortBreakDuration;
      case PomodoroSessionType.longBreak:
        return _longBreakDuration;
    }
  }
  
  /// Retorna o texto do tipo de sessão atual
  String _getSessionTypeText() {
    switch (_currentSessionType) {
      case PomodoroSessionType.work:
        return 'Sessão de Trabalho';
      case PomodoroSessionType.shortBreak:
        return 'Pausa Curta';
      case PomodoroSessionType.longBreak:
        return 'Pausa Longa';
    }
  }
  
  /// Retorna a mensagem de conclusão da sessão
  String _getCompletionMessage() {
    switch (_currentSessionType) {
      case PomodoroSessionType.work:
        return 'Sessão de trabalho concluída! Hora de uma pausa.';
      case PomodoroSessionType.shortBreak:
        return 'Pausa curta concluída! Hora de voltar ao trabalho.';
      case PomodoroSessionType.longBreak:
        return 'Pausa longa concluída! Hora de voltar ao trabalho.';
    }
  }
  
  /// Exibe o diálogo de configurações
  void _showSettingsDialog() {
    int workMinutes = _workDuration ~/ 60;
    int shortBreakMinutes = _shortBreakDuration ~/ 60;
    int longBreakMinutes = _longBreakDuration ~/ 60;
    int longBreakInterval = _longBreakInterval;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configurações do Pomodoro'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Duração da sessão de trabalho
                Row(
                  children: [
                    const Text('Sessão de trabalho:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: workMinutes,
                      items: [15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
                          .map((minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes min'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          workMinutes = value;
                        }
                      },
                    ),
                  ],
                ),
                
                // Duração da pausa curta
                Row(
                  children: [
                    const Text('Pausa curta:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: shortBreakMinutes,
                      items: [3, 5, 7, 10]
                          .map((minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes min'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          shortBreakMinutes = value;
                        }
                      },
                    ),
                  ],
                ),
                
                // Duração da pausa longa
                Row(
                  children: [
                    const Text('Pausa longa:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: longBreakMinutes,
                      items: [10, 15, 20, 25, 30]
                          .map((minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes min'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          longBreakMinutes = value;
                        }
                      },
                    ),
                  ],
                ),
                
                // Intervalo de pausa longa
                Row(
                  children: [
                    const Text('Pausa longa a cada:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: longBreakInterval,
                      items: [2, 3, 4, 5, 6]
                          .map((interval) => DropdownMenuItem<int>(
                                value: interval,
                                child: Text('$interval sessões'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          longBreakInterval = value;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _workDuration = workMinutes * 60;
                  _shortBreakDuration = shortBreakMinutes * 60;
                  _longBreakDuration = longBreakMinutes * 60;
                  _longBreakInterval = longBreakInterval;
                  
                  // Atualizar o timer atual se necessário
                  if (!_isRunning) {
                    _timeRemaining = _getSessionDuration();
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
  
  /// Exibe o diálogo de seleção de tarefa
  void _showTaskSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final tasks = [
              ...taskProvider.inProgressTasks,
              ...taskProvider.todayTasks,
              ...taskProvider.inboxTasks,
            ];
            
            return Container(
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecionar tarefa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (tasks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Nenhuma tarefa disponível'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: task.description != null
                                ? Text(
                                    task.description!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            leading: Icon(
                              _getTaskStatusIcon(task.status),
                              color: _getTaskStatusColor(task.status),
                            ),
                            onTap: () {
                              setState(() {
                                _currentTask = task;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  /// Retorna o ícone do status da tarefa
  IconData _getTaskStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.inbox:
        return Icons.inbox;
      case TaskStatus.inProgress:
        return Icons.play_arrow;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.delegated:
        return Icons.person;
      case TaskStatus.deferred:
        return Icons.schedule;
      case TaskStatus.archived:
        return Icons.archive;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }
  
  /// Retorna a cor do status da tarefa
  Color _getTaskStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.inbox:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.delegated:
        return Colors.purple;
      case TaskStatus.deferred:
        return Colors.amber;
      case TaskStatus.archived:
        return Colors.grey.shade700;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }
}
