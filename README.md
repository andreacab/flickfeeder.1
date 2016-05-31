== Flickfeeder
# Development Git flow: 
1. clone the repo
`$ git clone https://github.com/andreacab/flickfeeder.1.git flickfeeder`
2. On your local master branch, track corresponding remote branch
`$ git branch -u origin/master`
2. create a "staging" branch
`$ git checkout -b staging`
3. on your local "staging" branch track corresponding remote branch
`$ git branch -u origin/staging

Entering `$ git push` either on local "master" or "staging" branch will push correctly to the right remote branch, origin/master and origin/staging relatively

# Deployment
- staging app: `$ git push` on your local staging branch automatically deploy to heroku/flickfeeder-staging 
- prod app: `$ git push` on your local master branch automatically deploy to heroku/flickfeeder 

# Links
- staging: [flickfeeder-staging](flickfeeder-staging.herokuapp.com)
- prod: [flickfeeder](flickfeeder.herokuapp.com)

# Development 
- create .env file in your local repo and asks for keys and secrets. At time of writing, you should have the following:
    DROPBOX_KEY=...
    DROPBOX_SECRET=...
    DROPBOX_KEY_DEV=...
    DROPBOX_SECRET_DEV=...
    HOST=...
    
- to test dropbox webhook: 
(on OSX with python installed)
$ python dropbox_hook.py notify http://localhost:<PORT>/dropbox/webhook --secret <DROPBOX_SECRET_DEV> --user 1
