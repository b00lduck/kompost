# kompost
Microservice component test framework

## example compose
```
version: '2.3'
services:
  
  kompost:
    image: kompost
    environment:
      - KOMPOST_SUBJECT_NAME=myservice
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${PWD}/..:/kompost/subject:ro      
      - ${PWD}/testcases:/kompost/testcases:ro
      - ${PWD}/environment:/kompost/subject.env:ro
```

## Container environment variables

 * KOMPOST_SUBJECT_NAME