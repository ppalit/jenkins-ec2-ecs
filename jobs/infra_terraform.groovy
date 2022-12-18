import groovy.transform.Field

@Field String basePath = 'infra'
@Field String servicePath = 'iac'
@Field String defaultPollingScm = 'H/5 * * * *'

JobConstructor[] jobList = [
        [
                "npd-network",
                "https://github.com/ppalit/devops_toolchain.git",
                defaultPollingScm
        ],
        [
                "npd-iam",
                "https://github.com/ppalit/devops_toolchain.git",
                defaultPollingScm
        ],
        [
                "npd-security",
                "https://github.com/ppalit/devops_toolchain.git",
                defaultPollingScm
        ],
        [
                "npd-chefInfra",
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

    pipelineJob(basePath + "/"+ servicePath +"/" + jobName)  {
        triggers {
            cron(jobPollingScm)
        }
        definition {
        cpsScm {
            scm {
                git(jobGitUrl)
            }
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
