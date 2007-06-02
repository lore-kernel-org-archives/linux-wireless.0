Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:33698 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753268AbXFBUZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 16:25:13 -0400
Date: Sat, 2 Jun 2007 13:25:11 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: "bcm43xx: Firmware: no support for microcode extracted from version 4.x binary drivers" with FW from wl_apsta.o
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <926683.73696.qm@web51404.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
I gave the current wireless-dev git tree a try to get some exposure
to the new mac80211 stack. I have a HP nx6325 with what lspci call a

Network controller: Broadcom Corporation BCM4310 UART (rev 01) 

Compiling and installing the kernel worked without a problem, but the
bcm43xx driver complains with the message in the subject line. The
full dmesg log:

bcm43xx driver
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio turned off
bcm43xx: Radio turned off
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x15f, pl 0x7e (2006-07-29  05:54:02)
bcm43xx: Firmware: no support for microcode extracted from version 4.x binary drivers.
bcm43xx: core_up for active 802.11 core failed (-95)
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
bcm43xx: Microcode rev 0x15f, pl 0x7e (2006-07-29  05:54:02)
bcm43xx: Firmware: no support for microcode extracted from version 4.x binary drivers.
bcm43xx: core_up for active 802.11 core failed (-95)
bcm43xx: Microcode rev 0x15f, pl 0x7e (2006-07-29  05:54:02)
bcm43xx: Firmware: no support for microcode extracted from version 4.x binary drivers.
bcm43xx: core_up for active 802.11 core failed (-95)
bcm43xx: Microcode rev 0x15f, pl 0x7e (2006-07-29  05:54:02)
bcm43xx: Firmware: no support for microcode extracted from version 4.x binary drivers.
bcm43xx: core_up for active 802.11 core failed (-95)

The firmware is from the openwrt archive suggested under http://linuxwireless.org/en/users/Drivers/bcm43xx

Now I'm at somewhat lost. Is there an even newer firmware (I tried the one from the NDIS bcmwl5.sys as well)?

--  
Thanks in advance and kind regards

 
       Joerg



       __________________________________ Yahoo! Clever - Der einfachste Weg, Fragen zu stellen und Wissenswertes mit Anderen zu teilen. www.yahoo.de/clever

