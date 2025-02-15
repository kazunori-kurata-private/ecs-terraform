#/bin/bash

alias terraform='docker run -it --rm --env AWS_PROFILE -v ${HOME}/.aws:/root/.aws -v $(pwd):/terraform -w /terraform hashicorp/terraform:1.10.3'
alias aws='docker run -it --rm --env AWS_PROFILE -v ${HOME}/.aws:/root/.aws amazon/aws-cli:2.22.26'
