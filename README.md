# docker-tempest-openstack

To build the Docker container `./build.sh` (name of the image: tempest)

To run the container, create the default configuration and list all the tests: `./run.sh`

To run api tests: `./run.sh -p -c 1  --regex '(^tempest\.(api))'`

Tempest repository is created in `/tempest`



## Author

José Riguera López  <jriguera@gmail.com> 
