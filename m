Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55034 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752908AbYIGKZO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 06:25:14 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1KcHZo-0001FY-D9
	for linux-wireless@vger.kernel.org; Sun, 07 Sep 2008 12:33:04 +0200
Date: Sun, 7 Sep 2008 12:33:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Broadcom Corporation BCM4310 USB Controller
Message-ID: <Pine.LNX.4.64.0809071146590.3981@axis700.grange> (sfid-20080907_122524_883926_343CF12F)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

The above adapter is installed in my ACER Extensa 5220, googling around I 
found various references to this chip, the main resume seems to be "works 
only with ndiswrapper." Is it true and if it is ATM, is it going to 
change?:-) Any work in progress or plans to support it natively? lspci -vv 
output is at http://home.arcor.de/g.liakhovetski/extensa5220/.

Tried brutally adding the PCI ID to the ssb driver and ssb ID to the b43 
driver. Here's the result:

ACPI: PCI interrupt for device 0000:04:00.0 disabled
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
ssb: SPROM revision 255 detected.
ssb: Unsupported SPROM revision 255 detected. Will extract v1
ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
b43-phy1: Broadcom 4312 WLAN found
b43-phy1 ERROR: FOUND UNSUPPORTED PHY (Analog 6, Type 5, Revision 1)
b43: probe of ssb0:0 failed with error -95
Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
