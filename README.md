# bash

# Simple Linux and UNIX Shell Script Based System Monitoring With ping Command

You can simply monitor your remote system hosted in some remote IDC. There may be many reasons for which system may out of the network. This simple script is useful to monitor your own small network at home or work.

## In order to run this script in your terminal do the following things:
```1. chmod +x /path/to/your/bashscript.sh```

run it by 

2. ```./yourscriptname.sh```

3. Install the monitorHost script as crontab using the editor:
```$ crontab -e```

## Append the following cronjob entry:
## Monitor remote host every 30 minutes using monitorHost
```30 * * * * /home/alok/bin/monitorHost```

Save and close the file.
