# RecursionComic.com
## Overview
This is a [website for Rae's webcomic](https://RecursionComic.com/).

This is built with the following technologies:
### Ansible
Ansible is used to manage the application. The Ansible deployment steps are as follows:

1. Create your dev machines by using [netbox](https://netbox.thejfk.ca) and then deploy them using the [Terraform server](https://github.com/kevinabruner/terraform).
2. On the Ansible controller, first run the build.yaml playbook to build the composer files into a Drupal application
    - `ansible-playbook playbook/1-build-composer.yaml`
3. Once Drupal is built, you can deploy it to your dev servers.
    - `ansible-playbook playbook/2-deploy-dev.yaml`
4. If your dev servers work the way you like, you then bake an image from the 1st dev server
    - `ansible-playbook playbook/3-bake-image.yaml`
5. Once your image is ready, you may destroy, rebuild and reconfigure them in prod one at a time
    - `ansible-playbook playbook/4-deploy-prod.yaml`

### Keepalived 
A single IP address is maintained each for this application's dev and prod environments. The configuration file is located at `templates/keepalived.conf.j2`.

### Drupal

#### Composer
This website is built off of a basic Drupal template. The modified [drupal/composer.json](drupal/composer.json) exists at the root of this server. The composer project is compiled on the ansible controller and deployed pre-compiled to dev servers.

#### Theme and module files
Theme files are stored in this repo under [drupal/themes](drupal/themes/). There are no custom module files.

#### NFS
NFS shares for Drupal file directories will be mounted by ansible. The NAS resides at [nas.thejfk.ca](https://nas.thejfk.ca/)

#### Database cluser (Galera)
The database for this application is stored on two [Galera](https://github.com/kevinabruner/db-server) clusters. Each environment (dev and prod) have their own clusters located at:
- `db-dev.jfkhome`
- `db-prod.jfkhome`