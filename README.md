# PHP 7.4 + Apache Docker development and production environment for WordPress, Drupal, Laravel or Lumen

This is a Docker image that allows you to have a local development environment with PHP, MySQL and phpMyAdmin and use the same PHP image in your production application. It is suitable for a wide variety of PHP applications such as WordPress, Drupal, Laravel and more.

Aside from the base Apache PHP 7.4 image, it also includes the following modules:

* ImageMagick
* Memcached
* GD2
* MySQLi
* PDO
* Opcache
* mod_rewrite

**Note:** `/var/www/src` inside the container must be mapped to a volume on the host.

### How does it work?

* While you are developing your application, you use `docker-compose` which uses the base `Dockerfile` and mounts your local `/src` folder inside it. This means you can develop your application without restarting the container. The `docker-compose` also starts a MySQL database and a phpMyAdmin container for easy administration.
* For the production workflow we use GitHub Actions and the GitHub Package Registry. Every time you push to `master` a Docker image is built based on the `Dockerfile` and all the files in the `/src` folder are baked into it. This means you can then run this image anywhere in your production environment, as the image we build has all the application files. (see bottom of this readme for detailed instructions).

# Locally starting a dev environment with PHP, MySQL and phpMyAdmin

Copy the env file. You can put any local environment values here:

```
cp env_file.example env_file
```

Start the service:

```
./run.sh
```

Or start it manually:

```
docker-compose build && docker-compose up --force-recreate
```

You can now go to http://localhost:8080 and you should be greeted by the `src/index.php` file which should say something like:

```
Hello from container: 653decc6127e
```

### MySQL credentials 
There is a default empty MySQL database configured you can use in your application:

* User: `app`
* Password: `secret`
* Database name: `db`
* Database host: `db`

# Services

Main PHP service:

http://localhost:8080

phpMyAdmin (DB management):

http://localhost:8001/

# Folder structure

```
- /src # Source folder for your code
- /src/vendor/autoload.php # Autoloader that needs to be included in your code
- /composer.json # Composer file for your dependencies
- /composer.lock # Lockfile
- /db # Database files from MySQL are saved here
```

# Composer

There is an empty Composer file at the root. You can add your project dependencies here.

# SSH into PHP image

```
docker exec -it php-wp-docker_php_1 "bash"
```

# Using the Docker image in production

We're going to show how to use GitHub and the GitHub Docker Package repository to build a Docker image with your application code. 

You need to:
* [Duplicate this repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)
* Put your application code in the `/src` folder.
* Modify `/.github/workflows/main.yml` and change `username: khromov` to `username: <your GitHub username>`.
* Push your changes.
* GitHub should build a Docker image for you and push it to `docker.pkg.github.com/<your username>/php-wp-docker/php-wp-docker:master`
* Now you can pull the image and run it in any way you want. For example if you just want top start the image, you can run: `docker run -p 8080:80 docker.pkg.github.com/khromov/php-wp-docker/php-wp-docker:master`

### Runing just the Apache/PHP image without docker-compose

```
docker pull docker.pkg.github.com/khromov/php-wp-docker/php-wp-docker:master
docker run -p 8080:80 -v /your-path-on-host/var/www/:/var/www/src php-wp-docker_php
```
