import groovy.transform.Field

@Field String basePath = 'infra'
@Field String servicePath = 'chef'
@Field String defaultPollingScm = 'H/5 * * * *'

JobConstructor[] jobList = [
        [
                "chefRepo",
                "https://github.com/ppalit/devops_toolchain.git",
                defaultPollingScm
        ],
        [
                "devops_commons",
                "https://github.com/ppalit/devops_toolchain.git",
                defaultPollingScm
        ]
]

class JobConstructor {
    def jobName = ""
    def jobGitUrl = ""
    def jobPollingScm = ""

    private JobConstructor(String jobName, String jobGitUrl, String jobPollingScm) {
        this.jobName = jobName
        this.jobGitUrl = jobGitUrl
        this.jobPollingScm = jobPollingScm
    }
}

folder(basePath) {
    description "Overview of all jobs for " + basePath + "managed by Devops"
}

folder(servicePath) {
    description "Overview of all " + servicePath + " related jobs."
}

jobList.each { job ->
    println "[INFO] Generating view... " + basePath
    println "[INFO] Generating job... " + job.jobName

    def index = 0
    def jobName = job.jobName
    def jobGitUrl = job.jobGitUrl
    def jobPollingScm = job.jobPollingScm

    multibranchPipelineJob(basePath + "/"+ servicePath +"/" + jobName) {
        displayName(jobName)
        branchSources {
            git {
                id(jobName)
                remote(jobGitUrl)
                credentialsId(jenkinsCredentialId)
            }
        }
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'repo irl']]])
        script {
    // some block
}
        triggers {
            cron(jobPollingScm)
        }
    }
}

listView(basePath) {
    recurse(true)
    jobs {
        jobList.each { job ->
            name(basePath + "/" + servicePath + "/"+ job.jobName)
        }
    }
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
}
