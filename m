Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:42805 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2G3UgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 16:36:18 -0400
Message-ID: <5016F03F.1020508@t-online.de> (sfid-20120730_223621_608056_76B77248)
Date: Mon, 30 Jul 2012 22:36:15 +0200
From: "Ch. Hanisch" <ch-hanisch@t-online.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

on an DELL XPS L702x under Ubuntu 12.04LTS (64Bit) the WLAN is not working.
The network manager show the message
"device is no ready"

 On an other DELL XPS L702x Notebook with the same "lspci -v" with only
one difference in graphic controller
< 01:00.0 VGA compatible controller: NVIDIA Corporation Device 0dd6 (rev ff)
---
> 01:00.0 VGA compatible controller: NVIDIA Corporation GF106 [GeForce
GT 555M] (rev ff)
works on the Notebook with "NVIDIA Corporation Device 0dd6" the WLAN well.

With a Live-DVD (64Bit) the same effect.
sudo dmidecode give no differences.
Kernel is 3.2.0-27-generic or older.

The effect is like the modul iwlwifi is not loaded (sudo rmmod iwlwifi),
although the module is loaded on both Notebooks.

Is the module dell_laptop buggy?

What can I do that the WLAN is working also on the second Notebook?
    Beschreibung: Tragbarer Rechner
    Produkt: Dell System XPS L702X (System SKUNumber)
    Hersteller: Winbond Electronics
    Version: 0.1
    Seriennummer: 8Q6TRQ1
sudo lshw
...
           *-network DEAKTIVIERT
                Beschreibung: Kabellose Verbindung
                Produkt: Centrino Wireless-N 1000
                Hersteller: Intel Corporation
                Physische ID: 0
                Bus-Informationen: pci@0000:03:00.0
                Logischer Name: wlan1
                Version: 00
                Seriennummer: 74:e5:0b:0e:b6:6c
                Breite: 64 bits
                Uhr: 33MHz
                Fähigkeiten: pm msi pciexpress bus_master cap_list
ethernet physical wireless
                Konfiguration: broadcast=yes driver=iwlwifi
driverversion=3.2.0-27-generic firmware=39.31.5.1 build 35138 latency=0
link=no multicast=yes wireless=IEEE 802.11bgn
                Ressourcen: irq:55 memory:f4300000-f4301fff
...

 regards
Ch. Hanisch

