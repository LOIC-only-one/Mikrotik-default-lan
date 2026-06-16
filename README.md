# MikroTik VLAN Segmentation

## Présentation

Cette configuration MikroTik met en place une segmentation réseau basée sur des VLANs afin d'isoler différents types d'équipements tout en fournissant un accès Internet via DHCP sur l'interface WAN.

### Fonctionnalités

- Attribution automatique de l'adresse WAN via DHCP
- Segmentation du réseau en plusieurs VLANs
- Routage inter-VLAN
- Serveur DHCP dédié pour chaque VLAN
- Intégration du Wi-Fi dans un VLAN spécifique
- Protection contre les boucles grâce à RSTP

---

## Topologie

```text
                    Internet
                        |
                    [ ether1 ]
                        |
                +----------------+
                |    MikroTik    |
                +----------------+
                        |
                 LAN - Bridge
                        |
    +-------------------+-------------------+
    |                   |                   |
 VLAN 20            VLAN 30            VLAN 10
 Serveurs            WiFi                IoT
192.168.20.0/24 192.168.30.0/24 192.168.10.0/24
```

---

## WAN

L'accès Internet est obtenu automatiquement via DHCP sur l'interface `ether1`.

| Interface | Rôle |
|------------|--------|
| ether1 | WAN / Internet |

Configuration :

```routeros
/ip dhcp-client add interface=ether1 disabled=no
```

---

## Bridge principal

Création d'un bridge unique supportant les VLANs.

| Paramètre | Valeur |
|------------|---------|
| Nom | LAN - Bridge |
| VLAN Filtering | Activé |
| STP | RSTP |

Configuration :

```routeros
/interface bridge add name="LAN - Bridge" vlan-filtering=yes protocol-mode=rstp
```

---

## VLANs

### VLAN 10 - IoT

Réseau dédié aux objets connectés.

| Paramètre | Valeur |
|------------|---------|
| VLAN ID | 10 |
| Réseau | 192.168.10.0/24 |
| Passerelle | 192.168.10.1 |

Ports associés :

- ether6
- ether7
- ether8
- ether9
- ether10

---

### VLAN 20 - Serveurs

Réseau réservé aux serveurs et équipements d'infrastructure.

| Paramètre | Valeur |
|------------|---------|
| VLAN ID | 20 |
| Réseau | 192.168.20.0/24 |
| Passerelle | 192.168.20.1 |

Ports associés :

- ether2
- ether3

---

### VLAN 30 - WiFi

Réseau destiné aux clients sans-fil.

| Paramètre | Valeur |
|------------|---------|
| VLAN ID | 30 |
| Réseau | 192.168.30.0/24 |
| Passerelle | 192.168.30.1 |

Ports associés :

- ether4
- ether5
- wlan1

---

## Mapping des ports

| Interface | VLAN | Description |
|------------|--------|-------------|
| ether1 | - | WAN |
| ether2 | 20 | Serveurs |
| ether3 | 20 | Serveurs |
| ether4 | 30 | WiFi |
| ether5 | 30 | WiFi |
| ether6 | 10 | IoT |
| ether7 | 10 | IoT |
| ether8 | 10 | IoT |
| ether9 | 10 | IoT |
| ether10 | 10 | IoT |
| wlan1 | 30 | WiFi |

---

## Configuration des PVID

Tous les ports utilisateurs sont configurés en mode access.

| Interface | PVID |
|------------|------|
| ether2 | 20 |
| ether3 | 20 |
| ether4 | 30 |
| ether5 | 30 |
| wlan1 | 30 |
| ether6 | 10 |
| ether7 | 10 |
| ether8 | 10 |
| ether9 | 10 |
| ether10 | 10 |

---

## Interfaces VLAN

Les interfaces VLAN sont créées sur le bridge principal.

| Interface | VLAN ID |
|------------|---------|
| vlan10-IoT | 10 |
| vlan20-Serveurs | 20 |
| vlan30-WiFi | 30 |

---

## Plan d'adressage

| VLAN | Réseau | Passerelle |
|--------|----------|------------|
| IoT | 192.168.10.0/24 | 192.168.10.1 |
| Serveurs | 192.168.20.0/24 | 192.168.20.1 |
| WiFi | 192.168.30.0/24 | 192.168.30.1 |

---

## DHCP

### VLAN 10 - IoT

| Paramètre | Valeur |
|------------|---------|
| Pool DHCP | 192.168.10.100 - 192.168.10.254 |
| DNS | 1.1.1.1 |

### VLAN 20 - Serveurs

| Paramètre | Valeur |
|------------|---------|
| Pool DHCP | 192.168.20.100 - 192.168.20.254 |
| DNS | 1.1.1.1 |

### VLAN 30 - WiFi

| Paramètre | Valeur |
|------------|---------|
| Pool DHCP | 192.168.30.100 - 192.168.30.254 |
| DNS | 1.1.1.1 |

---

## Fonctionnement attendu

- Les équipements connectés sur `ether6` à `ether10` reçoivent une adresse du VLAN IoT.
- Les équipements connectés sur `ether2` et `ether3` reçoivent une adresse du VLAN Serveurs.
- Les clients connectés au Wi-Fi ou sur `ether4` et `ether5` reçoivent une adresse du VLAN WiFi.
- Chaque VLAN possède son propre serveur DHCP.
- Les VLANs peuvent communiquer entre eux tant qu'aucune règle de pare-feu ne l'interdit.
- Tous les VLANs accèdent à Internet via l'interface WAN (`ether1`).

---

## Schéma logique

```text
WAN (DHCP)
   |
ether1
   |
+----------------------+
|      MikroTik        |
+----------------------+
         |
    LAN - Bridge
         |
+--------+--------+----------------+
|                 |                |
VLAN 20        VLAN 30         VLAN 10
Serveurs       WiFi            IoT
|              |               |
e2-e3      e4-e5+wlan1     e6-e10
```
