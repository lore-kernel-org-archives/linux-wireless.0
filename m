Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:60230 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab0GVStt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:49:49 -0400
Received: from rankine.its.manchester.ac.uk ([130.88.25.196])
	by tranquility.mcc.ac.uk with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.69 (FreeBSD))
	(envelope-from <syrotiuk@manchester.ac.uk>)
	id 1Oc0NO-0009fI-1c
	for linux-wireless@vger.kernel.org; Thu, 22 Jul 2010 19:20:10 +0100
Received: from 90.87.187.81.in-addr.arpa ([81.187.87.90]:50914)
	by rankine.its.manchester.ac.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <syrotiuk@manchester.ac.uk>)
	id 1Oc0NN-0001pj-SH
	for linux-wireless@vger.kernel.org; Thu, 22 Jul 2010 19:20:09 +0100
Message-ID: <4C488BD9.8040809@manchester.ac.uk>
Date: Thu, 22 Jul 2010 19:20:09 +0100
From: Nicholas Syrotiuk <syrotiuk@manchester.ac.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Wireless card on Debian squeeze
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Linux Wireless users,

I'm having some trouble installing the correct driver on my laptop.  I'm 
slightly confused about the revision numbering of my wireless hardware; 
that is, I'm not sure if it's revision 2 or 3.

My kernel is: 2.6.32-5
Relevant output from lspci is:
02:03.0 Network controller [0280]: Broadcom Corporation BCM4306 
802.11b/g Wireless LAN Controller [14e4:4320] (rev 02)
	Subsystem: Dell TrueMobile 1300 WLAN Mini-PCI Card [1028:0001]
	Flags: bus master, fast devsel, latency 32, IRQ 5
	Memory at fafee000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge
-----------------------------------------------

It looks like I need the b43legacy driver, which comes in a separate 
Debian package called "firmware-b43legacy-installer."  When I install 
this package, computer says: "Not supported card.  Use b43 firmware."

When I install b43 firmware, configure the interface and bring it up, 
computer says: "Firmware file b43legacy/ucode4.fw not found or load failed."

So, I am slightly confounded.  However, it has occurred to me that I may 
be getting the packages from the wrong source, which are currently:

deb http://debian.man.ac.uk/debian squeeze main
deb http://ftp.us.debian.org/debian squeeze main contrib

Any ideas?
Cheers, Nick

