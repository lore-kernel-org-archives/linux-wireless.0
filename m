Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43220 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbaKPAFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:05:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XpnKy-0003IZ-FJ
	for linux-wireless@vger.kernel.org; Sun, 16 Nov 2014 01:05:05 +0100
Received: from b1b757ce.virtua.com.br ([b1b757ce.virtua.com.br])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 01:05:04 +0100
Received: from huge_rune by b1b757ce.virtua.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2014 01:05:04 +0100
To: linux-wireless@vger.kernel.org
From: Jens <huge_rune@hotmail.com>
Subject: Wifi OSI Level 1 / PHY
Date: Sun, 16 Nov 2014 00:01:29 +0000 (UTC)
Message-ID: <loom.20141116T005807-135@post.gmane.org> (sfid-20141116_010511_396934_98F1A549)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What I want to accomplish is to get to the digitalized RF signal (OSI 
Level 1) after the DSP Chip (Broadband Chip) has done its job on the RF 
signal received via the antenna. I hope in this way to get information 
about the frequency spectrum (Kind of Software Defined Radio but in the 5 
MHz spectrum)

After doing some research on Wifi Modules and Adapters I am not sure if 
this is possible as all the Wifi Modules that  I have found have the PHY 
portion integrated with the media access control (MAC) layer. Maybe if I 
can control the firmware I can get to the level 1 data.

With regards to moving forward I think that Atheros seems like a good 
choice as according to my search Atheros is supporting FOSS Drivers since 
a longer time. My current choice would be the TP-LINK TL-WN821N Wireless 
N300 USB Adapter which I think is using the Atheros 802.11n USB chipset 
(AR9170) where the ar9170.fw open firmware could be used.

Any thoughts would be really welcome.  Just a short comment if I am 
completely wrong with my thinking or if you have a different idea or if 
you know about some Modules or Adaptors where the MAC is not integrated 
with the PHY portion would be a great help.

Jens

