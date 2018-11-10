# myip-resource

`myip-resource` is a Concourse resource that provides an IP address to tasks. At the moment it supports two modes via `source.method`. The IP address will be stored in a file called `ip` within the resource. 

`myip-resource` was developed for the use cases of
1. dynamic dns
1. trigger actions based on IP address changes (e.g. update in firewall rules in AWS, GCP, etc. when your address at home changes).

## Methods

Current supported methods: `fetch-uri` and `resolve-resource-record`

`fetch-uri` *aka* `curl` (**default**): fetch the IP address from an endpoint (default endpoint being `api.ipify.org` but any other service can be used that return the plain IP via a curl like `ipify.org`)

`resolve-resource-record` *aka* `dig`: fetch the IP address from a reference resource record fetched via DNS

## Usage

```
resource_types:
- name: myip-resource
  type: docker-image
  source:
    repository: mrbuk/myip-resource
    tag: latest

resources:
- name: myip-fetch-uri
  type: myip-resource
  source:
    # default
    #method: fetch-uri
    # default
    #uri: https://api.ipify.org
    # change to a local server for testing
    #uri: http://192.168.0.100:8080

- name: myip-resolve-resource-record
  type: myip-resource
  source:
    method: resolve-resource-record
    resource_record: google.com

jobs:
- name: fetch-uri
  plan:
  - ggget: myip-fetch-uri
    trigger: true
  - task: cat-myip
    input_mapping:
      myip: myip-fetch-uri
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

- name: resolve-resource-record
  plan:
  - get: myip-resolve-resource-record
    trigger: true
  - task: cat-myip
    input_mapping:
      myip: myip-resolve-resource-record
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

## Notes

The two modes are basically implemented at the moment in the following way:

`fetch-uri`: 
```
$ curl api.ipify.org
1.1.1.1
```

`resolve-resource-record`:
```
dig +short some-address.com
1.1.1.1
```
