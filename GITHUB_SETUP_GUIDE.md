# 📋 Guia Completo: Configuração do Repositório GitHub para Focora

Este guia detalhado vai te ajudar a configurar corretamente o repositório GitHub para o projeto Focora, incluindo CI/CD e segredos.

## 📚 Índice
1. [Criar o Repositório](#1-criar-o-repositório)
2. [Configurar o Repositório Local](#2-configurar-o-repositório-local)
3. [Estruturar as Branches](#3-estruturar-as-branches)
4. [Configurar Segredos](#4-configurar-segredos)
5. [Verificar o Pipeline CI/CD](#5-verificar-o-pipeline-cicd)
6. [Solução de Problemas](#6-solução-de-problemas)

## 1. Criar o Repositório

### 1.1. Acesse o GitHub
- Vá para [github.com](https://github.com) e faça login na sua conta

### 1.2. Crie um Novo Repositório
- Clique no botão "+" no canto superior direito
- Selecione "New repository"
- Nome do repositório: `Focora`
- Descrição: `Aplicativo anti-procrastinação desenvolvido com Flutter`
- Visibilidade: Pública ou Privada (sua escolha)
- **NÃO** inicialize com README, .gitignore ou licença
- Clique em "Create repository"

## 2. Configurar o Repositório Local

### 2.1. Extraia o Projeto
- Extraia o arquivo ZIP do projeto Focora em uma pasta no seu computador

### 2.2. Abra o Terminal/Prompt de Comando
- Navegue até a pasta do projeto:
  ```cmd
  cd caminho\para\focora-clean
  ```

### 2.3. Inicialize o Git
```cmd
git init
```

### 2.4. Configure seu Nome e Email (se ainda não configurou)
```cmd
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"
```

### 2.5. Adicione o Repositório Remoto
```cmd
git remote add origin https://github.com/SEU-USUARIO/Focora.git
```
(Substitua `SEU-USUARIO` pelo seu nome de usuário do GitHub)

### 2.6. Adicione os Arquivos e Faça o Primeiro Commit
```cmd
git add .
git commit -m "🚀 Initial commit: Focora app"
```

### 2.7. Crie a Branch Principal e Faça o Push
```cmd
git branch -M main
git push -u origin main
```

## 3. Estruturar as Branches

### 3.1. Crie a Branch Develop
```cmd
git checkout -b develop
git push -u origin develop
```

### 3.2. Volte para a Branch Main
```cmd
git checkout main
```

## 4. Configurar Segredos

### 4.1. Acesse as Configurações do Repositório
- No GitHub, vá para seu repositório
- Clique na aba "Settings"
- No menu lateral, clique em "Secrets and variables" > "Actions"

### 4.2. Adicione os Segredos Necessários
Clique em "New repository secret" e adicione cada um dos seguintes:

| Nome do Segredo | Descrição | Valor |
|-----------------|-----------|-------|
| `FIREBASE_TOKEN` | Token de autenticação do Firebase | Valor obtido com `firebase login:ci` |
| `FIREBASE_PROJECT_ID` | ID do projeto no Firebase | `focora-d9034` (ou seu ID) |
| `FIREBASE_APP_ID` | ID do aplicativo no Firebase | `1:874427490149:android:1cef39feec7c7b6dcb0b8c` (ou seu ID) |
| `PACKAGE_NAME` | Nome do pacote Android | `com.focora.focora` |

### 4.3. Segredos Opcionais (para Configuração Futura)
Estes podem ser adicionados posteriormente:

| Nome do Segredo | Descrição |
|-----------------|-----------|
| `APP_IDENTIFIER` | Identificador do app na App Store |
| `APPLE_ID` | ID da sua conta de desenvolvedor Apple |
| `CODECOV_TOKEN` | Token para relatórios de cobertura de código |

## 5. Verificar o Pipeline CI/CD

### 5.1. Acesse a Aba Actions
- No GitHub, vá para seu repositório
- Clique na aba "Actions"

### 5.2. Verifique o Workflow
- Você deve ver o workflow "Focora CI/CD (Android Focus)" listado
- Se não estiver executando automaticamente, clique em "Run workflow" > "Run workflow"

### 5.3. Monitore a Execução
- Clique no workflow em execução para ver os detalhes
- Verifique o progresso de cada job:
  - Build & Test
  - End-to-End Tests
  - Build Android Release (se estiver na branch main)

## 6. Solução de Problemas

### 6.1. Erro: "No such file or directory"
- **Problema**: Arquivos necessários não foram encontrados
- **Solução**: Verifique se todos os arquivos foram extraídos corretamente e estão na estrutura de pastas correta

### 6.2. Erro: "Failed to install the following Android SDK packages"
- **Problema**: Faltam componentes do Android SDK no ambiente de CI
- **Solução**: Este erro é esperado no ambiente de CI e geralmente não impede o build

### 6.3. Erro: "Could not find a file named 'pubspec.yaml'"
- **Problema**: O arquivo pubspec.yaml não foi encontrado
- **Solução**: Verifique se o arquivo está na raiz do projeto

### 6.4. Erro: "No firebase_app_id_file.json found"
- **Problema**: Configuração do Firebase incompleta
- **Solução**: Verifique se o arquivo google-services.json está em android/app/

### 6.5. Erro nos Testes E2E
- **Problema**: Os testes E2E falham no ambiente de CI
- **Solução**: Isso é esperado, pois o emulador pode não iniciar corretamente. O pipeline está configurado para continuar mesmo se os testes E2E falharem.

## 🎯 Próximos Passos

Após configurar com sucesso o repositório e o pipeline CI/CD:

1. **Desenvolva Novas Funcionalidades**
   - Crie branches a partir de `develop` (ex: `feature/nova-funcionalidade`)
   - Faça PRs para mesclar de volta para `develop`

2. **Prepare Releases**
   - Quando `develop` estiver estável, faça um PR para `main`
   - Isso acionará o pipeline completo, incluindo deploy

3. **Monitore o Firebase App Distribution**
   - Após um build bem-sucedido na branch `main`, verifique o Firebase App Distribution para o novo release

---

Se você encontrar algum problema não listado aqui, sinta-se à vontade para abrir uma issue no repositório GitHub.
