# Deployd

Sinatra Web app that listens to URL post-receive hook calls from Gitlab,
Github, or others.

# Prereqs

deployd will run as a special user.
You have to ensure that this user can `git clone` and `git pull` in the
destination app directory.

# Setup

Assuming you want to use deployd under user 'deploy' :

```
sudo -i
useradd deploy -d /home/deploy -m -p $(openssl passwd `uuidgen` 2> /dev/null)
cd ~deploy
su deploy -c 'git clone https://github.com/leucos/deployd.git'
su deploy -c 'cd deployd && bundle'
```

- Put your app config in /home/deploy/deployd/config/keys.rb
- Edit init script (app dir, user, ...) and copy init script at the right place :


```
cp init.d/deployd /etc/init.d
chmod +x /etc/init.d/deployd
update-rc.d deployd defaults
```

Note : the use deployd is run as must have WRITE privileges in the repos
to be modified.

# Start app

```
service deployd start
```

