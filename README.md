# Docker Related


1. Display list of tags for all the repositories hosted on private docker registry.
2. Delete docker repository from Private registry.

 ## 1. [Display list of tags for all the repositories hosted on private docker registry](https://github.com/deepforu47/DevOps/blob/master/docker/docker-tag-list.sh)
Adding script `docker-tag-list.sh` which you can use to get list of available tags on all repositories.
* Run script as `./docker-tag-list.sh -u username`  // Here I am assuming that you have authentication enabled for git repository.
* Script Usages
```
~]$  ./docker-tag-list.sh 

docker repo tags   --  list all tags for all available Docker images on a remote registry.

EXAMPLE: 
    - ./docker-tag-list.sh -u user
```
* Script Output
```
~]$  ./docker-tag-list.sh testuser
Password:

Tags List for Docker Repository 2.0:
     1	---------> latest


Tags List for Docker Repository jboss-fuse-6/fis-java:
     1	---------> 1.0


Tags List for Docker Repository jenkins:
     1	---------> 2.0
     2	---------> 2.89.2


Tags List for Docker Repository springboot-demo:
     1	---------> 1.0
     2	---------> 1.1


Tags List for Docker Repository ubuntu:
     1	---------> null
```

## 2. [Delete docker repository from Private registry](https://github.com/deepforu47/DevOps/blob/master/docker/Delete%20docker%20repository%20from%20Private%20registry.md)
 
   *Detail steps for deleting the repository from private docker registry*
        

