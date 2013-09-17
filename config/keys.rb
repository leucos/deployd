# Keys setup
#
# Format :
# 'keyname' => { :secret => 'key_secret',
#                :working_dir => '/some/directory/' }

# Where  : 
# - keyname is some name you want to address your app as
# - key_secret : some shared secret betweek hook caller and callee
# - working_dir : the directory with the git repository

# Using in gitlab :
#
# Use this URL in gitlab to trigger a repos sync :
#
# http://host:port/deploy?api_key=keyname&api_secret=key_secret
#

KEYS = { 
  'sandbox' => { :secret => 'sandbox_secret',
                 :working_dir => './sandbox/test_repos' },
}

