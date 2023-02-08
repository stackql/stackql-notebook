<a href="https://stackql.io/" target="_blank">
<img src="assets/stackql-logo-bold.png" alt="StackQL" width="33%" height="33%">
</a>
<br />

![License](https://img.shields.io/github/license/stackql/stackql)

## StackQL Jupyter Notebook Template Repository

Template repository to create a StackQL analytics notebook Docker container image including StackQL, Jupyter and Python (including `pandas`).  

> Use StackQL to query cloud inventory and perform analysis and visualisations for security analysis, cost management and optimization, and for cloud automation and provisioning.  For more information see the [StackQL documentation](https://stackql.io/docs).

## Usage

<!--ts-->
   * [1. Prerequisites](#1-prerequisites)
   * [2. Configure providers](#2-configure-providers)
   * [3. Set up auth variables and keys](#3-set-up-auth-variables-and-keys)
   * [4. Build image](#4-build-image)
   * [5. Run notebook](#5-run-notebook)
   * [6. Use the notebook](#6-use-the-notebook)
   * [7. Stop and remove container](#7-stop-and-remove-container)
   * [8. Remove the image (optional)](#8-remove-the-image-optional)
<!--te-->  

<br />

### 1. Prerequisites

- Docker

### 2. Configure providers

Configure the providers you want to query in your notebook using the `config/providers` file, edit this file adding each provider on a new line, for example:  

```
aws
azure
github
```

Modify the `config/providerAuth.json` file to include the authentication objects for the providers you declared in your `config/providers` file,  for example:  

```json
{
    "aws": { 
        "type": "aws_signing_v4",
        "credentialsenvvar": "AWS_SECRET_ACCESS_KEY", 
        "keyIDenvvar": "AWS_ACCESS_KEY_ID" 
    },
    "github": { 
        "type": "basic", 
        "credentialsenvvar": "GITHUB_CREDS"
    }
}
```

For more information on how to configure providers, see the instructions for given provider at [registry.stackql.io](https://registry.stackql.io/).  

### 3. Set up auth variables and keys

You will need to setup credentials in enviroment variables for the providers required by... 
- adding the appropriate service account key(s) to the `keys/` directory 
- populating the necessary environment variables on your host machine (passed to the docker container at runtime), examples are shown here:

<details>
<summary>Setting Environment Variables (bash)</summary>
<p>

```bash
export AWS_ACCESS_KEY_ID=YOURACCESSKEYID
export AWS_SECRET_ACCESS_KEY=YOURSECRETACCESSKEY
export GITHUB_CREDS=$(echo -n 'githubusername:your_github_personal_access_token' | base64)
```

</p>
</details>

<details>
<summary>Setting Environment Variables (powershell)</summary>
<p>

```powershell
$Env:AWS_ACCESS_KEY_ID = "YOURACCESSKEYID"
$Env:AWS_SECRET_ACCESS_KEY = "YOURSECRETACCESSKEY"
$Env:GITHUB_CREDS = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("githubusername:your_github_personal_access_token"))
```

</p>
</details>

### 4. Build image

Build the image using the following command:  

```
docker build --no-cache -t stackql-notebook .
```

### 5. Run notebook

To run the notebook locally in detatched mode, execute the following command:  

```bash
docker run -d -p 8888:8888 \
-e AWS_ACCESS_KEY_ID \
-e AWS_SECRET_ACCESS_KEY \
-e GITHUB_CREDS \
stackql-notebook \
/bin/sh -c "/scripts/entrypoint.sh"
```
or using PowerShell:  

```powershell
docker run -p 8888:8888 `
-e AWS_ACCESS_KEY_ID `
-e AWS_SECRET_ACCESS_KEY `
-e GITHUB_CREDS `
stackql-notebook `
/bin/sh -c "/scripts/entrypoint.sh"
```

### 6. Use the notebook

Once the container is running, you can access the notebook by opening a browser to http://localhost:8888.  

<p align="center">
  <img src="images/stackql-jupyter.png" alt="StackQL" width="70%" height="70%">
</p>

Open the `stackql.ipynb` notebook and run the cells.  In your own repositiory, you can add your own notebooks and use StackQL to query the providers you configured.

### 7. Stop and remove container

To stop and remove the container when you're finished, run...   

```
docker stop $(docker ps -l -q --filter status=running --filter ancestor=stackql-notebook)
docker rm $(docker ps --filter status=exited --filter ancestor=stackql-notebook -q)
```

### 8. Remove the image (optional)

To remove the image locally run:
```bash 
docker rmi stackql-notebook
```