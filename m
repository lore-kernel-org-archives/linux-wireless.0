Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64475 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0FWJEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 05:04:37 -0400
Received: by bwz9 with SMTP id 9so400580bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 02:04:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 12:04:35 +0300
Message-ID: <AANLkTiljOFA7zY_wyP6p-4lCTHT_dhrEUuL2ktvvOsvc@mail.gmail.com>
Subject: 2.6.34 kernel + compat-wireless + Bluez-4.66 --- no Bluetooth devices
From: Andrei Moraru <andrei.moraru.n@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a machine with Centos 5.4, kernel version 2.6.34, Bluez-4.66,
compat-wireless for 2.6.34 kernel version.

The system knows about USB Bluetooth adapters

[root@voip ~]# lsusb
Bus 002 Device 004: ID 1131:1001 Integrated System Solution Corp.
KY-BT100 Bluetooth Adapter
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd
Bluetooth Dongle (HCI mode)
Bus 002 Device 003: ID 0a12:0001 Cambridge Silicon Radio, Ltd
Bluetooth Dongle (HCI mode)
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

However, hciconfig shows no devices:

[root@voip ~]# hciconfig -a
[root@voip ~]#


Also, hcitool dev

[root@voip ~]# hcitool dev
Devices:

the dmesg output about bluetooth shows

Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast


Please suggest your opinions.

Regards,
Andrei Moraru.
