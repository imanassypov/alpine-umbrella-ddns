# Alpine Linux based Umbrella Dynamic DNS IP updater Docker container

This is a lightweight Alpine Linux based docker container leveraging Cisco Umbrella Dynamic Update API (ref: https://support.umbrella.com/hc/en-us/articles/235167927-Cisco-Umbrella-Dynamic-Update-API).

Purpose of the container is to periodically check-in with Cisco Umbrella Dashboard and update a 'Network' identity construct with dynamic ip address. This offers a simple method of applying a custom Umbrella DNS policy to your network. 

This lightweight container can be deployed on Cisco Catalyst 9300 switches at a branch environment behind a dynamic IP address. Automation of container deployments on Cisco Catalyst 9300 is best accomplished via Cisco DNA Center which offers full Docker Container lifecycle management on compatible Cisco hardware. 

You can also deploy this in your home environment using Docker Desktop app on your laptop.

# New Features!

  - added syslog messsaging capability to log dynamic ip address return codes

### Pre-requisites

  - Active Cisco Umbrella DNS Security subscription
  - 'Network' element must be created with flag 'This network has a dynamic ip address'
  - 'Network' element name must match ${NETWORK} flag supplied via script

# Running docker image on local machine
Docker image leverages environment variables to execute (which can be passed via '-e' docker flag)

Environment Variables that Docker expects for correct execution:
| ENV VAR | Format |
| ------ | ------ |
| UNAME | [umbrella-username]:[umbrella-password] |
| NETWORK | [Umbrella Network Element Name] |
| RLOGIP | [Your Syslog Server IP] |

Sample Execution CLI:
```sh
docker run -it --rm -e "UNAME=cisco@cisco.com:password123" -e "NETWORK=MyDynNetwork" -e "RLOGIP=1.1.1.1" umbrella env --name umbrella
```

### Installation - create docker image
For Cisco Umbrella configuration, follow this guide: https://docs.umbrella.com/deployment-umbrella/docs/protect-your-network

On local machine, generate docker image in .tar format:
```sh
$ docker build -t umbrella .
$ docker save -o umbrella.tar umbrella
```

### Installation - deploying using Cisco DNAC
 - In Cisco DNAC (ver 1.3.3, as tested), under Provision > Services > App Hosting > New Application. Select Type: Docker, Category: Monitoring
 - Upload umbrella.tar file
 - Click new 'umbrella' icon, select 'Install'
 - Select a Catalyst 9000 switch from inventory (should read 'Ready'), and hit 'Next'
 - Device Network: Select VLAN for docker connectivity, App IP Address: 'Dynamic'
 - Select 'Docker Runtime Options' tab and fill out the parameters
 
```sh
-e "UNAME=[umbrella-username]:[umbrella-password]" -e "NETWORK=[Umbrella Network Element Name]" -e "RLOGIP=[Your Syslog Server IP]"
```

### Umbrella Dynamic DNS docker image - Return Codes
Reference: https://support.umbrella.com/hc/en-us/articles/235167927-Cisco-Umbrella-Dynamic-Update-API



| Result Code | Interpretation |
| ------ | ------ |
| badauth | Username and password credentials are invalid or do not match an existing Umbrella account. |
| nohost | 	Umbrella account specified does not have a network enabled for dynamic IP updates. Follow this link for more information. |
| good | The update was successful or not needed (the IP address has not changed since last update). Umbrella filtering and security settings are applied as configured on this network. |
| !yours | The IP address provided is part of a larger block of addresses managed by another Umbrella administrator or the IP address is being used by someone else. Please see Error Messages for more information. |
| abuse | Umbrella received more than one update per minute for a set period of time. |
| 911 | There is a problem or scheduled maintenance on the server side.  Please contact Umbrella support. |

