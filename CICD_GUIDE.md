# 🚀 Guia Simplificado de CI/CD para Focora

Este guia explica como funciona o pipeline de CI/CD do Focora e como solucionar problemas comuns.

## 📚 Índice
1. [Visão Geral do Pipeline](#1-visão-geral-do-pipeline)
2. [Estrutura do Workflow](#2-estrutura-do-workflow)
3. [Abordagem Gradual](#3-abordagem-gradual)
4. [Solução de Problemas](#4-solução-de-problemas)
5. [Melhorias Futuras](#5-melhorias-futuras)

## 1. Visão Geral do Pipeline

O pipeline de CI/CD do Focora automatiza:
- Compilação do código
- Execução de testes
- Build de versões de release
- Deploy para Firebase App Distribution

### Fluxo de Trabalho:
1. Desenvolvedor faz push para o GitHub
2. GitHub Actions executa o workflow
3. Testes são executados
4. Se os testes passarem e for a branch main, um build de release é gerado
5. O build é enviado para o Firebase App Distribution

## 2. Estrutura do Workflow

O workflow é dividido em jobs independentes:

### 2.1. Build & Test
- Compila o código
- Executa análise estática
- Executa testes unitários e de widget
- Gera relatório de cobertura

### 2.2. End-to-End Tests
- Configura um emulador Android
- Executa testes E2E
- Configurado para continuar mesmo se falhar

### 2.3. Build Android Release
- Gera APK e AppBundle para release
- Salva os artefatos para download

### 2.4. Deploy Firebase
- Envia o build para o Firebase App Distribution
- Adiciona notas de release automáticas

### 2.5. Notify Completion
- Notifica sobre o status do build

## 3. Abordagem Gradual

Para garantir que o pipeline funcione corretamente, recomendamos uma abordagem gradual:

### Fase 1: Pipeline Básico
- Apenas compilação e testes unitários
- Sem deploy automático

### Fase 2: Pipeline Intermediário
- Adicionar testes de widget
- Gerar builds de release
- Salvar artefatos

### Fase 3: Pipeline Completo
- Adicionar testes E2E
- Configurar deploy para Firebase
- Adicionar notificações

## 4. Solução de Problemas

### 4.1. Erros Comuns

#### "Flutter command not found"
- **Problema**: Flutter não está instalado no ambiente de CI
- **Solução**: O workflow já inclui a configuração do Flutter

#### "Could not find a file named 'pubspec.yaml'"
- **Problema**: O workflow está sendo executado no diretório errado
- **Solução**: Verifique se o repositório está estruturado corretamente

#### "No tests were found"
- **Problema**: Os testes não estão sendo detectados
- **Solução**: Verifique se os arquivos de teste seguem o padrão `*_test.dart`

#### "Execution failed for task ':app:processDebugGoogleServices'"
- **Problema**: Arquivo google-services.json ausente ou inválido
- **Solução**: Verifique se o arquivo está em `android/app/`

### 4.2. Verificando Logs

Para diagnosticar problemas:
1. Vá para a aba "Actions" no GitHub
2. Clique no workflow que falhou
3. Expanda o job que falhou
4. Examine os logs detalhados

## 5. Melhorias Futuras

Quando o pipeline básico estiver funcionando, considere estas melhorias:

### 5.1. Versão Automática
- Incrementar automaticamente o número de versão
- Usar tags do Git para controlar versões

### 5.2. Testes em Múltiplas Plataformas
- Adicionar testes para iOS
- Testar em diferentes versões do Android

### 5.3. Análise de Qualidade
- Integrar com ferramentas como SonarQube
- Adicionar verificações de acessibilidade

### 5.4. Deploy para Lojas
- Configurar deploy automático para Google Play
- Configurar deploy automático para App Store

---

Lembre-se: Um pipeline CI/CD é uma ferramenta viva que deve evoluir com seu projeto. Comece simples e adicione complexidade conforme necessário.
