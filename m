Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:33665 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZKGM1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 07:27:40 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-wireless@vger.kernel.org
Subject: Looking for a low power wireless USB adapter
Date: Sat, 7 Nov 2009 12:57:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911071257.59575.jkrzyszt@tis.icnet.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am developing software for Amstrad E3 (Delta), an ARM OMAP based videophone. 
The machine is not a new design and has no network adapter on board, but 
forunately it has USB port. I have no problems connecting it to a wired 
network using an Ethernet dongle.

However, trying to use a wireless USB adapter, I have hardware issues. I 
suspect it is USB power consumption that matters (the port was designed for 
connecting a printer).

My wireless adapter is rt73 based, lsusb -v shows MaxPower 300mA. The wired 
adapter that works for me shows MaxPower of 144mA. Rather that using an 
external powered USB hub, I'd like to find a wireless adapter that is 
supposed to consume less than 300mA (while not in idle :-)). However, 
hardware vendors seem to not publish such information at all.

I'm sure that many of you, wireless developers, have a few different USB 
adapters on hand. I'd be glad if you could have a look at them and give me 
information on power consumption of your device as shown by lsusb if less 
than 300mA.

Thanks,
Janusz

PS. Sorry for abusing a developer list.
