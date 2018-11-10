# myip-resource

Concourse resource that will provide the public IP address that the worker is running on. Useful to implement something like dynamic dns or update firewall rules in AWS, GCP, etc. when your address at home changes.

It uses `api.ipify.org` to fetch the IP and makes available in a file called `ip`. Any other service can be used that return the plain IP via a curl like `ipify.org`

```
$ curl api.ipify.org
1.1.1.1
```

Usage:

```
resource_types:
- name: myip-resource
  type: docker-image
  source:
    repository: mrbuk/myip-resource
    tag: latest

resources:
- name: myip
  type: myip-resource
  source:
    # default
    #uri: https://api.ipify.org
    # change to a local server for testing
    #uri: http://192.168.0.100:8080

jobs:
- name: job-myip
  plan:
  - get: myip
    trigger: true
  - task: cat-myip
    config:
      platform: linux
      image_resource:
        type: docker-image
        source: {repository: busybox}
      inputs:
        - name: myip
      run:
        path: cat
        args:
        - myip/ip
```

**Note:** Besides the IP also a date is being returned as part of the resource. This is used for versioning purposes. Without a date an IP address that triggered a pipeline would not trigger it again (e.g. when IP1 -> IP2 -> IP1) 

