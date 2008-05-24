Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:41863 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYEXX1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 19:27:36 -0400
Received: from [192.168.1.10] (ool-44c60ac6.dyn.optonline.net [68.198.10.198])
 by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K1E0039GBTZBFX0@mta2.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 24 May 2008 19:27:35 -0400 (EDT)
Date: Sat, 24 May 2008 19:27:35 -0400
From: Jerry Quinn <jlquinn@optonline.net>
Subject: ath5k can't connect on 5424
To: linux-wireless@vger.kernel.org
Message-id: <4838A467.1000700@optonline.net> (sfid-20080525_012739_536512_B139846E)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.  I just installed compat-wireless 2008-05-24.

The good news is that ath5k now loads into the kernel and can talk to the 
chip.  However, beyond that, the device doesn't do anything.  During modprobe 
ath5k, I get


ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
ath5k_pci 0000:03:00.0: registered as 'phy1'
phy1: Selected rate control algorithm 'pid'
ath5k phy1: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)
udev: renamed network interface wlan0 to ath0

The pci id for the chip is 168c:1014 (rev 01).  This is an IBM Thinkpad T60p, 
running Debian testing with kernel 2.6.25-2-686, the latest dist kernel available.

When I try to bring up the interface I just get a link is not ready message in 
the kernel log with no other info.  Also, iwlist ath0 scan gives me no results 
either (I did ifconfig ath0 up beforehand).

Let me know if there's any further diagnosis I can provide to help out.

Thanks,
Jerry
