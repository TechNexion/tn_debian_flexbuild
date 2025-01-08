#!/bin/bash

# Loop until the GNOME session for the user 'debian' starts
while true; do
    # Check if any GNOME session-related processes exist for the 'debian' user
    GNOME_SESSION_PID=$(pgrep -u "debian" -f "gnome-session"| head -1)

    if [ -n "$GNOME_SESSION_PID" ]; then
        echo "GNOME session detected for user 'debian' with PID: $GNOME_SESSION_PID"
        
        # Get the DBUS_SESSION_BUS_ADDRESS for the session
        DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/"$GNOME_SESSION_PID"/environ | cut -d= -f2-)

        if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
            echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"
            
            # Export the DBUS address so gsettings can use it
            export DBUS_SESSION_BUS_ADDRESS
            
            # Apply the GNOME settings
            gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
            gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
            gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
            gsettings set org.gnome.desktop.session idle-delay 0
            echo "Settings applied successfully."
            break
        fi
    fi

    echo "Waiting for GNOME session for user 'debian' to start..."
    sleep 5
done
