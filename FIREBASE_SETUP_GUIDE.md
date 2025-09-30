# 🔥 Guia de Configuração do Firebase para Focora

Este guia explica como configurar o Firebase para o projeto Focora, incluindo Analytics e App Distribution.

## 📚 Índice
1. [Criar Projeto no Firebase](#1-criar-projeto-no-firebase)
2. [Registrar o App Android](#2-registrar-o-app-android)
3. [Configurar o Google Services](#3-configurar-o-google-services)
4. [Configurar o Firebase App Distribution](#4-configurar-o-firebase-app-distribution)
5. [Gerar Token do Firebase CLI](#5-gerar-token-do-firebase-cli)
6. [Configurar Segredos no GitHub](#6-configurar-segredos-no-github)

## 1. Criar Projeto no Firebase

### 1.1. Acesse o Console do Firebase
- Vá para [firebase.google.com](https://firebase.google.com) e faça login com sua conta Google

### 1.2. Crie um Novo Projeto
- Clique em "Adicionar projeto"
- Nome do projeto: `Focora`
- Escolha se deseja ativar o Google Analytics (recomendado)
- Clique em "Continuar" e siga as instruções para concluir a criação

## 2. Registrar o App Android

### 2.1. Na Página Inicial do Projeto
- Clique no ícone do Android para adicionar um app Android

### 2.2. Registre o App
- **Nome do pacote Android**: `com.focora.focora`
- **Apelido do app**: `Focora Android`
- **Certificado de assinatura de depuração SHA-1** (opcional)
- Clique em "Registrar app"

### 2.3. Baixe o Arquivo de Configuração
- Baixe o arquivo `google-services.json`
- Este arquivo contém todas as informações necessárias para conectar seu app ao Firebase

## 3. Configurar o Google Services

### 3.1. Coloque o Arquivo no Local Correto
- Coloque o arquivo `google-services.json` na pasta `android/app/` do seu projeto

### 3.2. Verifique as Configurações do Gradle
O arquivo `android/build.gradle` deve conter:
```gradle
buildscript {
    dependencies {
        // ...
        classpath 'com.google.gms:google-services:4.4.3'
    }
}
```

O arquivo `android/app/build.gradle` deve conter:
```gradle
plugins {
    // ...
    id "com.google.gms.google-services"
}

dependencies {
    // ...
    implementation platform('com.google.firebase:firebase-bom:34.3.0')
    implementation 'com.google.firebase:firebase-analytics'
}
```

## 4. Configurar o Firebase App Distribution

### 4.1. No Console do Firebase
- Vá para "App Distribution" no menu lateral
- Clique em "Começar"

### 4.2. Configure Grupos de Testadores
- Clique em "Criar grupo"
- Nome do grupo: `testers`
- Adicione emails dos testadores
- Clique em "Criar grupo"

## 5. Gerar Token do Firebase CLI

### 5.1. Instale o Firebase CLI
- Se você ainda não tem o Firebase CLI instalado:
  ```
  npm install -g firebase-tools
  ```

### 5.2. Faça Login e Gere o Token
- Execute o comando:
  ```
  firebase login:ci
  ```
- Siga as instruções para fazer login no navegador
- Copie o token gerado (será usado como segredo no GitHub)

## 6. Configurar Segredos no GitHub

### 6.1. Obtenha os Valores Necessários
Do arquivo `google-services.json`:
- **FIREBASE_PROJECT_ID**: Valor de `project_id`
- **FIREBASE_APP_ID**: Valor de `mobilesdk_app_id`
- **PACKAGE_NAME**: Valor de `package_name`

Do comando `firebase login:ci`:
- **FIREBASE_TOKEN**: Token gerado pelo comando

### 6.2. Adicione os Segredos no GitHub
- No seu repositório GitHub, vá para Settings > Secrets and variables > Actions
- Adicione cada um dos segredos acima

## ✅ Verificação Final

Para verificar se tudo está configurado corretamente:

1. **Compile o App Localmente**
   ```
   flutter build apk
   ```

2. **Verifique o Firebase Console**
   - Você deve ver eventos do Firebase Analytics aparecendo

3. **Faça um Push para a Branch Main**
   - O pipeline CI/CD deve compilar o app e enviá-lo para o Firebase App Distribution

## 🔍 Solução de Problemas

### Erro: "File google-services.json is missing"
- **Problema**: O arquivo não está no local correto
- **Solução**: Verifique se o arquivo está em `android/app/google-services.json`

### Erro: "Failed to apply plugin 'com.google.gms.google-services'"
- **Problema**: Plugin do Google Services não está configurado corretamente
- **Solução**: Verifique as configurações nos arquivos build.gradle

### Erro: "Could not find method implementation() for arguments"
- **Problema**: Sintaxe incorreta no build.gradle
- **Solução**: Verifique se está usando a sintaxe correta para a versão do Gradle

---

Se você encontrar algum problema não listado aqui, consulte a [documentação oficial do Firebase](https://firebase.google.com/docs/flutter/setup).
