# recursioncomic

# Be sure to add this to your visudo 
- [username] ALL=(ALL) NOPASSWD: /home/[username]/actions-runner/_work/recursioncomic/recursioncomic/scripts/install.sh

- If using a container in proxmox, you must allow NFS shares 
- This repo uses ubuntu 22.04 at time of writing

# add the github runner
- mkdir actions-runner && cd actions-runner
- curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
- tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
- ./config.sh --url https://github.com/kevinabruner/recursioncomic --token AED3BXO5SOEMSV42FULS6TLFQDUEG
- sudo ./svc.sh install
- sudo ./svc.sh start