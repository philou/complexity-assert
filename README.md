# Rubybox

A straightforward Ruby development box using docker.

To bootstrap a new ruby project, simply clone this repo, build the image, and start on.

```shell
git clone git@github.com:philou/rubybox.git my-project
cd my-project
docker-compose build
docker-compose run rubybox
```

From then on, you're inside the ruby box.
