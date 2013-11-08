# Deployd

Sinatra Web app that listens to URL hook calls from gitlab.

# Setup

```
git clone git@github.com:leucos/deployd.git
cd deployd
bundle
```

Put your app config in config/keys.rb

edit init script (app dir, user, ...) and Copy init script at the right place :

```
sudo cp init.d/deployd /etc/init.d
chmod +x /etc/init.d/deployd
update-rd.d deployd defaults
```

Note : the use deployd is run as must have WRITE privileges in the repos
to be modified.

# Start app

```
service deployd start
```

