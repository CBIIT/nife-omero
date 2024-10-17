# OMERO

This repository provides Dockerfiles and configurations for deploying a customized OMERO server and web interface tailored for the NCI Imaging Facilities Environment (NIFE). NIFE is a resource for managing and analyzing microscopy images across NCI’s intramural imaging facilities, enabling researchers to access imaging data and initiate computational workflows.

## Getting Started

#### Clone the repository
```bash
Copy code
git clone https://github.com/cbiit/omero.git
cd omero
```

#### Start the services using `docker-compose`
```bash
docker-compose up
```
Before starting, review and customize the configuration files (e.g., database credentials) as needed.

#### Access the OMERO web interface
- Navigate to `http://localhost:4080` in your browser.
- Log in using the default OMERO credentials or those set during configuration.


#### Access the PostgreSQL database
Database credentials are defined in the `docker-compose.yml` file. For database administration, we recommend using a tool like pgAdmin.

#### Stop the services
```bash
docker-compose down
```


## OMERO.web Applications

A sample OMERO.web application is included in the `web/apps/webapp` directory. Once the services are running, you can access it at `http://localhost:4080/webapp`.

Ensure web applications and subfolders are named consistently, as the folder name is used as the application name within OMERO.web.


### Static Files

Static files are stored in `web/static/` and copied to the static directory on container startup. They are accessible via the `/static` path. For example, `web/static/assets/favicon.ico` is available at `http://localhost:4080/static/assets/favicon.ico`.


### Customizations
To modify the web interface, adjust the following OMERO configuration options:
- omero.web.template_dirs: Specifies directories containing web templates, set to `["/opt/omero/web/OMERO.web/templates"]`
- omero.web.index_template: Sets the default index page template, typically `"index.html"`

The `docker-compose.yml` file mounts the `web/templates` folder to `/opt/omero/web/OMERO.web/templates`, allowing easy customization of templates.

## OMERO.server scripts

The `server/scripts` directory contains sample OMERO.server scripts for various server-side tasks, such as image import and processing.

