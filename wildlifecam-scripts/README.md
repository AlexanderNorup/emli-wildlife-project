# Wildlife-cam Scripts

These scripts run on the wild-life camera itself.

They are run using as `systemd` services. See `systemd_services` folder.

## Requirements

In order to run these scripts, these dependencies needs to be installed (using `sudo apt install <dependency>`):
- `exiftool`: For making metadata for pictrues
- `mosquitto-clients`: For communicating with MQTT

Alongside this, you need an MQTT broker. Use either a public one, or install one on the raspberry pi (what we did in our case).