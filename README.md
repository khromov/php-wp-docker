# PHP Docker

This is a Docker image that allows you to have a local development environment with PHP, MySQL and phpMyAdmin and use the same PHP image in your production application. It is suitable for a wide variety of PHP applications such as WordPress, Drupal, Laravel and more.

Aside from the base Apache PHP 7.3 image, it also includes the following modules:

* ImageMagick
* Memcached
* GD2
* MySQLi
* mod_rewrite

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

There is a default empty MySQL database configured you can use in your application:

* User: `app`
* Password: `secret`
* Database name: `db`

# Services

Main PHP service:

http://localhost:8080

phpMyAdmin (DB management):

http://localhost:8001/

#### MySQL Credentials
* User: `app`
* Password: `secret`

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

#### SSH into PHP image

```
docker exec -it php-wp-docker_php_1 "bash"
```

# Using the Docker image in production

TODO