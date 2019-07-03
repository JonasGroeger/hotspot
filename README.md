# Telekom Hotspot Manager

# Installation

    ./create-venv
    echo "$VIRTUAL_ENV"

The latter command should print a path ending in `venv`. If so, the installation was successful.

# Usage

## Login

To login into a Telekom hotspot, connect to it and run

    ./hotspot login USERNAME PASSWORD

where `USERNAME` is your mobile phone number without a leading zero, i.e. `4917066996699` and
`PASSWORD` is Telekom hotspot password.

You can get the password inside the Telekom Connect App ([Android](https://play.google.com/store/apps/details?id=de.telekom.hotspotlogin.de), [iOS](https://apps.apple.com/de/app/connect-app-hotspot-manager/id406968533)) or by sending an SMS containing the text `OPEN` to `9526`.

    $ ./hotspot login 4917066996699 s00-vry-gud
    {
        "status": "online",
        "logged_in_since": "14:21"
    }

## Check online status

    $ ./hotspot check
    {
        "status": "online",
        "venue": "Some_Venue_Name",
        "logged_in_since": "14:21"
    }

## Logout

    $ ./hotspot logout 
    {
        "status": "offline"
    }
