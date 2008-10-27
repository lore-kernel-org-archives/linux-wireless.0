Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr05-07.mta.terra.com.br ([200.154.152.66]:18034 "EHLO
	sr05-07.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYJ0BtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 21:49:07 -0400
Message-ID: <49051E0E.2030909@terra.com.br> (sfid-20081027_024927_497802_D527F0D0)
Date: Sun, 26 Oct 2008 23:49:02 -0200
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
References: <49041DAE.1060206@terra.com.br> <49050BC7.1010609@lwfinger.net>
In-Reply-To: <49050BC7.1010609@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> What are the details of your device? Please post the output of 'dmesg | grep -i
> rtl'.

This is the built-in rtl8187b adapter:

usb 1-1: new high speed USB device using ehci_hcd and address 7
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=0bda, idProduct=8189
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: RTL8187B_WLAN_Adapter
usb 1-1: Manufacturer: Manufacturer_Realtek
usb 1-1: SerialNumber: 00e04c000001
rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
          hardware, use at your own risk
phy3: Selected rate control algorithm 'pid'
phy3: hwaddr 00:16:44:aa:df:bf, RTL8187BvE V0 + rtl8225z2

This is my external rtl8187b USB dongle:

usb 1-3: new high speed USB device using ehci_hcd and address 8
usb 1-3: configuration #1 chosen from 1 choice
rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
          hardware, use at your own risk
phy4: Selected rate control algorithm 'pid'
phy4: hwaddr 00:18:e7:42:2c:23, RTL8187BvE V0 + rtl8225z2
usb 1-3: New USB device found, idVendor=0bda, idProduct=8189
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: RTL8187B_WLAN_Adapter
usb 1-3: Manufacturer: Manufacturer_Realtek
usb 1-3: SerialNumber: 00e04c000001

Both have the same "not-working" results. Using any of my other
adapters the transmission works fine. (ok, it didn't work with
USB Marvell dongle... but it isn't even detected)

Thanks!

Piter PUNK
-- 
     |        E-Mail: piterpk@terra.com.br
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^         ----> Slackware Linux <----
  #105432
