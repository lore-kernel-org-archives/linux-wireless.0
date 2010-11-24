Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0KXDEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 22:04:42 -0500
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Klaas De Craemer <klaasdc@gmail.com>, htl10@users.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Tue, 23 Nov 2010 21:02:33 -0600
In-Reply-To: <4CEC2292.1030808@lwfinger.net>
References: <4CEA9903.6070604@lwfinger.net>
	 <370521.43644.qm@web29514.mail.ird.yahoo.com>
	 <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
	 <4CEAC868.9040402@lwfinger.net>
	 <AANLkTim_O8SJ5xA4TWfOa2q7NXDG95-PDoXCqosiaGz3@mail.gmail.com>
	 <4CEC2292.1030808@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1290567756.3074.25.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-23 at 14:22 -0600, Larry Finger wrote:
> On 11/23/2010 01:26 PM, Klaas De Craemer wrote:
> > 
> > This morning I put the transceiver inside. I just connected it to the
> > Atom box without antenna and it reported no wireless block:
> > 
> > [  382.312044] usb 1-3: new high speed USB device using ehci_hcd and address 2
> > [  382.450722] usb 1-3: New USB device found, idVendor=0bda, idProduct=8187
> > [  382.450835] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [  382.450939] usb 1-3: Product: RTL8187_Wireless
> > [  382.451027] usb 1-3: Manufacturer: Manufacturer_Realtek_RTL8187_
> > [  382.451122] usb 1-3: SerialNumber: 00C0CA3F9517
> > [  382.451822] usb 1-3: configuration #1 chosen from 1 choice
> > [  382.743060] phy1: Selected rate control algorithm 'minstrel'
> > [  382.746490] phy1: hwaddr 00:c0:ca:3f:95:17, RTL8187vB (default) V1
> > + rtl8225z2, rfkill mask 2
> > [  382.764106] rtl8187: Customer ID is 0xFF
> > [  382.764344] Registered led device: rtl8187-phy1::tx
> > [  382.764554] Registered led device: rtl8187-phy1::rx
> > [  382.765254] rtl8187: wireless switch is on
> > [  382.765594] usbcore: registered new interface driver rtl8187
> > 
> > Then I put it back onto the antenna outside and it connected just fine.
> > 
> > I'm really confused now. Does this mean that it might be both a hard-
> > & software problem? I guess I should also check if it works fine
> > "warm" + immediately connecting it to the antenna. If temperature is
> > such a problem I might put a heating resistor inside the transceiver
> > housing...
> 
> I think we do have both a hardware problem in that your device is getting a
> false hardware block reading when cold, and that the Linux driver is missing
> some operation that compensates for this hardware error.
> 
> > The Windows driver is 6.1316.1209.2009 for Windows 7 64bit. It comes
> > with a GUI from Alfa Networks that says version 700.1604.108.201.
> 
> The only Windows 7 system here belongs to my wife, and any requests to use it
> for testing are not well received. In addition, the USB capture code I have only
> works on XP. I will try to get that driver, or as close as I can.

Snoopy Pro perhaps?  I do wish there was a free sniffer that worked on
Vista and Win7, would help sniffing 3G dongles.  The best one I can find
is USBlyzer (non-free) which is a 30 day free trial but otherwise works
pretty well.

Dan

