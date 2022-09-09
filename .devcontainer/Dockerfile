# Find the Dockerfile at this URL
# https://github.com/Azure/azure-functions-docker/blob/dev/host/4/bullseye/amd64/python/python39/python39-core-tools.Dockerfile
FROM mcr.microsoft.com/azure-functions/python:4-python3.9-core-tools

# Install Node.js and Azure tools
ARG NODE_VERSION="16"
ENV NVM_DIR="/usr/local/share/nvm" \
    NVM_SYMLINK_CURRENT=true \
    PATH="${NVM_DIR}/current/bin:${PATH}"
RUN curl -sfL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/node-debian.sh" | bash -s -- "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
    && su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1" \
    && su vscode -c "npm install --cache /tmp/empty-cache -g @azure/static-web-apps-cli" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this section to install additional OS packages.
RUN export DEBIAN_FRONTEND=noninteractive \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get -y install --no-install-recommends gh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "npm install --cache /tmp/empty-cache -g <your-package-here>"
