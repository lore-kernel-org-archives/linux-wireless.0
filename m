Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:34058 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2LPByQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 20:54:16 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Realtek RTL8192DU
Date: Sun, 16 Dec 2012 02:54:06 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>
References: <5087035E.9010609@lwfinger.net>
In-Reply-To: <5087035E.9010609@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212160254.11739.s.L-H@gmx.de> (sfid-20121216_025421_127015_840E73B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tuesday 23 October 2012, Larry Finger wrote:
> Arend and Franky,
> 
> I recently purchased a Belkin N600 DB USB dongle on Ebay. I wanted to get the 
> model with a Realtek RTL8192DU chip.
[…] 
> I have since acquired a different device with the Realtek chip, thus I could 
> return the Belkin device;
[…]

As I just got hold of a Realtek RTL8192DU device (DeLock 88540[1]), I'm
curious if you had a go with a driver for this chipset. The vendor 
driver seems to have issues with 64 bit operation (and kernel 3.7).

usb 3-1.1: new high-speed USB device number 6 using ehci_hcd
usb 3-1.1: New USB device found, idVendor=0bda, idProduct=8194
usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-1.1: Product: 802.11n NIC
usb 3-1.1: Manufacturer: Realtek
usb 3-1.1: SerialNumber: 00e04c000001

Regards
	Stefan Lippers-Hollmann

[1]	http://www.delock.com/produkte/G_88540/merkmale.html?setLanguage=en
