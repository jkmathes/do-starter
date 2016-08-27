#!/bin/bash
ssh -o "StrictHostKeyChecking no" -i ./deploy_rsa deploy@$(terraform output ip)

