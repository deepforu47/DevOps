# Step 1: Listing catalogs

 ### You can list your catalogs by calling this url:

```
[kuldeep.sharma@testdvkreg01 ~]$  curl -u test1 -s -X GET https://test.docker.reg/v2/_catalog | python -mjson.tool
Enter host password for user 'test1':
{
    "repositories": [
        "2.0",
        "ubuntu"
    ]
}
```
# Step 2: Listing tags for related catalog
### You can list tags of your catalog by calling this url:

`http://YourPrivateRegistyIP:5000/v2/<name>/tags/list`

### Response will be in the following format:
```
[kuldeep.sharma@testdvkreg01 repositories]$ curl -s -u test1 -X GET https://test.docker.reg/v2/ubuntu/tags/list | python -m json.tool
Enter host password for user 'test1':
{
    "name": "ubuntu",
    "tags": [
        "1.0"
    ]
}
```
# Step 3: List manifest value for related tag
### You can run this command in docker registry container or directly on server if using docker-distributuion:

```
[kuldeep.sharma@testdvkreg01 ~]$ curl -u test1:test1 -v  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET https://test.docker.reg/v2/ubuntu/manifests/1.0  2>&1 | grep Docker-Content-Digest | awk '{print $3}'
```

### Responce will as below:

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`sha256:60ae15e1b39cc0dd660d7433af7860901b2a3d4d72bd206d5bf1ed7fd13ee07c`

### Run the command given below with manifest value:
```
[kuldeep.sharma@testdvkreg01 ~]$ curl -u test1:test1 -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE https://test.docker.reg/v2/ubuntu/manifests/sha256:60ae15e1b39cc0dd660d7433af7860901b2a3d4d72bd206d5bf1ed7fd13ee07c
* About to connect() to test.docker.reg port 443 (#0)
*   Trying 10.49.31.63...
* Connected to test.docker.reg (10.49.31.63) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* SSL connection using TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
* Server certificate:
* 	subject: CN=test.docker.reg,O=Default Company Ltd,L=Default City,C=XX
* 	start date: Dec 18 15:10:57 2017 GMT
* 	expire date: Dec 16 15:10:57 2027 GMT
* 	common name: test.docker.reg
* 	issuer: O=Default Company Ltd,L=Default City,C=XX
* Server auth using Basic with user 'test1'
> DELETE /v2/ubuntu/manifests/sha256:60ae15e1b39cc0dd660d7433af7860901b2a3d4d72bd206d5bf1ed7fd13ee07c HTTP/1.1
> Authorization: Basic dGVzdDE6dGVzdDE=
> User-Agent: curl/7.29.0
> Host: test.docker.reg
> Accept: application/vnd.docker.distribution.manifest.v2+json
> 
< HTTP/1.1 202 Accepted
< Server: nginx/1.12.2
< Date: Tue, 19 Dec 2017 15:52:26 GMT
< Content-Type: text/plain; charset=utf-8
< Content-Length: 0
< Connection: keep-alive
< Docker-Distribution-Api-Version: registry/2.0
< X-Content-Type-Options: nosniff
< Docker-Distribution-Api-Version: registry/2.0
< 
* Connection #0 to host test.docker.reg left intact

```

# Step 4: Delete marked manifests
### Run this command in your docker registy container:

```
[kuldeep.sharma@testdvkreg01 repositories]$ sudo /bin/registry garbage-collect  /etc/docker-distribution/registry/config.yml
[sudo] password for kuldeep.sharma: 
DEBU[0000] using "text" logging formatter               
DEBU[0000] filesystem.List("/docker/registry/v2/repositories")  environment=poc go.version=go1.9beta2 instance.id=d08c1fdc-1bc7-40c6-b23b-e4774b8264c6 service=registry trace.duration=54.778µs trace.file=/builddir/build/BUILD/distribution-48294d928ced5dd9b378f7fd7c6f5da3ff3f2c89/src/github.com/docker/distribution/registry/storage/driver/base/base.go trace.func=github.com/docker/distribution/registry/storage/driver/base.(*Base).List trace.id=ca877d80-eb8f-4663-b69b-a5885a788b80 trace.line=150
.
.
DEBU[0000] (*schema2ManifestHandler).Unmarshal           environment=poc go.version=go1.9beta2 instance.id=d08c1fdc-1bc7-40c6-b23b-e4774b8264c6 service=registry
2.0: marking blob sha256:3bccd459597f38e78ce95a408e506099644ca713d79157d2f3e3a7975f1c9146
2.0: marking blob sha256:6845d404a8b667689487a9afafd4d66f24ba603933c836e1f1c975bb62773327
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:492c3d6cceecaf7a07cc521137ff38afbc0ba6c1edf0fba8c3841c5f95de501d
2.0: marking blob sha256:f1213b433f51ded53ffcd434ac0a324152c35280a2ceedfd69651185622ae61c
2.0: marking blob sha256:9d6f58f18d14adbcc8d2a4e4e14466c85f0e2f4afddc01f4ce353cf1c99b3a34
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:80b818cd994bdd388de7f65cf739bd829f7e85224d2a76040b176cb4a4283039
2.0: marking blob sha256:0519b2a812d3e620836f20f43880266981eb0d1bd3296ab45a6c9adc5e05aebb
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:81edacec7b57c167be34ad0cb1cc58c32d84cc360376f934d0cf3ca4366d6964
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:220776c5c23a6c190c2fbee1e92e4af5a25257e769f7ad7ac256ceff35a90a56
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:fa5a0a9a09f59f79cdc3540059f4950472a18c55e633456a5d412f9d2769de3e
2.0: marking blob sha256:69e8fd1e93fed9074b023c436d34803a41554f95cdedae8f1d9ea5ac0d80f55a
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
2.0: marking blob sha256:a3ed95caeb02ffe68cdd9fd84406680ae93d633cb16422d00e8a7c22955b46d4
.
.
.
DEBU[0000] filesystem.Delete("/docker/registry/v2/blobs/sha256/d3/d3d0e57c2b4175923a167fc86f95f6b0a78d571620986b1e0db83c4e58949b7a")  environment=poc go.version=go1.9beta2 instance.id=d08c1fdc-1bc7-40c6-b23b-e4774b8264c6 service=registry trace.duration=70.813µs trace.file=/builddir/build/BUILD/distribution-48294d928ced5dd9b378f7fd7c6f5da3ff3f2c89/src/github.com/docker/distribution/registry/storage/driver/base/base.go trace.func=github.com/docker/distribution/registry/storage/driver/base.(*Base).Delete trace.id=0673047a-b17a-4c4c-a2f6-a6ae9525b8b1 trace.line=177
[kuldeep.sharma@testdvkreg01 repositories]$ 
```



