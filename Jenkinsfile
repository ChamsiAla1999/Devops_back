pipeline {
    agent any
    
    tools{
        nodejs "node"
    }
    
//****************** BUILD BACKEND - SPRINGBOOT **************************
    stages {
        stage('Checkout backend') {
            steps {
                // Utilisation de Git pour récupérer le code
                git branch: 'main', url: 'https://github.com/ChamsiAla1999/Devops_back.git'
            }
        }
        
                stage('Clean compile maven') {
            steps {
                // Exécution des commandes Maven
                  withEnv(["JAVA_HOME=${tool name: 'JAVA_HOME', type: 'jdk'}"]) {
                sh 'mvn clean compile'
            }
                
            }
        }
        
                stage('BUILD Backend- INSTALL') {
            steps {
                withEnv(["JAVA_HOME=${tool name: 'JAVA_HOME', type: 'jdk'}"]) {
                    sh 'mvn clean install'
                }
            }
        }
        
//************************************* BUILD FRONTEND - ANGULAR ***************************
                stage('Checkout Frontend Repo') {
                    steps {
                        script {
                            checkout([
                                $class: 'GitSCM',
                                branches: [[name: 'main']],
                                userRemoteConfigs: [[url: 'https://github.com/ChamsiAla1999/Devops_Front.git']]
                            ])
                        }
                    }
                }


                stage('Build Frontend') {
                    steps {
                        sh 'npm install'
                        sh 'npm run ng build'
                    }
                }
                


         stage('Deploy to Nexus Repository') {
        steps {
                
            
        script {
       //  Add the Git checkout step for the backend repository here
        checkout([
        $class: 'GitSCM',
        branches: [[name: '*/main']],
        userRemoteConfigs: [[url: 'https://github.com/ChamsiAla1999/Devops_back.git']]
        ])
                        
        withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'pwd', usernameVariable: 'name')]) {
        withEnv(["JAVA_HOME=${tool name: 'JAVA_HOME', type: 'jdk'}"]) {
        sh "mvn deploy -s /usr/share/maven/conf/settings.xml -Dusername=\$name -Dpassword=\$pwd"        }
        }
        }
        }
        }
       

   stage('SonarQube') {
        steps{
        withSonarQubeEnv('sonarqube-10.2.1') { 
        // If you have configured more than one global server connection, you can specify its name
//      sh "${scannerHome}/bin/sonar-scanner"
       // sh "mvn sonar:sonar"
        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=demoapp-project -Dsonar.projectName='demoapp-project'"
    }
        }

//         stage('Clean Workspace') {
//             steps {
//                 deleteDir()
//        }
// }
    }


 stage('Build and Push back Image') {
             steps {
                 script {
                     // Ajoutez l'étape Git checkout pour le référentiel backend ici
                     checkout([
                         $class: 'GitSCM',
                         branches: [[name: '*/main']],
                         userRemoteConfigs: [[url: 'https://github.com/ChamsiAla1999/Devops_back.git']]
                     ])

        //             // Build the backend Docker image
                     def backendImage = docker.build('chamsiala/spring-app', '-f /var/lib/jenkins/workspace/project/Dockerfile .')

        //             // Authentification Docker Hub avec des informations d'identification secrètes
                     withCredentials([string(credentialsId: 'docker', variable: 'pwd')]) {
                         sh "docker login -u chamsiala -p docker1234 "
                         // Poussez l'image Docker
                         backendImage.push()
                     }
                 }
             }
         }
         
        stage('Build and Push Frontend Image') {
    steps {
        script {
            // Add the Git checkout step for the backend repository here
            checkout([
                $class: 'GitSCM',
                branches: [[name: '*/main']],
                userRemoteConfigs: [[url: 'https://github.com/ChamsiAla1999/Devops_Front.git']]
            ])
            
            // Authenticate with Docker Hub using credentials
            withCredentials([string(credentialsId: 'docker', variable: 'pwd')]) {
                sh "docker login -u chamsiala -p docker1234"
            }
            
            // Build the backend Docker image
            def backendImage = docker.build('chamsiala/node-app', '-f Dockerfile .')
            
            // Push the Docker image
            backendImage.push()
        }
    }
}

         
         
         
         
         
         stage('Run Docker Compose Back') {
     steps {
         script {'-f Dockerfile .'
             checkout([
                 $class: 'GitSCM',
                 branches: [[name: '*/main']], 
                 userRemoteConfigs: [[url: 'https://github.com/ChamsiAla1999/Devops_back.git']]
             ])'-f Dockerfile .'

            sh 'docker-compose -f /var/lib/jenkins/workspace/project/Docker-compose.yml up -d'

            
         }
     }
 }
 

         
    } }
    
