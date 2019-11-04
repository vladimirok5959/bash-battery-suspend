# bash-battery-suspend
Simple Linux daemon for suspending OS on some battery charge level. It's a crap, when my Ubuntu at 0%-2% battery level are shutdown without hibernation or without suspending. This small daemon, writted on bash, solve this issue and suspend OS when battery level at 15% (can be configured inside script). Actually at 20% we will recive alert message and at 15% - OS suspending. My laptop can keep all, in suspend mode, about 24 hours on 10% battery charge. Then I can plug battery charger and safty wakeup my laptop and continue working with all tmux sessions and all etc...

## Configuration
```
# Floor of battery charge percentage for alert message
BAT_SUSPEND_MSG_PERC="20"

# Floor of battery charge percentage for suspend action
BAT_SUSPEND_ACT_PERC="15"
```

## Installation and usage
```
#
```