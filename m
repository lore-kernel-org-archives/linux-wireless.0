Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752159Ab0DAEtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 00:49:00 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 01 Apr 2010 06:48:55 +0200
From: "Peter Littmann" <peter.littmann@gmx.de>
Message-ID: <20100401044855.33430@gmx.net>
MIME-Version: 1.0
Subject: rfkill from bleeding edge compat-wireless detects the Hard Status of
 my rt2500usb wrong
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have Ubuntu 9.10 with kernel 2.6.31-21-generic which shows my rt2500usb as Soft blocked after startup. So I do rfkill wifi and it is detecting two wlan-networks. But I can not get a IP-address and static IP also does'nt work (get no answer on my ping).

So I decided to install compat-wireless-2010-03-28 from bleeding edge and the result of rfkill list changed:

0: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: yes

dmesg:
[   25.025224] phy0: Selected rate control algorithm 'minstrel'
[   25.026713] Registered led device: rt2500usb-phy0::radio
[   25.026753] Registered led device: rt2500usb-phy0::quality
[   25.028106] usbcore: registered new interface driver rt2500usb
[   25.284020] phy0: device now idle
[   25.301595] ADDRCONF(NETDEV_UP): wlan0: link is not ready

Could you please suggest something to get it work?
What else informations do you need to assist me?

There is no switch on my pc for enabling/disabling it and it runs under Win XP and FreeBSD.

Thanks
Bye

Peter
-- 
Sicherer, schneller und einfacher. Die aktuellen Internet-Browser -
jetzt kostenlos herunterladen! http://portal.gmx.net/de/go/atbrowser
