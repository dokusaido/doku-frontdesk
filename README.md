# doku-frontdesk

A front desk system for both civilians and PD to get the attention of either the PD or High Command.

---

## Overview

**Non‑Police Players:**  
When a non‑police player triggers the front desk, it sends a report to all online police. A temporary map blip is created at the front desk for all officers, and a doorbell sound is played for nearby players.

**Police Players:**  
When a police officer interacts with the front desk, they are presented with a qb-menu that allows them to “Contact High Command.”  
Selecting “Contact High Command” notifies only police with a sufficient grade (configurable) and acknowledges the reporting officer with notifications, a doorbell sound, and a map blip.

---

## Features

- **Job-Based Logic:** Uses qb-core job data to determine the appropriate flow for police and non‑police players.
- **Cooldown Mechanism:** Prevents spam by enforcing a cooldown period (default 60 seconds) on reports.
- **Doorbell Sound:** Integrates with InteractSound to play a doorbell sound when the front desk is triggered.
- **Notifications & Map Blip:** Provides immediate feedback through QBCore notifications and creates a temporary map blip (sprite 42) at the front desk location.
- **Customizable:** Coordinates, cooldown times, notification messages, and grade thresholds can be adjusted to fit your server’s setup.

---

## Dependencies

This script requires the following resources to be installed and running on your server:
- **qb-core**
- **qb-menu**
- **ox-target**
- **InteractSound**

---

## Installation

1. **Resource Setup:**  
   Place the entire resource folder (with `fxmanifest.lua`, client, and server scripts) into your server’s resources folder.

2. **Configure Dependencies:**  
   Ensure that the dependencies are installed and referenced correctly in your server configuration.

3. **Start the Resource:**  
   Add the following line to your `server.cfg` (or equivalent):
    ensure doku-frontdesk

4. **Adjust Settings:**  
   Modify the coordinates, cooldown times, and notification messages as needed for your server’s setup.

---

## ox-target Integration

Add the following configuration to your ox-target resource to define the PD Front Desk zone:
-- Police Front Desk
["PD-FrontDesk"] = {
name = "PD-FrontDesk",
points = {
 vector2(-584.1972, -415.3718),
 vector2(-585.7954, -415.6608),
 vector2(-585.9382, -428.6439),
 vector2(-584.3678, -428.9000),
},
polyOptions = {
 name = "PD-FrontDesk",
 debugPoly = false,
 minZ = 33.17,
 maxZ = 37.17
},
options = {
 {
   type = "client",
   event = "FrontDesk:handleAssistance",
   icon = "fas fa-bell",
   label = "Front Desk",
 }
},
},
