 uberany
## Summary
The idea is to point this Docker at any git repo and have it run the project.

In order for this to work, the project should have a run.sh to run the code. If installation or setup for the code is required, an optional build.sh can be used which will be run straight after the project is checked out into the Container.

It also assumes that the project uses *one* of:

* NodeJS & npm (v 0.10.25/v 1.4.21)
* Python (v 2.7.9)
* Java (v 1.8.0-66-b17)
* Clojure (v 2.5.3)
* Ruby (v 2.?)

## Deployment
The git repo is *ALWAYS* checked out to the /home/project directory in the Container. It does not use the repo name as a directory. Restarting an existing container will re-start the project - it will not re-clone or re-run the build.sh file from the git repo unless you delete the */home/project* directory before the restart.

## Build.sh

A build.sh for a NodeJS project can be as simple as

```bash
#!/bin/bash

npm install
```

## Run.sh
Equally, the run script could be

```bash
#!/bin/bash

node app.js
```

# Build Container
Checkout the uberany project into a folder and then build the Docker Container using:

```bash
docker build -t uberany .
```

# Usage
You can then run the Docker using the following command.

```bash
docker run -d -p 3000:3000 -p 8080:8080 -p 80:80 --name ????? -e giturl=??? uberany
```

This will run a Container in detached mode - perfect for use with web based apps. For command line/bash based apps we could use:

```bash
docker run -t -i --name ????? -e giturl=??? uberany
```

This assumes that the git hub repo will be accessible without a user and password being supplied. If you want to use a login & password, specify it as part of the run command.

```bash
docker run -t -i --name ????? -e giturl=??? -e username=XXXX -e password=YYYY uberany
```

By default UberAny will use the *master* branch of the specified repo. If you want to use another add

```bash
-e branch=?????
```
so the command could be

```bash
docker run -t -i --name ????? -e giturl=??? -e username=XXXX -e password=YYYY -e branch=???? uberany
```

### Notes
* You need to specify the *working name* of the container and the **HTTPS path** to the git repo you want to clone from.
* Only ports 3000, 8080 & 80 are exposed by Docker. If you want to open others, you will need to modify the Dockerfile prior to building the Container.
* You still need to map the ports when you start the Container!
* Remember 'localhost' won't work - you will need the Container IP!
