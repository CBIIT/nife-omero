import subprocess
from glob import glob
from platform import uname
import omero, omero.scripts as scripts
from omero.gateway import BlitzGateway, ProjectWrapper, DatasetWrapper
from omero.model import ProjectI, DatasetI, ProjectDatasetLinkI, FilesetI, FilesetEntryI, NamedValue
from omero.rtypes import rstring, rlong, wrap

def create_project(conn, name):
    project = ProjectWrapper(conn, ProjectI())
    project.setName(name)
    project.save()
    return project

def create_dataset(conn, project, name):
    dataset = DatasetWrapper(conn, DatasetI())
    dataset.setName(name)
    dataset.save()

    link = ProjectDatasetLinkI()
    link.setParent(project._obj)
    link.setChild(dataset._obj)
    conn.getUpdateService().saveObject(link)

    return dataset

def get_project(conn, name):
    project = conn.getObject("Project", attributes={"name": name})
    return project or create_project(conn, name)

def get_dataset(conn, project, name):
    dataset = conn.getObject("Dataset", attributes={"name": name}, opts={"project": project.getId()})
    return dataset or create_dataset(conn, project, name)

def run():
    client = scripts.client(
        "Import_Images.py", 
        "Imports images into OMERO", 
        scripts.String("Project Name", optional=False),
        scripts.String("Dataset Name", optional=False),
        scripts.String("Files (Glob)", optional=False, default="/data/*.mrc"),
    )
    session_id = client.getSessionId()
    project_name = client.getInput("Project Name", unwrap=True)
    dataset_name = client.getInput("Dataset Name", unwrap=True)
    files_glob = client.getInput("Files (Glob)", unwrap=True)

    try:
        conn = BlitzGateway(client_obj=client)
        
        # Ensure project and dataset exist
        project = get_project(conn, project_name)
        dataset = get_dataset(conn, project, dataset_name)

        # List images to import (apply glob)
        input_files = glob(files_glob, recursive=True)

        for input_file in input_files:
            # import using omero cli
            import_command = [
                "omero", "import", 
                "--server", "localhost", 
                "--key", session_id,
                "--transfer", "ln_s",
                "-d", str(dataset.getId()), 
                input_file
            ]
            print(import_command)
            import_result = subprocess.run(import_command, capture_output=True, text=True)
            print(import_result.stdout)
            print(import_result.stderr)

        client.setOutput("Project ID", wrap(project.getId()))
        client.setOutput("Dataset ID", wrap(dataset.getId()))
        client.setOutput("Files", wrap(input_files))
    finally:
        client.closeSession()

if __name__ == "__main__":
    run()