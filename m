Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:38382 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYHSVz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 17:55:58 -0400
Received: from [195.4.92.22] (helo=12.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID niklas@wulf-home.de) (port 25) (Exim 4.69 #19)
	id 1KVZBE-0002LG-PM
	for linux-wireless@vger.kernel.org; Tue, 19 Aug 2008 23:55:56 +0200
Received: from i53871248.versanet.de ([83.135.18.72]:58571 helo=niklas-mac.local)
	by 12.mx.freenet.de with esmtpsa (ID niklas@wulf-home.de) (TLSv1:AES256-SHA:256) (port 465) (Exim 4.69 #12)
	id 1KVZBE-0006Iy-Jq
	for linux-wireless@vger.kernel.org; Tue, 19 Aug 2008 23:55:56 +0200
Message-ID: <48AB5D89.5090705@wulf-home.de> (sfid-20080819_235602_387940_A1BD9119)
Date: Wed, 20 Aug 2008 01:55:53 +0200
From: Niklas Wulf <niklas@wulf-home.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on
 4311
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I tested this one on my Macbook Pro (3,1).

# lspci -v
0b:00.0 Network controller: Broadcom Corporation BCM4328 802.11a/b/g/n
(rev 05)
Subsystem: Apple Computer Inc. Device 008c
Flags: bus master, fast devsel, latency 0, IRQ 16
Memory at 97300000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Capabilities: [58] Vendor Specific Information <?>
Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
Capabilities: [d0] Express Endpoint, MSI 00
Kernel driver in use: b43-pci-bridge
Kernel modules: ssb

It is not recognized by the driver... should it? I don't get a wireless
device listed in ifconfig nor does dmesg show any device.

# ifconfig
eth0 [...]
lo [...]

# dmesg
[...]
Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
[...]

I'm kind of new to all this wireless stuff. Linuxwireless.org tells me
4328 does not work because of missing N Phys support, so I hoped this
patch would make some difference.

A problem could be the wrong firmware version. OS X says the Chip has
4.150.10.__6__ but I can only find 4.150.10.5. Is this important?

PS: This is my first mail-list-post. Tell me if something's not okay,
please ;-)

Greetings Niklas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIq12JmLNpi6N88eMRApqkAKC+HIt4LDcKcBJVywv5rQsRxpZUcACeI2OF
IoTteOy1itgYu1qtHQfgvbU=
=wM1s
-----END PGP SIGNATURE-----
