# do-starter
Quickly get a DigitalOcean droplet up with basic security in place

Based on the fantastic article: http://www.codelitt.com/blog/my-first-10-minutes-on-a-server-primer-for-securing-ubuntu/

To create:

```
export DO_API_KEY={your DigitalOcean API key}
sh apply.sh
```

Once available, the node can be accessed via:

```
ssh -i ./deploy_rsa deploy@`terraform output ip`
```
