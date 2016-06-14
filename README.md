# devscripts
Development scripts

## Contents

### checksize.sh
Checks the size of the n largest tables in your DB, with n being a commandline
argument (integer).

Usage:
    **checksize.sh** database [nbr]

Parameters:
* database: which database to connect to
* nbr: how many tables to list, default 20

### restore_db.sh
(Partially) restores a pre-existing database from a given dump file. Restores
only the tables listed in a configuration file.

Usage:
    **restore_db.sh** database dumpfile

Parameters:
* database: which database to connect to
* dumpfile: which file to restore. Must be in one of postgres' non-text formats.

Config:
The script looks for a file named restore_tables in the current directory. The
idea is this file gets stored with the project in version control (or you can
maintain your own), so you can do a partial dataload for applications with
large datasets.

### schemaSpy.sh
Front-end for the schemaSpy graphical schema generator. Generates a graphical
database schema from a given postgres database, outputs a small HTML site with
the schema and some assorted information on the given database. Automatically
calles the preferred browser to display the information when done.

Will download and install schemaSpy and the correct ODBC driver if not present.
Downloads are stored in the installation folder, in ~/.devscripts/schemaSpy

Usage:
    **schemaspy.sh** database output_path

Parameters:
* database: which database to connect to
* output_path: where to write the collection of HTML + graphics

Config:
The script will prompt the user to create a config file with username, password
and preferred browser command in ~/.devscripts/settings/schemaSpy

Requirements:
Requires java and graphviz. If not present, it will install graphviz. Java is
left to the end-user.

## Installation
Simply clone this repo somewhere in your workspace and run install.sh, which
will copy the contents of this folder to ~/.devscripts and add that folder to
the PATH by updating ~/.bashrc (yes, I'm assuming everyone uses bash).

The installation folder differs from the repo folder to allow you to implement
fixes or new features without accidentally committing your personal config.

**WARNING**: every time you run install.sh, your scripts (but not configuration)
will be overwritten with the contents of the local workspace. If you have local
modifications, back up your files before running the installation script. When
implementing new features, you can edit the files in your repo, and simply run
the installer to deploy so you can test your changes before committing.
