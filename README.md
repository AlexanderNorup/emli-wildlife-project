# EMLI Wildlife Mini-Project
GitHub page for the "Embedded Systems in Linux" mini-project on the Software Engineering Master (elective) @ SDU F24

## Project
We have to design a Linux system that manages a wild-life camera and a drone-system to take pictures, send them to the cloud and analyze them using an LLM.

The project is related to the WildDrone project https://wilddrone.eu/

Full project description:
> A camera that takes pictures based on different triggers; that does not need connection to the internet but instead offloads the pictures to a drone that periodically fly across the wildlife park and circles for a short while at each camera; and performs AI based automatic annotation of the pictures.

The wildlife camera is simulated using a Raspberry Pi 4 using a Raspberry PI Camera Module 3 as the camera.

The "drone" is simulated by a laptop that connects to a WiFi Access Point hosted by the Raspberry Pi and communicates directly with the RPi.

When the laptop is not in range of the wildlife camera (or we manually change the WiFi connection to use EDUROAM instead), the laptop now functions as "the cloud" that analyzes the pictures and pushes the resulting metadata directly to this GitHub repository.

Alongside the wildlife camera, we have a "rain-sensor" being run by a Raspberry Pi Pico. The RPi Pico is connected using USB and communicates using serial.  The rain-sensor controls a servo motor that simulates a lens-wiper

There is also an ESP32 that is an "external-wildlife trigger" which, by a press of a button (simulating an animal going over a pressure plate), will tell the RPi to take a picture. This happens over a MQTT broker hosted by the RPi.

## Authors
* [Jonas Solhaug Kaad](https://github.com/JonasKaad)
* [Victor Andreas Boye](https://github.com/VictorABoye)
* [Sebastian Christensen Mondrup](https://github.com/SebMon)
* [Alexander Vinding Nørup](https://github.com/AlexanderNorup)

**Supervisor**: Kjeld Jensen: kjen@mmmi.sdu.dk