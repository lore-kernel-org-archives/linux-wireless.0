Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:57349 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0DEKQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 06:16:05 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id E4A3014B9610D
	for <linux-wireless@vger.kernel.org>; Mon,  5 Apr 2010 12:16:01 +0200 (CEST)
Received: from [84.56.181.66] (helo=pinguin.localnet)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #4)
	id 1NyjLd-0000F6-00
	for linux-wireless@vger.kernel.org; Mon, 05 Apr 2010 12:16:01 +0200
From: Jens Westemeier <Jens_Westemeier@web.de>
To: linux-wireless@vger.kernel.org
Subject: prism54 -> p54pci transition not working
Date: Mon, 5 Apr 2010 12:16:01 +0200
References: <4B6F15D1.3050307@iperbole.bo.it> <201002082004.20641.Jens_Westemeier@web.de>
In-Reply-To: <201002082004.20641.Jens_Westemeier@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201004051216.01359.Jens_Westemeier@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a SMC 2802 card, working with Win XP and prism54, now I want to go to 
the p54pci driver.

lspci gives:

Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

modprobe p54pci gives in /var/log/messages:

p54pci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
p54pci 0000:05:01.0: firmware: requesting isl3886pci
phy2: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy2: FW rev 2.17.2.0 - Softmac protocol 7.6
phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy2: device does not respond!
p54pci 0000:05:01.0: PCI INT A disabled
p54pci: probe of 0000:05:01.0 failed with error -16

I have a 2.6.31.12-0.2-desktop 64 bit kernel from OpenSUSE 11.2 and tried with 
all flavours of fw.

In the notes I have found, that old SMC 2802 cards (without eeprom) are not 
supported. How can I check that I have such a card? Will this card been 
supported (soon)?

Greetings, Jens.
