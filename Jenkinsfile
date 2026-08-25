pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time:30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
    environment{
        appVersion = ''
        project = "roboshop"
        component = 'cart'
        region = 'us-east-1'
        ACC_ID = '388343452532'
    }
    stages{
        stage('reda the package.json') {
           steps{
                script {
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "application version ${appVersion}"
                }
            }
        }
        stage('install depencies'){
            steps{
                sh """
                  npm install
                """
            }
        }
    //     stage('scan libraries alerts'){
    //         steps{
    //             script{
    //                 def alerts = readJSON text: response

    //                 def highCriticalOpen = alerts.findAll { alert ->

    //                     def severity = alert.security_advisory?.severity?.toLowerCase()
    //                     def state = alert.state?.toLowerCase()

    //                     state == 'open' &&
    //                     (severity == 'high' || severity == 'critical')
    //                 }

    //                 if (highCriticalOpen.size() > 0) {

    //                     echo "❌ Found ${highCriticalOpen.size()} OPEN HIGH/CRITICAL Dependabot alerts"

    //                     highCriticalOpen.each { alert ->
    //                         echo "Package: ${alert.dependency.package.name}"
    //                         echo "Severity: ${alert.security_advisory.severity}"
    //                         echo "State: ${alert.state}"
    //                     }

    //                     error("Dependabot quality gate failed")

    //                 } else {

    //                     echo "✅ No OPEN HIGH/CRITICAL Dependabot alerts found."

    //                 }
    //             }
    //         }
    //    }
    //     stage('sonarQube scan'){
    //         environment {
    //             scannerHome = tool 'sonar'
    //         }
    //         steps{
    //             withSonarQubeEnv('sonar'){
    //                 sh """
    //                   ${scannerHome}/bin/sonar-scanner
    //                 """
    //             }
    //         }
    //     }
    //     stage('Quality gates'){
    //         steps{
    //              waitForQualityGate abortPipeline: true
    //         }
    //     }
            stage('Build Docker image'){
                steps{
                    withAWS(credentials: 'aws-cred', region: 'us-east-1'){
                        sh """
                            aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion} .
                            docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion}
                        """
                    }
                }
            }
            // stage('scan ecr image'){
            //     steps{
            //         def findings = sh(
            //             script: """
            //                 aws ecr describe-image-scan-findings \
            //                 --repository-name roboshop/catalogue \
            //                 --image-id imageDigest=sha256:be555a9f8dd81cd3fefdbb0d144216d5249cc2464ae522d64e29a8a44393f00e \
            //                 --region us-east-1 \
            //                 --output json

            //             """, 
            //             returnStdout: true
                        
            //             ).trim();
            //             def json = readJSON text: findings
            //             def highCritical = json.imageScanFindings.findings.findAll {
            //             it.severity == "HiGH" || it.severity == "CRITICAL"
            //             }
            //             if (highCritical.size() > 0)
            //             {
            //                 echo "❌ Found ${highCritical.size()} HIGH/CRITICAL vulnerabilities!"
            //                 currentBuild.result = 'FAILURE'
            //                 error("Build failed due to vulnerabilities")
            //             } else {
            //             echo "✅ No HIGH/CRITICAL vulnerabilities found."
            //             }
                        
                            
            //     }
            // }
            stage("tigger deployment"){
                steps{
                    build job: 'cart-cd',
                    parameters: [
                        string(name: 'appVersion', value: "${appVersion}"), 
                        string(name: 'deploy_to', value: 'dev')
                    ],
                    wait: false, 
                    propagate: false

                }
            } 


    }
    post {
        always {
           echo "i am always block"
        }
        success {
           echo "i am success"
        }
        failure {
           echo "i am failure"
        }
    }
}