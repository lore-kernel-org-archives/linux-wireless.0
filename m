Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mamona.cetuc.puc-rio.br ([139.82.74.4]:33592 "EHLO
	mamona.cetuc.puc-rio.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYDBLTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 07:19:41 -0400
Message-ID: <42744.201.36.161.238.1207135145.squirrel@mamao.cetuc.puc-rio.br> (sfid-20080402_121945_071477_00D9850A)
In-Reply-To: <a32f33a40804010151v6cd1c6d6w9c4e6cc03b7db01d@mail.gmail.com>
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
    <200804010010.15705.IvDoorn@gmail.com>
    <53141.201.36.161.238.1207002489.squirrel@mamao.cetuc.puc-rio.br>
    <a32f33a40804010151v6cd1c6d6w9c4e6cc03b7db01d@mail.gmail.com>
Date: Wed, 2 Apr 2008 08:19:05 -0300 (BRT)
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
From: "Felipe Maya" <fmay@cetuc.puc-rio.br>
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Cc: "Felipe Maya" <fmay@cetuc.puc-rio.br>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> How are you configuring the interface?
> What tools are you using?
ifconfig wlan0 up
iwconfig wlan0 essid COLOMBIA mode Ad-Hoc channel 3
ifconfig wlan0 192.168.1.1 netmask 255.255.255.0

> Do you get an error messages?
No errors, zero Tx
> Is there any other information that might be useful for understanding this
> bug?

//cat /proc/net/wireless
Inter-| sta-|   Quality        |   Discarded packets               |
Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc |
beacon | 22
 wlan0: 0000    0     0     0        0      0      0      0      0        0


//cat /proc/net/arp
IP address       HW type     Flags       HW address            Mask    
Device
201.36.161.1     0x1         0x2         00:05:5F:EA:1C:54     *        eth0

//common dmesg
wlan0: Trigger new scan to find an IBSS to join
wlan0: no IPv6 routers present
wlan0: Creating new IBSS network, BSSID 6e:fb:bb:15:2d:9d
wlan0: Configured IBSS beacon template based on scan results
wlan0: No active IBSS STAs - trying to scan for other IBSS networks with
same SSID (merge)


