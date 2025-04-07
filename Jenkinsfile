  pipeline {
      agent any

      environment {
          SONAR_HOME = tool "Sonar"
      }

      parameters {
          string(name: 'IMAGE_VERSION', defaultValue: 'latest', description: "Image tag")
      }

      stages {
          stage("Cleaning Workspace") {
              steps {
                  cleanWs()
              }
          }

          stage("Code Clone") {
              steps {
                  git url: "https://github.com/NikithaJain-git/Springboot-BankApp.git", branch: "DevOps"
              }
          }

          stage("Trivy File System Scan") {
              steps {
                  sh "trivy fs ."
              }
          }

          stage("OWASP Dependency-Check") {
              steps {
                  dependencyCheck additionalArguments: '--scan ./ --format XML', odcInstallation: 'OWASP'
                  dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
              }
          }

          stage("SonarQube Code Quality Analysis") {
              steps {
                  withSonarQubeEnv("Sonar") {
                      sh '''
                          ${SONAR_HOME}/bin/sonar-scanner \
                          -Dsonar.projectKey=bankapp \
                          -Dsonar.projectName=bankapp \
                          -Dsonar.exclusions=**/*.java
                      '''
                  }
              }
          }

          stage("SonarQube Quality Gate") {
              steps {
                  timeout(time: 2, unit: 'MINUTES') {
                      waitForQualityGate abortPipeline: true
                  }
              }
          }

          stage("Build Docker Image") {
              steps {
                  sh "docker build -t bankapp-eks:${params.IMAGE_VERSION} ."
              }
          }

          stage("Docker Push") {
              steps {
                  withCredentials([usernamePassword(
                      credentialsId: "dockerHub",
                      usernameVariable: "dockerHubuser",
                      passwordVariable: "dockerHubpass"
                  )]) {
                      sh "docker image tag bankapp-eks:${params.IMAGE_VERSION} ${dockerHubuser}/bankapp-eks:${params.IMAGE_VERSION}"
                      sh "docker login -u ${dockerHubuser} -p ${dockerHubpass}"
                      sh "docker push ${dockerHubuser}/bankapp-eks:${params.IMAGE_VERSION}"
                  }
              }
          }
      }

      post {
          success {
              script {
                  emailext(
                      from: 'nikithajain56789@gmail.com',
                      to: 'nikithajain56789@gmail.com',
                      subject: 'Build Success for Bankapp CICD',
                      body: 'Build Success for Bankapp CICD'
                  )
              }
          }
      }
  }
