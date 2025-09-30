import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';

/// Tela de caixa de entrada do aplicativo Focora
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();
  
  @override
  void dispose() {
    _taskController.dispose();
    _taskFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caixa de Entrada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Implementar ordenação
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implementar filtro
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de entrada rápida
          _buildQuickEntryField(),
          
          // Lista de tarefas
          _buildTaskList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar adição de tarefa detalhada
          _showAddTaskDialog();
        },
        backgroundColor: FocoraTheme.secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Constrói o campo de entrada rápida
  Widget _buildQuickEntryField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FocoraTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              focusNode: _taskFocusNode,
              decoration: const InputDecoration(
                hintText: 'Adicionar tarefa...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                _addQuickTask();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: FocoraTheme.secondaryColor,
            onPressed: () {
              _addQuickTask();
            },
          ),
        ],
      ),
    );
  }
  
  /// Constrói a lista de tarefas
  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inboxTasks = taskProvider.inboxTasks;
        
        if (inboxTasks.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sua caixa de entrada está vazia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione tarefas para começar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: inboxTasks.length,
            itemBuilder: (context, index) {
              final task = inboxTasks[index];
              return Dismissible(
                key: Key(task.id),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    // Marcar como concluída
                    taskProvider.markTaskAsCompleted(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Tarefa concluída'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () {
                            // Implementar desfazer
                          },
                        ),
                      ),
                    );
                  } else {
                    // Excluir tarefa
                    taskProvider.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Tarefa excluída'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () {
                            // Implementar desfazer
                          },
                        ),
                      ),
                    );
                  }
                },
                child: TaskCard(
                  task: task,
                  onComplete: (id) {
                    taskProvider.markTaskAsCompleted(id);
                  },
                  onTap: (task) {
                    _showProcessTaskDialog(task);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
  
  /// Adiciona uma tarefa rápida
  void _addQuickTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.addTask(
        TaskEntity(
          title: text,
          status: TaskStatus.inbox,
        ),
      );
      _taskController.clear();
      _taskFocusNode.requestFocus();
    }
  }
  
  /// Exibe o diálogo para adicionar uma tarefa detalhada
  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const AddTaskBottomSheet(),
        );
      },
    );
  }
  
  /// Exibe o diálogo para processar uma tarefa
  void _showProcessTaskDialog(TaskEntity task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ProcessTaskBottomSheet(task: task),
        );
      },
    );
  }
}

/// Bottom sheet para adicionar uma tarefa detalhada
class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  int _energyLevel = 3;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nova Tarefa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Título
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          
          // Descrição
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição (opcional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          
          // Prioridade
          Row(
            children: [
              const Text(
                'Prioridade:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SegmentedButton<TaskPriority>(
                  segments: const [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text('Baixa'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text('Média'),
                      icon: Icon(Icons.remove),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text('Alta'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (Set<TaskPriority> newSelection) {
                    setState(() {
                      _priority = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Data de vencimento
          Row(
            children: [
              const Text(
                'Data:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _dueDate == null
                        ? 'Sem data'
                        : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                      });
                    }
                  },
                ),
              ),
              if (_dueDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Nível de energia
          Row(
            children: [
              const Text(
                'Energia:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _energyLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _getEnergyLabel(_energyLevel),
                  onChanged: (value) {
                    setState(() {
                      _energyLevel = value.round();
                    });
                  },
                ),
              ),
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '$_energyLevel',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Botões
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _saveTask();
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Retorna o rótulo do nível de energia
  String _getEnergyLabel(int level) {
    switch (level) {
      case 1:
        return 'Muito baixa';
      case 2:
        return 'Baixa';
      case 3:
        return 'Média';
      case 4:
        return 'Alta';
      case 5:
        return 'Muito alta';
      default:
        return 'Média';
    }
  }
  
  /// Salva a tarefa
  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O título é obrigatório'),
        ),
      );
      return;
    }
    
    final description = _descriptionController.text.trim();
    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.addTask(
      TaskEntity(
        title: title,
        description: description.isNotEmpty ? description : null,
        status: TaskStatus.inbox,
        priority: _priority,
        dueDate: _dueDate,
        energyLevel: _energyLevel,
      ),
    );
    
    Navigator.pop(context);
  }
}

/// Bottom sheet para processar uma tarefa
class ProcessTaskBottomSheet extends StatefulWidget {
  /// Tarefa a ser processada
  final TaskEntity task;
  
  /// Construtor
  const ProcessTaskBottomSheet({
    super.key,
    required this.task,
  });

  @override
  State<ProcessTaskBottomSheet> createState() => _ProcessTaskBottomSheetState();
}

class _ProcessTaskBottomSheetState extends State<ProcessTaskBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _priority;
  late DateTime? _dueDate;
  late int _energyLevel;
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
    _energyLevel = widget.task.energyLevel;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Processar Tarefa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Título
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          
          // Descrição
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição (opcional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          
          // Prioridade
          Row(
            children: [
              const Text(
                'Prioridade:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SegmentedButton<TaskPriority>(
                  segments: const [
                    ButtonSegment(
                      value: TaskPriority.low,
                      label: Text('Baixa'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TaskPriority.medium,
                      label: Text('Média'),
                      icon: Icon(Icons.remove),
                    ),
                    ButtonSegment(
                      value: TaskPriority.high,
                      label: Text('Alta'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (Set<TaskPriority> newSelection) {
                    setState(() {
                      _priority = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Data de vencimento
          Row(
            children: [
              const Text(
                'Data:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _dueDate == null
                        ? 'Sem data'
                        : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                      });
                    }
                  },
                ),
              ),
              if (_dueDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _dueDate = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Nível de energia
          Row(
            children: [
              const Text(
                'Energia:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _energyLevel.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _getEnergyLabel(_energyLevel),
                  onChanged: (value) {
                    setState(() {
                      _energyLevel = value.round();
                    });
                  },
                ),
              ),
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '$_energyLevel',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Botões de ação GTD
          const Text(
            'O que fazer com esta tarefa?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          
          // Botões de ação
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                icon: Icons.play_arrow,
                label: 'Iniciar',
                color: Colors.green,
                onPressed: () {
                  _updateTaskStatus(TaskStatus.inProgress);
                },
              ),
              _buildActionButton(
                icon: Icons.calendar_today,
                label: 'Agendar',
                color: Colors.blue,
                onPressed: () {
                  // Já implementado acima
                  _updateTask();
                },
              ),
              _buildActionButton(
                icon: Icons.folder,
                label: 'Projeto',
                color: Colors.orange,
                onPressed: () {
                  // Implementar adição a projeto
                },
              ),
              _buildActionButton(
                icon: Icons.person,
                label: 'Delegar',
                color: Colors.purple,
                onPressed: () {
                  _updateTaskStatus(TaskStatus.delegated);
                },
              ),
              _buildActionButton(
                icon: Icons.access_time,
                label: 'Adiar',
                color: Colors.amber,
                onPressed: () {
                  _updateTaskStatus(TaskStatus.deferred);
                },
              ),
              _buildActionButton(
                icon: Icons.archive,
                label: 'Arquivar',
                color: Colors.grey,
                onPressed: () {
                  _updateTaskStatus(TaskStatus.archived);
                },
              ),
              _buildActionButton(
                icon: Icons.delete,
                label: 'Excluir',
                color: Colors.red,
                onPressed: () {
                  _deleteTask();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  /// Constrói um botão de ação
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
    );
  }
  
  /// Retorna o rótulo do nível de energia
  String _getEnergyLabel(int level) {
    switch (level) {
      case 1:
        return 'Muito baixa';
      case 2:
        return 'Baixa';
      case 3:
        return 'Média';
      case 4:
        return 'Alta';
      case 5:
        return 'Muito alta';
      default:
        return 'Média';
    }
  }
  
  /// Atualiza a tarefa
  void _updateTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O título é obrigatório'),
        ),
      );
      return;
    }
    
    final description = _descriptionController.text.trim();
    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.updateTask(
      widget.task.copyWith(
        title: title,
        description: description.isNotEmpty ? description : null,
        priority: _priority,
        dueDate: _dueDate,
        energyLevel: _energyLevel,
      ),
    );
    
    Navigator.pop(context);
  }
  
  /// Atualiza o status da tarefa
  void _updateTaskStatus(TaskStatus status) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O título é obrigatório'),
        ),
      );
      return;
    }
    
    final description = _descriptionController.text.trim();
    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.updateTask(
      widget.task.copyWith(
        title: title,
        description: description.isNotEmpty ? description : null,
        status: status,
        priority: _priority,
        dueDate: _dueDate,
        energyLevel: _energyLevel,
      ),
    );
    
    Navigator.pop(context);
  }
  
  /// Exclui a tarefa
  void _deleteTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.deleteTask(widget.task.id);
    
    Navigator.pop(context);
  }
}
