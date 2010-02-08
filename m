Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:35678 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0BHTIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 14:08:30 -0500
From: Jens Westemeier <Jens_Westemeier@web.de>
To: Lorenzo Raschi <ded1549@iperbole.bo.it>,
	linux-wireless@vger.kernel.org
Subject: Re: p54pci: "device does not respond!"
Date: Mon, 8 Feb 2010 20:04:20 +0100
References: <4B6F15D1.3050307@iperbole.bo.it>
In-Reply-To: <4B6F15D1.3050307@iperbole.bo.it>
MIME-Version: 1.0
Message-Id: <201002082004.20641.Jens_Westemeier@web.de>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sonntag, 7. Februar 2010 20:34:41 schrieb Lorenzo Raschi:
> Hello,
> 
> I've been using prism54 with fullmac firmware on my gentoo router since
> one year.
> In AP mode prism54 works fine, although the fact that it works in open
> mode only (no key support).
> Because I saw prism54 is deprecated now, I'm trying to switch to p54pci
> + softmac driver. Unfortunately it doesn't work.
> 
Same problem with my fullmac SMC 2802 card. /var/log/messages gives:

p54pci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
p54pci 0000:05:01.0: firmware: requesting isl3886pci
phy2: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy2: FW rev 2.17.2.0 - Softmac protocol 7.6
phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy2: device does not respond!
p54pci 0000:05:01.0: PCI INT A disabled
p54pci: probe of 0000:05:01.0 failed with error -16

lspci gives:

Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

The card is working with prism54 driver and on my dual boot Windows XP. I 
tries all kinds of FW.

I'm running OpenSUSE 11.2 with the 2.6.31.8-0.1-desktop kernel.

Greetings, Jens.
