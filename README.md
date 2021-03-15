# ManyComm

## Description

ManyComm was designed as an anonymous chat application designed to help those
in crisis, such as domestic violence.  The application is built on Twilio

### Who this project is for?

ManyComm is for developers looking to help a non-profits with text/webchat technology.

### Why do they use it? Goals?

- Improve the communication between a non-profit and the community they are trying to serve through text and chat.

---

## Installing and getting the project running

### System Dependencies

- [nginx and passenger install](https://www.phusionpassenger.com/library/install/nginx/install/oss/el7/)
- PostgreSQL 9.6.4 or newer
- [Yarn](https://yarnpkg.com/lang/en/docs/install/) for frontend dependencies.

### Major Dependencies

- Ruby 2.6+
- Rails 5.2+
- VueJS 2.6

### ActionCable Production
https://www.phusionpassenger.com/library/config/standalone/action_cable_integration/#step-1-configuring-passenger

https://medium.com/swlh/deploying-a-rails-react-app-with-actioncable-to-heroku-cb5d42f41a2a


### [Detailed Setup](./readme/detailed_setup.md)

---

### [Heroku Setup](./readme/heroku_setup.md)

---

## General Notes

- [Project Outline](./readme/project_outline.md)
- link to style Guidelines (TODO)
- [Technical Debt / To Refactor](./readme/tech_debt.md)

---

## Formatting Guidelines

- Use Rails 5 standards - RuboCop will enforce standards
- Rails Best Practices will enforce code quality
- Use the gem active_model_serializers for JSON responses

### Eslint:

(Important Rules)

### Rubocop:

(Important Rules)

---

## Testing

- Code must be tested using RSpec.
- Code will be checked with RuboCop.
- Frontend Code will be check against ESLint
- Code will be checked with Rails Best Practices

---

## Contributing

EVERY BRANCH SHOULD PASS CIRCLECI BEFORE BEING MERGED

- Master should always be deployable and stable
- For each feature, task, or bug:
- Branch from Master
- Name your branch username/feature-name
- Commits:
    - At minimum a commit should be done at the end of every working day even if not finished.
    - Commits should contain a comment that explains what was done.
    - Each ticket should have a corresponding branch that is prefixed with the authors name and has the story name.
    - Examples:
        - If I worked on feature, "User Login", I would have a branch "weshays/feature-user-login,
        - If Blake worked on bug, "User Login Bug", it would be "blake/bug-user-login".
- When a feature or bug is ready to merge you will make sure your branch is up to date with master, and then issue a pull request on Github.
- Make sure all your code is commited for your branch
- Change to master and do a git pull
- Switch back to your branch and "git rebase master -i"
- Squash all your WIP commits and make the feature a single commit.
- Push your branch to Github
- Create a pull request for your branch
- You should not merge your own pull requests into master unless it's an emergency.
- Another team member should review the pull request and do the merge if everything looks good.

---


### Deployment

App deployment
mina deploy stage=production branch=master

Updating cron tasks
* https://github.com/javan/whenever
1) su - www
2) cd into apparelgraphics/www/current/
3) bundle exec whenever --update-crontab

---

## License

This plugin is released under the MIT license (see LICENSE).

This plugin was originally developed by the BenefitMany team:
* Wes Hays (https://github.com/weshays)
* Blake Campebell (https://github.com/BlakeCampbells)
* Tony Smith (https://github.com/tsmithsounds)
* Garrett Cooper (https://github.com/GarrettCooper)

The current maintainers are:
* Wes Hays (https://github.com/weshays)
* Blake Campebell (https://github.com/BlakeCampbells)
