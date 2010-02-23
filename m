Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42541 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0BWSAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 13:00:40 -0500
Date: Tue, 23 Feb 2010 12:58:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jens Westemeier <Jens_Westemeier@web.de>
Cc: linux-wireless@vger.kernel.org, chunkeey@googlemail.com
Subject: Re: problem with WG511v1
Message-ID: <20100223175806.GD2928@tuxdriver.com>
References: <4B83B96A.6050605@sorengo.com> <20100223144502.GA2928@tuxdriver.com> <201002231832.31015.Jens_Westemeier@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201002231832.31015.Jens_Westemeier@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 06:32:30PM +0100, Jens Westemeier wrote:

> modprobe p54pci gives (in /var/log/messages):
> 
> p54pci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> p54pci 0000:05:01.0: firmware: requesting isl3886pci
> phy2: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy2: FW rev 2.17.2.0 - Softmac protocol 7.6
> phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy2: device does not respond!
> p54pci 0000:05:01.0: PCI INT A disabled
> p54pci: probe of 0000:05:01.0 failed with error -16

I'm guessing this is the EBUSY return from p54_download_eeprom.
I'm not immediately familiar enough with the driver to know what that
means, but perhaps your device is showing its age?  Hopefully a P54
person can provide a more concrete suggestion.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
