
session="bahnid"

while getopts sik flag
do
    case "${flag}" in
        s) startup='TRUE';;
        i) install='TRUE';;
        k) kill='TRUE';;
    esac
done

if [ "${kill}" = 'TRUE' ]
then
  tmux kill-session -t $session
  exit 0
fi

BAHNID_PROJECT_DIR="$HOME/projects/bahnid/"

cd "${BAHNID_PROJECT_DIR}"

tmux new-session -d -s $session

tmux rename-window -t 1 'additional'
tmux send-keys -t 'additional' 'cd bahnid-development/local-setup/traefik' C-m 
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'additional' 'traefik' C-m
fi 

tmux split -v
tmux send-keys -t 'additional' 'cd bahnid-development/local-setup/docker-compose' C-m
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'additional' 'docker-compose -f Dockerfile.local up' C-m
fi 

tmux new-window -t $session:2 -n 'keycloak'
tmux send-keys -t 'keycloak' 'cd bahnid-keycloak/dist' C-m
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'keycloak' './start-local.sh' C-m
fi 

tmux new-window -t $session:3 -n 'frontend'
tmux send-keys -t 'frontend' 'cd bahnid-frontend/bahnid-auth' C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn install' C-m
fi 

tmux split -v
tmux send-keys -t 'frontend' 'cd bahnid-frontend/bahnid-dashboard'  C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'frontend' 'yarn install' C-m
fi 

tmux new-window -t $session:4 -n 'prof-boun'
tmux send-keys -t 'prof-boun' 'cd bahnid-profile' C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn install' C-m
fi 

tmux split -v
tmux send-keys -t 'prof-boun' 'cd bahnid-bouncer'  C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'prof-boun' 'yarn install' C-m
fi 

tmux new-window -t $session:5 -n 'msg-stuf'
tmux send-keys -t 'msg-stuf' 'cd bahnid-message-broker' C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn install' C-m
fi 

tmux split -v
tmux send-keys -t 'msg-stuf' 'cd bahnid-message-multiplier'  C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'msg-stuf' 'yarn install' C-m
fi 

tmux new-window -t $session:6 -n 'not-aud'
tmux send-keys -t 'not-aud' 'cd bahnid-notifier' C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn install' C-m
fi 

tmux split -v
tmux send-keys -t 'not-aud' 'cd bahnid-auditor'  C-m
if [ "${startup}" = 'TRUE' ] && [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn install && yarn dev' C-m
fi
if [ "${startup}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn dev' C-m
fi
if [ "${install}" = 'TRUE' ]
then
  tmux send-keys -t 'not-aud' 'yarn install' C-m
fi 

tmux attach-session -t $session:1
