# Detailed Setup

### Rails Version
* Rails 5.2 (latest stable version)

### Ruby version
* Ruby 2.6


### System dependencies
* Apache 2.2 or 2.4 or Nginx 1.6
* PostgreSQL 9.6.4 or newer
* [Yarn](https://yarnpkg.com/lang/en/docs/install/) for frontend dependencies.


## Configuration

### Submodules
This project uses submodules for the Vue frontend. (Git I think needs to be setup using SSH on the machine)
Setup:
```
git submodule init
git submodule update
```


### SSL from LetsEncrypt

./certbot-auto certonly --webroot -w /home/www/manycomm/www/current/public -d app.manycomm.io


### Master.key file format

twilio:
  api_key: TWILIO_API_KEY
  api_secret: TWILIO_API_SECRET
  account_sid: TWILIO_ACCOUNT_SID

sendgrid:
  production:
    api_key_name: SENDGRID_API_KEY_NAME
    api_key: SENDGRID_API_KEY
    domain: YOUR_DOMAIN


#### Production Environment Variables

* Database Secrets
```bash
DATABASE_NAME: ''
DATABASE_ADAPTER: ''
DATABASE_ENCODING: ''
DATABASE_POOL:  ''
DATABASE_USERNAME: ''
DATABASE_PASSWORD: ''
```

* Application Secrets
```bash
SECRET_KEY_BASE: ''
```

* SMTP Configuration
```bash
FROM_EMAIL: ''
```

* Rails configuration variables
```bash
RAILS_SERVE_STATIC_FILES: ''
RAILS_LOG_TO_STDOUT: ''
```

* If you are using Foreman / Upstart to handle background jobs
```bash
cp ./config/database.example.yml ./config/database.yml
cp ./env ./.env
cp ./foreman ./.foreman
```

To run Upstart in production for CentOS 7
```
1) su to root
2) cd /home/www/manycomm/www/current
3) bundle exec foreman export -d /home/www/manycomm/www/current --app manycomm --user www systemd /lib/systemd/system/
4) /bin/systemctl enable manycomm.target
5) /bin/systemctl start manycomm.target

```

* If you are using RVM
```bash
  cp ./ruby-version ./.ruby-version
  cp ./ruby-gemset ./.ruby-gemset
```

#### Database creation and initialization
```bash
  rails db:create
  rails db:migrate
  rails db:migrate RAILS_ENV=test
  rails db:seed # for test data
  yarn # install webpack and frontend-dependencies.
```

#### Authentication
  - Use the postman collection: Create session
  [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/4a166f9109f6270e7a71)


### Services (job queues, cache servers, search engines, etc.)
Running "foreman start" it will start the background processes found in the ".foreman" file.


### Build documentation
```bash
rake docs:generate:ordered
```

To view the API docs start Rails, and then open a browser to http://localhost:3000/api/docs

### Mocha Documentation
```bash
  yarn run test
```

### ESLint Documentation
- If you want to use ESLint globally you'll need to run
  ```bash
    npm i -g eslint
    npm i -g eslint-plugin-vue@beta
  ```
  - Then you can run locally
  ```bash
    eslint --ext vue,js app/javascript
  ```
- Otherwise after doing an npm install
  ```bash
    ./node_modules/.bin/eslint --ext js,vue app/javascript
  ```