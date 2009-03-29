Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:57942 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbZC2RRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 13:17:31 -0400
Date: Sun, 29 Mar 2009 10:17:28 -0700
From: "Mark A. Haun" <haunma@keteu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54 "device does not respond" with fullmac SMC 2802W PCI
Message-ID: <20090329101728.640ea69f@angwin.keteu.org> (sfid-20090329_191735_117071_A44786A7)
In-Reply-To: <200903291653.04974.chunkeey@web.de>
References: <20090109182322.263db101@angwin.keteu.org>
	<200901101321.50077.chunkeey@web.de>
	<20090329004237.710775ea@angwin.keteu.org>
	<200903291653.04974.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Mar 2009 16:53:04 +0200
Christian Lamparter <chunkeey@web.de> wrote:
> On Sunday 29 March 2009 09:42:37 Mark A. Haun wrote:
> > p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > p54pci 0000:0a:00.0: firmware: requesting isl3886pci
> > phy0: p54 detected a LM86 firmware
> > p54: rx_mtu reduced from 3240 to 2376
> > phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> > phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> > phy0: device does not respond!
> > p54pci 0000:0a:00.0: PCI INT A disabled 
> > p54pci: probe of 0000:0a:00.0 failed with error -16
> > 
[...]
> Well, there was one report a while ago:
> http://markmail.org/message/fotvzl5ldlgfwxbo
> (I bet you've read it already)

This looks like a rev 2 card whereas mine is rev 1 (if PCI IDs are to
be trusted).

> Of course you can give ndiswrapper with the windows driver a try.
> Let me know if it works or produces the same "-16" error.

I just tried this, but I forgot it can't work because I am running
x86_64 architecture and SMC hasn't released 64-bit drivers :(

Mark
