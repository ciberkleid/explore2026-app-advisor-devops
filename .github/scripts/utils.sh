#!/usr/bin/env bash
# Utility functions for use in CI workflows. Source this file to use them:
#   source utils.sh

# Strips carriage returns and in-place progress lines from advisor CLI output.
cleanOutput() { tr '\r' '\n' | { grep -Ev "[🏃🔨].*\[[0-9]+m [0-9]+s\]$" || true; } }

# Downloads and installs the advisor CLI. Requires BC_REG_TOKEN and ADVISOR_VERSION env vars.
installAdvisor() {
  echo "Installing advisor CLI - version ${ADVISOR_VERSION}"
  curl -fsSL \
    -H "Authorization: Bearer ${BC_REG_TOKEN}" \
    -o /tmp/advisor-cli.tar \
    "https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/${ADVISOR_VERSION}/application-advisor-cli-linux-${ADVISOR_VERSION}.tar"
  tar -xf /tmp/advisor-cli.tar -C /tmp --strip-components=1 --exclude=./META-INF
  install /tmp/advisor /usr/local/bin/advisor
}

# Downloads and installs the trivy CLI.
installTrivy() {
  echo "Installing trivy CLI - latest version"
  curl -fsSL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
    | sh -s -- -b /usr/local/bin # Consider pinning a specific version.
}
