# bash-battery-suspend

Simple Linux daemon for suspending OS on some battery charge level. It's a crap, when my Ubuntu at 0%-2% battery level are shutdown without hibernation or without suspending. This small daemon, writted on bash, solve this issue and suspend OS when battery level at 15% (can be configured inside script). Actually at 20% we will recive alert message and at 15% - OS suspending. My laptop can keep all, in suspend mode, about 24 hours on 10% battery charge. Then I can plug battery charger and safty wakeup my laptop and continue working with all tmux sessions and all etc...

## Configuration

```sh
# Floor of battery charge percentage for alert message
BAT_SUSPEND_MSG_PERC="20"

# Floor of battery charge percentage for suspend action
BAT_SUSPEND_ACT_PERC="15"
```

## Installation/Usage

```sh
sudo wget -O /bin/battery-suspend https://github.com/vladimirok5959/bash-battery-suspend/releases/download/latest/bash-battery-suspend.sh
sudo chmod +x /bin/battery-suspend

linux:~$ battery-suspend
/bin/battery-suspend (start|stop|status)
Status: is not runned

linux:~$ battery-suspend start
Status: runned
Alert perc: 20%
Suspend perc: 15%

linux:~$ battery-suspend status
Status: runned
Alert perc: 20%
Suspend perc: 15%
```

I think it will save nerves for someone... By the way, if you know worked method for Ubuntu for controlling battery charge process (enable/disable battery charging) please write me, will be very grateful. Need to thought how to increase battery life, like this did `Asus battery health charging` utility and keep battery level always at 60% when you plugget charger for a long time.
