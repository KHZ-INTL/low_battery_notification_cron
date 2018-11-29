# Low battery warning notification script
It is a bash script that checks the output of "acpi --battery", the battery percentage and if it is less than 26, 16 and 11% then a low/critical warning notifications is sent. The script does not exactly check for thee 25, 15 and 10% as it is invoked every 5 minutes and probably not pass the check. 

### Example screenshots
The screenshots are just for example and not taken durring low battery status. Just for graphical representation. The script is customisable if you would like to change things.

#### Low battery warning <26%
![Low Battery Warning <26%](https://github.com/KHZ-INTL/low_battery_notification_cron/blob/master/warning26.png)
#### Low battery warning <16%
![Low Battery Warning <16%](https://github.com/KHZ-INTL/low_battery_notification_cron/blob/master/warning15.png)
#### critical battery warning <11%
![Critical Battery Warning <11%](https://github.com/KHZ-INTL/low_battery_notification_cron/blob/master/critical10.png)

## Dependencies
- dunstify: alternative to notify-send, you can modify code to use notify-send instead. Replace dunstify with notify-send and remove -r option.
- elementary icons: can use other icons, look inside `/usr/share/icons/[PROVIDER]/48/status/`
- acpi: retrieve battery percentage
- cron


# Crontab
The script does not run in the background as a standalone application. It is invoked by cron every 5 minutes. Thus, you will need a time based scheduler such as Cronie. Please see the <a href="https://wiki.archlinux.org/index.php/Cron">wiki</a> on cron for more details. Please visit <a href="https://crontab.guru" target="_blank">Crontab Guru</a> website to interactively generate a crontab schedule.

### cron and notifications - notify-send/dunstify
For notify-send to be able to send notification it relies on Dbus and correct display variable?.

#### Display variable
Before calling notify-send or at the top of your crontab set the display variable. Usually:
`DISPLAY=":0"` or `DISPLAY=":0.0"`

#### Dbus
For Cron to be able to access Dbus it needs Dbus address and Xsession cookie(Xauthority)? Thus we need to source them before calling the battery warning script. One method is exporting Dbus address and the Xsession cookie to file on logon using a script.

Thanks to Cas from askubuntu.com for the script:

```
 #!/bin/bash
 # Export the dbus session address on startup so it can be used by cron
 touch $HOME/.dbus/Xdbus
 chmod 600 $HOME/.dbus/Xdbus
 env | grep DBUS_SESSION_BUS_ADDRESS > $HOME/.dbus/Xdbus
 echo 'export DBUS_SESSION_BUS_ADDRESS' >> $HOME/.dbus/Xdbus
 Export XAUTHORITY value on startup so it can be used by cron
 env | grep XAUTHORITY >> $HOME/.dbus/Xdbus
 echo 'export XAUTHORITY' >> $HOME/.dbus/Xdbus
 ```

To be able use the exported information, it needs to be sourced inside crontab, before executing the battery warning script.

`*/5 * * * * source ~/.dbus/Xdbus; /home/scripts/battery_warning.sh;`


##### Notes
The accuracy of this document is questionable and there maybe security concerns since the session cookie is exported to a file.

The code is not optimised. Any feed back/contribution is appreciated. 
