Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:49883 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZC2Oxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 10:53:30 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Mark A. Haun" <haunma@keteu.org>
Subject: Re: p54 "device does not respond" with fullmac SMC 2802W PCI
Date: Sun, 29 Mar 2009 16:53:04 +0200
Cc: linux-wireless@vger.kernel.org
References: <20090109182322.263db101@angwin.keteu.org> <200901101321.50077.chunkeey@web.de> <20090329004237.710775ea@angwin.keteu.org>
In-Reply-To: <20090329004237.710775ea@angwin.keteu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903291653.04974.chunkeey@web.de> (sfid-20090329_165334_482088_8863BDDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 March 2009 09:42:37 Mark A. Haun wrote:
> p54pci 0000:0a:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> p54pci 0000:0a:00.0: firmware: requesting isl3886pci
> phy0: p54 detected a LM86 firmware
> p54: rx_mtu reduced from 3240 to 2376
> phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> phy0: device does not respond!
> p54pci 0000:0a:00.0: PCI INT A disabled 
> p54pci: probe of 0000:0a:00.0 failed with error -16
> 
> > did you compile the old prism54 code as well? If yes, can you please
> > try if it works?
> 
> I tried this, but the driver is not loading correctly.  The last time
> I used it was two or three years ago.  There could be a genuine problem
> with my card, but I saw similar reports on the net which suggest to me
> there might be a problem with the old prism54 in recent kernels.
> 
> What I need to do is see if this card is working in Windows, but, I
> don't own a copy and in any case I'm not willing to go through the pain
> of putting it on this machine.  It would be a big help to know if there
> are any confirmed reports of p54 working with this particular PCI
> card.  If someone else is having success I would suspect the problem is
> my hardware.

Well, there was one report a while ago:
http://markmail.org/message/fotvzl5ldlgfwxbo
(I bet you've read it already)

Of course you can give ndiswrapper with the windows driver a try.
Let me know if it works or produces the same "-16" error.

Regards,
	Chr

Regards,
	Chr
